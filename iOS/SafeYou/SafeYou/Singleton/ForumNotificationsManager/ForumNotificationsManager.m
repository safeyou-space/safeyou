//
//  ForumNotificationsManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ForumNotificationsManager.h"
#import "SocketIOManager.h"
#import "NotificationData.h"
#import "SYHTTPSessionManager.h"
#import "SocketIOAPIService.h"
#import "NotificationData.h"

@interface ForumNotificationsManager ()

@property (nonatomic) NSMutableArray <NotificationData *>*receivedNotifications;
@property (nonatomic) NSInteger unreadCount;
@property (nonatomic) SocketIOAPIService *socketAPIService;

@end

@implementation ForumNotificationsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _unreadCount = 0;
        _receivedNotifications = [[NSMutableArray alloc] init];
        _socketAPIService = [[SocketIOAPIService alloc] init];
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static ForumNotificationsManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ForumNotificationsManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)startListeningForNotifications
{
    [self getBadgeCount];
    [self getNotifications];
}

#pragma mark - Socket Data

- (void)resetBadgeCount
{
    self.unreadCount = 0;
}

- (void)getBadgeCount
{
    [self listenForBadgeCount];
}

- (void)listenForBadgeCount
{
    weakify(self);
    [SocketIOManager sharedInstance].receiveNewNotificationBlock = ^(id  _Nonnull notificationData) {
        strongify(self);
        NSLog(@"Received Not is: %@", notificationData);
        NotificationData *receivedNotification = [[NotificationData alloc] initWithDictionary:notificationData];
        [self.receivedNotifications insertObject:receivedNotification atIndex:0];
        self.unreadCount += 1;        
    };
}

- (void)getNotifications
{
    // @TODO: Implement Notifications Data and Functionality
    [self.socketAPIService getUserNotificationsSuccess:^(id  _Nonnull response) {
        // @TODO: Implement Notifications Data
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSDictionary *notificationsDict = response[@"data"];
        for (NSDictionary *notificationDict in notificationsDict) {
            NotificationData *notificationData = [[NotificationData alloc] initWithDictionary:notificationDict];
            if (notificationData.notificationMessage && notificationData.notificationMessage.user) {
                [tempArray addObject:notificationData];
            }
        }
        self.receivedNotifications = tempArray;
        NSLog(@"Response is %@", response);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)listenNotificationsData
{
    //    SafeYOU_V4##GET_ALL_FORUMS#RESULT
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_NOTIFICATION_RESULT callback:^(NSArray *data, SocketAckEmitter* ack) {
        strongify(self);
        NSLog(@"Forum data %@", data);
        NSDictionary *receivedData = ((NSArray *)data).firstObject;
        NSDictionary *notificationDict = receivedData[@"data"];
        
        NotificationData *receivedNotification = [[NotificationData alloc] initWithDictionary:notificationDict];
        if (![self.receivedNotifications containsObject:receivedNotification]) {
            [self.receivedNotifications addObject:receivedNotification];
            [self sortNotificationsArray];
        }
    }];
}

- (void)readNotification:(NotificationData *)notificationData
{

}

- (NSArray *)sortedNotificationsArray
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSArray *sortedArray = [self.receivedNotifications sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
    
}

- (void)sortNotificationsArray
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    [self.receivedNotifications sortUsingDescriptors:@[sortDescriptor]];
}

- (void)setUnreadCount:(NSInteger)unreadCount
{
    _unreadCount = unreadCount;
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppNotificationsCountDidChangeNotificationName object:nil];
}

- (NSInteger)unreadNotificationsCount
{
//    return 0;
    return self.unreadCount;
}

- (NSArray *)allNotifications
{
    return [self.receivedNotifications copy];
}

@end
