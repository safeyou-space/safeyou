//
//  ForumNotificationsManager.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotificationDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ForumNotificationsManager : NSObject

+ (instancetype)sharedInstance;

- (void)startListeningForNotifications;
- (NSInteger)unreadNotificationsCount;
- (NSArray *)allNotifications;
- (void)readNotification:(NotificationDataModel *)notificationData;
- (void)resetBadgeCount;

@end

NS_ASSUME_NONNULL_END
