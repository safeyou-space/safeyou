//
//  MainTabbarController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationData;

NS_ASSUME_NONNULL_BEGIN

@interface MainTabbarController : UITabBarController

- (void)hideTabbar:(BOOL)hide;

@property (nonatomic) BOOL isFromSignInFlow;
@property (nonatomic) BOOL isFromNotificationsView;
@property (nonatomic) NotificationData *selectedNotificationData;

@end

NS_ASSUME_NONNULL_END
