//
//  SYViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYUIKit.h"
#import "UIViewController+AlertInterface.h"

@class MainTabbarController;

NS_ASSUME_NONNULL_BEGIN

@interface SYViewController : UIViewController

- (void)updateLocalizations;

- (void)showLoader;
- (void)hideLoader;

- (void)appLanguageDidChange:(NSNotification *)notification;


// Interface need to move category

- (void)addChildViewController:(UIViewController *)childController onView:(UIView *)childContentView;

@end

@interface SYViewController (KeyboardNotifications)

- (void)enableKeyboardNotifications;
- (void)disableKeyboardNotifications;



@end

@interface SYViewController (Navigation)

- (void)showForgotPasswordFlow:(SYViewController *)sender;
- (void)showNotificationsBarButtonitem:(BOOL)show;
- (MainTabbarController *)mainTabbarController;


@end

NS_ASSUME_NONNULL_END
