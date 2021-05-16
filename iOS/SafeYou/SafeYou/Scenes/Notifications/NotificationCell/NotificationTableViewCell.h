//
//  NotificationTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic) NotificationDataModel *notificationData;
- (void)configureNotificationData:(NotificationDataModel *)notificationData;

@end

NS_ASSUME_NONNULL_END
