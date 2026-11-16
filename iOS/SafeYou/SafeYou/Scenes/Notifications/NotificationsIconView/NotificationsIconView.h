//
//  NotificationsIconView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableView.h"

@class NotificationsIconView;
NS_ASSUME_NONNULL_BEGIN

@protocol NotificationsIconViewAction <NSObject>

- (void)notificationBarItemAction:(NotificationsIconView *)notificationBarItem;

@end

@interface NotificationsIconView : SYDesignableView

- (void)updateBadgeValue:(NSString *)badgeValue;

- (void)setWhiteColorType;

@property (nonatomic, weak) id <NotificationsIconViewAction> delegate;


@end

NS_ASSUME_NONNULL_END
