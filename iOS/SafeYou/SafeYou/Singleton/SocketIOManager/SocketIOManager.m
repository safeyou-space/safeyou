//
//  SocketIOManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/27/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SocketIOManager.h"

@interface SocketIOManager ()

@property (nonatomic) SocketManager *socketManager;


@end

@implementation SocketIOManager

@synthesize socketClient = _socketClient;

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
    NSURL* url = [[NSURL alloc] initWithString:[Settings sharedInstance].socketIOURL];
    NSDictionary *params = @{@"key":token};
    NSMutableDictionary *connectionConfig = [[NSMutableDictionary alloc] init];
    [connectionConfig setObject:params forKey:@"connectParams"];
    [connectionConfig setValue:@YES forKey:@"compress"];
    [connectionConfig setValue:@YES forKey:@"log"];
    [connectionConfig setValue:@YES forKey:@"secure"];
    
    self.socketManager = [[SocketManager alloc] initWithSocketURL:url config:connectionConfig];
     _socketClient = self.socketManager.defaultSocket;
    
    weakify(self);
    [self.socketClient on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        strongify(self);
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

- (void)didConnect
{
    // empty implementation
    [[NSNotificationCenter defaultCenter] postNotificationName:SOCKET_IO_DID_CONNECT_NOTIFICATION_NAME object:nil];
}

@end
