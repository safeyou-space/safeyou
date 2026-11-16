//
//  ApplicationLaunchCoordinator.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate, LaunchViewController;

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationLaunchCoordinator : NSObject

- (instancetype)initWithRouter:(AppDelegate *)router rootVC:(LaunchViewController *)rootVC;
- (void)start;

+ (void)showWelcomeScreenAfterLogout;
- (void)showLoginWithPin;
- (void)showUpdatePinViewWithDelegate:(id)delegate;
- (void)showFakeView;


@end

NS_ASSUME_NONNULL_END
