//
//  AppDelegate.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/12/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+SyColors.h"
#import "Settings/Settings.h"
#import "MainTabbarController.h"
#import <ContactsUI/ContactsUI.h>
#import "ApplicationLaunchCoordinator.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h>
#import "PhotoGalleryViewController.h"
#import "SocketIOManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIColor+UIImage.h"
#import "FBSDKCoreKit/FBSDKSettings.h"
#import <Lokalise/Lokalise.h>

@import Firebase;
@import FBSDKCoreKit;



@interface AppDelegate () <CLLocationManagerDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

@synthesize coordinator = _coordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Settings sharedInstance];
    [self accessUserLocation];
    FBSDKSettings.sharedSettings.advertiserTrackingEnabled = YES;
    
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInternetConnectionAlert) name:NoInternetConnectionNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCommonNetworkError:) name:CommonNetworkErrorNotificationName object:nil];
    [self handleReachability];
    [GMSServices provideAPIKey:@"AIzaSyB0zzJQUGuIY2WpBqYyXlN-1_avfob4KY4"];
    
    _coordinator = [[ApplicationLaunchCoordinator alloc] initWithRouter:self rootVC:(LaunchViewController *)self.window.rootViewController];
    [self.coordinator start];
    
    [self authorizeForRemoteNotifications];
    
    [self configureFirebase];
    
    [self clearBadgeIconCount];
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [Settings sharedInstance].receivedRemoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    [FBSDKSettings setAdvertiserTrackingEnabled:YES];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    [[Lokalise sharedObject] setProjectID:LOKALISE_PROJECT_ID token:LOKALISE_TOKEN];
    [[Lokalise sharedObject] swizzleMainBundle];
#if DEBUG
    [Lokalise sharedObject].localizationType = LokaliseLocalizationPrerelease;
#endif
    
    return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
    if (dynamicLink) {
        [self handleDynamicLink:dynamicLink];
        return YES;
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                                   options:options];
    return YES;
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)){
  UIOpenURLContext *context = URLContexts.allObjects.firstObject;
  [FBSDKApplicationDelegate.sharedInstance application:UIApplication.sharedApplication
                                               openURL:context.URL
                                     sourceApplication:context.options.sourceApplication
                                            annotation:context.options.annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([Settings sharedInstance].isDualPinEnabled) {
        id rootViewController = self.window.rootViewController;
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            rootViewController = ((UINavigationController *)self.window.rootViewController).viewControllers.firstObject;
        }
        
        if ([rootViewController isKindOfClass:[MainTabbarController class]] ||
            [rootViewController isKindOfClass:[PhotoGalleryViewController class]]) {
            [self.coordinator showLoginWithPin];
        }
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Lokalise sharedObject] checkForUpdatesWithCompletion:^(BOOL updated, NSError * _Nullable error) {
            NSLog(@"Lokalise Updated %d\nError: %@", updated, error);
        if (updated) {
            NSLog(@"checkForUpdatesWithCompletion push_hold_text_key %@", LOC(@"push_hold_text_key"));
        }
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    BOOL handled = [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                            completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                                                         NSError * _Nullable error) {
        [self handleDynamicLink: dynamicLink];
    }];
    return handled;
}

- (void)handleDynamicLink:(FIRDynamicLink *)dynamicLink
{
    if (dynamicLink.url) {
        [Settings sharedInstance].dynamicLinkUrl = dynamicLink.url;
        [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationOpenedByDynamicLinkNotificationName
                                                            object:nil];
    }
}

#pragma mark - Appearence

- (void)configureNavibationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor mainTintColor1];
    [appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HayRoboto-regular" size:18]}];
    [UINavigationBar appearance].standardAppearance = appearance;
    [UINavigationBar appearance].scrollEdgeAppearance = [UINavigationBar appearance].standardAppearance;
}

- (void)configureNavibationBarAfterLogout
{
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Application main coordinator

- (void)openApplication:(BOOL)isFromSignInFlow
{
    [[SocketIOManager sharedInstance] connect];
    [self configureNavibationBar];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainTabbar" bundle:nil];
    MainTabbarController *mainController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
    mainController.isFromSignInFlow = isFromSignInFlow;
    [self setupAnimationWithDuration:0.3 transitionType:kCATransitionReveal andSubType:kCATransitionFade];
    self.window.rootViewController = nil;
    [self.window setRootViewController:mainController];
}

- (void)openFakeApplication
{
    [self configureNavibationBar];
    UIStoryboard *fakeStoryboard = [UIStoryboard storyboardWithName:@"FakeApplication" bundle:nil];
    UIViewController *initialVC = [fakeStoryboard instantiateViewControllerWithIdentifier:@"FakeViewNavigationController"];
    
    [self.window setRootViewController:initialVC];
}


#pragma mark - Internet Connection
- (void)handleReachability
{
   [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       switch (status) {
           case AFNetworkReachabilityStatusNotReachable:
               [[NSNotificationCenter defaultCenter] postNotificationName:InternetConnectionDidLost object:nil];
               [self showInternetConnectionAlert];

               break;
               
           case AFNetworkReachabilityStatusReachableViaWWAN:
           case AFNetworkReachabilityStatusReachableViaWiFi:
               [[NSNotificationCenter defaultCenter] postNotificationName:InternetConnectionDidConnected object:nil];
               break;
           case AFNetworkReachabilityStatusUnknown:
               break;
           default:
               break;
       }
   }];

   [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)showInternetConnectionAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LOC(@"error_text_key") message:LOC(@"check_internet_connection_text_key") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LOC(@"ok") style:UIAlertActionStyleCancel handler:nil]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showCommonNetworkError:(NSNotification *)notification
{
    NSString *errorMessage = (NSString *)notification.object;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LOC(@"error_text_key") message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LOC(@"ok") style:UIAlertActionStyleCancel handler:nil]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - User Location

- (void)accessUserLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}


#pragma mark - Window Transition Animation

- (void)setupAnimationWithDuration:(CFTimeInterval)duration transitionType:(NSString*)transitionType andSubType:(NSString*)transitionSubType
{
    CATransition* transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = transitionType;
    transition.subtype = transitionSubType;
    transition.startProgress = 0;
    transition.endProgress = 1;
    [self.window.layer addAnimation:transition forKey:kCATransition];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9));
{
    CLLocation *firstLoaction = locations.firstObject;
    if (![Settings sharedInstance].isLocationGranted) {
        [Settings sharedInstance].isLocationGranted = YES;
    }
    [Settings sharedInstance].userLocation = firstLoaction;
}


- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
    [Settings sharedInstance].isLocationGranted = NO;
}

- (void)authorizeForRemoteNotifications
{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
    UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:authOptions
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"Will present");
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *notUserInfo =  response.notification.request.content.userInfo;
    [Settings sharedInstance].receivedRemoteNotification = notUserInfo;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"sfsdf");
}

- (void)configureFirebase
{
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed Device token");
}

- (void)firebaseApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    NSLog(@"%@", userInfo);

    completionHandler(UIBackgroundFetchResultNewData);

    // handle remote notifications
    if (application.applicationState != UIApplicationStateActive) {

    } else {
        [self handlePushNotification:userInfo];
    }
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    // handle FCM token
    if (![[Settings sharedInstance].savedFcmToken isEqualToString:fcmToken]) {
        [Settings sharedInstance].updatedFcmToken = fcmToken;
    }
}

- (void)clearBadgeIconCount
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - HandlePushNotification

- (void)handlePushNotification:(NSDictionary *)userInfo
{
    
}


@end
