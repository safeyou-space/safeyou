//
//  ForumNotificationsManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ForumNotificationsManager.h"
#import "SocketIOManager.h"
#import "NotificationDataModel.h"

@interface ForumNotificationsManager ()

@property (nonatomic) NSMutableArray <NotificationDataModel *>*receivedNotifications;

@property (nonatomic) NSInteger unreadCount;

@end

@implementation ForumNotificationsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _unreadCount = 0;
        _receivedNotifications = [[NSMutableArray alloc] init];
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
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger seconds = time;
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSInteger finalSeconds = seconds + timeZoneSeconds;
    NSDictionary *param = @{@"datetime":@(finalSeconds)};
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_GET_NOTIFICATIONS_COUNT with:@[param] completion:^{
        strongify(self);
        [self resetBadgeCountTwice];
    }];
}

// FIXME: Workaround backend issue for resetting method should be called twice
- (void)resetBadgeCountTwice
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger seconds = time;
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSInteger finalSeconds = seconds + timeZoneSeconds;
    NSDictionary *param = @{@"datetime":@(finalSeconds)};
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_GET_NOTIFICATIONS_COUNT with:@[param] completion:^{
        strongify(self);
        [self listenForBadgeCount];
    }];
}

- (void)getBadgeCount
{
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_GET_NOTIFICATIONS_COUNT with:@[] completion:^{
        [self listenForBadgeCount];
    }];
}

- (void)listenForBadgeCount
{
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_NOTIFICATIONS_COUNT_RESULT callback:^(NSArray *data, SocketAckEmitter * emitter) {
        strongify(self);
        NSDictionary *receivedDataDict = data.firstObject;
        NSInteger badgeCount = [receivedDataDict[@"count"] integerValue];
        self.unreadCount = badgeCount;
    }];
}

- (void)getNotifications
{
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_GET_NOTIFICATION with:@[] completion:^{
        NSLog(@"Notification Data Request");
        [self listenNotificationsData];
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
        
        NotificationDataModel *receivedNotification = [NotificationDataModel modelObjectWithDictionary:notificationDict];
        if (![self.receivedNotifications containsObject:receivedNotification]) {
            [self.receivedNotifications addObject:receivedNotification];
            [self sortNotificationsArray];
        }
    }];
}

- (void)readNotification:(NotificationDataModel *)notificationData
{
    //SafeYOU_V4##READ_NOTIFICATION

    NSDictionary *params = @{@"key":notificationData.key};
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_READ_NOTIFICATION with:@[params] completion:^{
        NSLog(@"Is read");
    }];
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
