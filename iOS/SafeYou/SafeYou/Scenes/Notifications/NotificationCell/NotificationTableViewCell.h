//
//  NotificationTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationData;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic) NotificationData *notificationData;
- (void)configureNotificationData:(NotificationData *)notificationData;

@end

NS_ASSUME_NONNULL_END
