//
//  SocketIOManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/27/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SocketIOManager.h"
#import "ChatUserDataModel.h"
#import "ChatMessageDataModel.h"
#import "RoomDataModel.h"

@interface SocketIOManager ()

@property (nonatomic, strong) SocketManager *socketManager;

@end

@implementation SocketIOManager

@synthesize socketClient = _socketClient;
@synthesize chatOnlineUser = _chatOnlineUser;

+ (instancetype)sharedInstance
{
    static SocketIOManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SocketIOManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)connect
{
    [self connectSocketClient];
}

- (void)connectSocketClient
{
    NSString *token = [Settings sharedInstance].userAuthToken;
    NSString *host  = [Settings sharedInstance].socketIOURL;
    NSString *urlString = [NSString stringWithFormat:@"%@?_=%@",host, token];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    NSDictionary *params = @{@"_":token};
    NSMutableDictionary *connectionConfig =  [[NSMutableDictionary alloc] init];    [connectionConfig setObject:params forKey:@"connectParams"];
    [connectionConfig setValue:@YES forKey:@"compress"];
    [connectionConfig setValue:@YES forKey:@"log"];
    [connectionConfig setValue:@NO forKey:@"secure"];
    [connectionConfig setValue:@"3" forKey:@"EIO"];
    
    self.socketManager = [[SocketManager alloc] initWithSocketURL:url config:connectionConfig];
    _socketClient = self.socketManager.defaultSocket;
    
    weakify(self);
    
    [self.socketClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected %@", self.socketClient.sid);
        strongify(self);
        [self listenAllSignals];
        [self didConnect];
    }];
    
    [self.socketClient on:@"connect_failed" callback:^(NSArray * response, SocketAckEmitter * ack) {
        NSLog(@"Response is %@", response);
    }];
    
    [self.socketClient on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"DISCONNECTED!!!!");
    }];
    
    [self.socketClient connect];
}

- (void)listenAllSignals
{
    weakify(self);
    [self.socketClient on:@"signal" callback:^(NSArray* data, SocketAckEmitter* ack) {
        strongify(self);
        if ([data[0] integerValue] == SocketIOSignalPROFILE) { // SIGNAL_PROFILE = 0
            NSDictionary *receivedDataDict = data[1];
            NSDictionary *profileDict = receivedDataDict[@"data"];
            ChatUserDataModel *chatProfileData = [ChatUserDataModel modelObjectWithDictionary:profileDict];
            self->_chatOnlineUser = chatProfileData;
        }
        
        if ([data[0] integerValue] == SocketIOSignalMessageINSERT) {
            NSDictionary *receivedDataDict = data[1];
            NSDictionary *messageDict = receivedDataDict[@"data"];
            ChatMessageDataModel *messageData = [ChatMessageDataModel modelObjectWithDictionary:messageDict];
            if ([self.delegate respondsToSelector:@selector(socketIOManager:didInsertMessage:)]) {
                [self.delegate socketIOManager:self didInsertMessage:messageData];
            } else if (self.receivePrivateMessageBlock && !messageData.isOwner && messageData.roomKey &&
                messageData.messageId && [messageData.roomKey containsString:@"PRIVATE_CHAT"]) {
                self.receivePrivateMessageBlock(messageData.roomKey, messageData.messageId);
            }
        }
        
        if ([data[0] integerValue] == SocketIOSignalNotificationReceived) {
            NSDictionary *receivedDataDict = data[1];
            NSDictionary *notificationDict = receivedDataDict[@"data"];
            if (notificationDict) {
                if (self.receiveNewNotificationBlock) {
                    self.receiveNewNotificationBlock(notificationDict);
                }
            }
        }
        
        if ([data[0] integerValue] == SocketIOSignalNotificationsCount) {
            NSDictionary *receivedDataDict = data[1];
            NSDictionary *notificationDict = receivedDataDict[@"data"];
            if (notificationDict && notificationDict[@"notify_read_0_count"] && self.notificationsCountUpdateBlock) {
                NSNumber *notificationsCount = notificationDict[@"notify_read_0_count"];
                self.notificationsCountUpdateBlock(notificationsCount);
            }
        }
        
        if ([data[0] integerValue] == SocketIOSignalCommentCount) {
            NSLog(@"Count update reveived");
            NSDictionary *receivedDataDict = data[1];
            if ([receivedDataDict[@"error"] integerValue] == 0) {
                NSDictionary *receivedUpdateDict = receivedDataDict[@"data"];
                if (self.didReceiveCommentsCount) {
                    NSInteger commentsCount = [receivedUpdateDict[@"messages_count"] integerValue];
                    self.didReceiveCommentsCount(commentsCount);
                }
                if (self.didReceiveCommentsCountForList) {
                    NSInteger commentsCount = [receivedUpdateDict[@"messages_count"] integerValue];
                    NSNumber *forumId = receivedUpdateDict[@"forum_id"];
                    self.didReceiveCommentsCountForList(commentsCount, forumId);
                }
            }
        }
    }];
}

- (void)didConnect
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SOCKET_IO_DID_CONNECT_NOTIFICATION_NAME object:nil];
}

@end
