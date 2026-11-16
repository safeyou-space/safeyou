//
//  ForumNotificationsManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ForumNotificationsManager.h"
#import "SocketIOManager.h"

@interface ForumNotificationsManager ()

@property (nonatomic) NSInteger unreadCount;

@end

@implementation ForumNotificationsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _unreadCount = 0;
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
    [self listenForNotificationsCount];
}

#pragma mark - Socket Data

- (void)resetBadgeCount
{
    self.unreadCount = 0;
}

- (void)getBadgeCount
{
    [self listenForNewNotification];
}

- (void)listenForNewNotification
{
    weakify(self);
    [SocketIOManager sharedInstance].receiveNewNotificationBlock = ^(id  _Nonnull notificationData) {
        strongify(self);
        NSLog(@"Received Not is: %@", notificationData);
        self.unreadCount += 1;
    };
}

- (void)listenForNotificationsCount
{
    weakify(self);
    [SocketIOManager sharedInstance].notificationsCountUpdateBlock = ^(NSNumber * _Nonnull notificationsCount) {
        strongify(self);
        NSLog(@"Received notification count: %@", notificationsCount);
        self.unreadCount = notificationsCount.intValue;
    };
}

- (void)listenNotificationsData
{
    //    SafeYOU_V4##GET_ALL_FORUMS#RESULT
    [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_NOTIFICATION_RESULT callback:^(NSArray *data, SocketAckEmitter* ack) {
        NSLog(@"Forum data %@", data);
    }];
}

- (void)readNotification:(NSNumber *)notifyId
{
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:[NSNumber numberWithInt:SocketIOSignalNotificationRead]];
    [params addObject:@{@"notify_id": notifyId}];
    [[SocketIOManager sharedInstance].socketClient emit:@"signal" with:params completion:^{
        NSLog(@"Read notification with id %@", notifyId);
    }];
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

@end
