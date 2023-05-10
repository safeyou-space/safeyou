//
//  AppDelegate.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/12/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationLaunchCoordinator, CLLocationManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)openApplication:(BOOL)isFromSignInFlow;
- (void)openFakeApplication;
- (void)showInternetConnectionAlert;
- (void)configureNavibationBarAfterLogout;

@property (nonatomic, readonly) ApplicationLaunchCoordinator *coordinator;
@property (nonatomic) CLLocationManager *locationManager;

@end

