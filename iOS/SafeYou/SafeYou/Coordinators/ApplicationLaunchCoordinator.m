//
//  ApplicationLaunchCoordinator.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ApplicationLaunchCoordinator.h"
#import "AppDelegate.h"
#import "Settings.h"
#import "LaunchViewController.h"
#import "LoginWithPinViewController.h"
#import "CreateDualPinViewController.h"
#import "ChooseCountryViewController.h"
#import "ChooseLanguageViewController.h"
#import "TermsViewController.h"

@interface ApplicationLaunchCoordinator () <LaunchViewControllerDelegate, LoginWithPinViewDelegate, TermsViewDelegate>

@property (nonatomic) AppDelegate *router;
@property (nonatomic) LaunchViewController *initialRootVC;

@property (nonatomic) BOOL isReady;

+ (void)showWelcomeScreenAfterLogout;

- (void)showSignInScreen;
- (void)showApplicationInitialFlow;
- (void)showLoginWithPin;
- (void)showWelcomeScreen;
- (void)showCreatePinView;

@end

@implementation ApplicationLaunchCoordinator

#pragma mark - Class Methods

+ (void)showWelcomeScreenAfterLogout
{
    UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialVC = [authStoryboard instantiateViewControllerWithIdentifier:@"WelcomeNavigationController"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = initialVC;
    [appDelegate configureNavibationBarAfterLogout];
}

#pragma mark - Initialization

- (instancetype)initWithRouter:(AppDelegate *)router rootVC:(LaunchViewController *)rootVC
{
    self = [super init];
    if (self) {
        self.router = router;
        self.initialRootVC = rootVC;
        self.initialRootVC.delegate = self;
    }
    
    return self;
}

- (void)start
{
    self.router.window.rootViewController = self.initialRootVC;
    if (![Settings sharedInstance].termsAreAccepted) {
        [self showTermsView];
    } else {
        if ([Settings sharedInstance].selectedLanguage == nil) {
            [self showChooseCountry];
        } else if (!self.isReady) {
            return;
        } else {
            
        }
    }
}

- (void)termsViewDidAcceptTerms:(TermsViewController *)termsViewController
{
    [Settings sharedInstance].termsAreAccepted = YES;
    if (self.isReady) {
        [self startApplicationInitially];
    } else {
        [self start];
    }
}

- (void)showTermsView
{
    UIStoryboard *termsStoryBoard = [UIStoryboard storyboardWithName:@"TermsViewController" bundle:nil];
    UINavigationController *termsNVC = [termsStoryBoard instantiateInitialViewController];
    TermsViewController *termsViewController = termsNVC.viewControllers.firstObject;
    termsViewController.delegate = self;
    self.router.window.rootViewController = termsNVC;
}

- (void)startMainFlow
{
    if (![Settings sharedInstance].isDualPinEnabled) {
        if ([Settings sharedInstance].onlineUser) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate openApplication:NO];
        } else {
            [self showWelcomeScreen];
        }
    } else if (!([Settings sharedInstance].userPin.length > 0)) {
        [self showWelcomeScreen];
    } else if ([Settings sharedInstance].userAuthToken.length > 0 && [Settings sharedInstance].userPin.length > 0) {
        [self showLoginWithPin];
    } else {
        [self showWelcomeScreen];
    }
}

#pragma mark - Choose Country/Language Flow

- (void)showChooseCountry
{
    ChooseCountryViewController *chooseCountryVC = [[ChooseCountryViewController alloc] initWithNibName:@"ChooseRegionalOptionsViewController" bundle:nil];
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:chooseCountryVC];
    self.router.window.rootViewController = nVC;
}

#pragma mark - case1 - First launch

- (void)showApplicationInitialFlow
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialVC = [mainStoryboard instantiateInitialViewController];
    self.router.window.rootViewController = initialVC;
}

- (void)showTutorialScreen
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
    UINavigationController *initialNVC = [[UINavigationController alloc] initWithRootViewController:initialVC];
    self.router.window.rootViewController = initialNVC;
}



#pragma mark - case2 - Launch with pin view (Get UserData is OK)

- (void)showLoginWithPin
{
    UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    LoginWithPinViewController *initialVC = [authStoryboard instantiateViewControllerWithIdentifier:@"LoginWithPinViewController"];
    initialVC.isFromSignInFlow = NO;
    initialVC.delegate = self;
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:initialVC];
    self.router.window.rootViewController = nVC;
}

- (void)showCreatePinView
{
    // empty
}

#pragma mark - case3 - User not verified (Handled from getUserData status code 202)

- (void)showSignInScreen
{
    UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    UIViewController *initialVC = [authStoryboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:initialVC];
    self.router.window.rootViewController = nVC;
}

- (void)showWelcomeScreen
{
    UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialVC = [authStoryboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:initialVC];
    self.router.window.rootViewController = nVC;
}

#pragma mark - Case4 - User not created Pin (Not actual case yet)

- (void)showUpdatePinViewWithDelegate:(id)delegate
{
    UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    CreateDualPinViewController *initialVC = [authStoryboard instantiateViewControllerWithIdentifier:@"CreateDualPinViewController"];
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:initialVC];
    [self.router.window.rootViewController presentViewController:nVC animated:YES completion:nil];
}

#pragma mark - Fake View

- (void)showFakeView
{
    UIStoryboard *fakeStoryboard = [UIStoryboard storyboardWithName:@"FakeApplication" bundle:nil];
    UIViewController *initialVC = [fakeStoryboard instantiateViewControllerWithIdentifier:@"FakeViewNavigationController"];
    self.router.window.rootViewController = initialVC;
}


#pragma mark - LaunchViewControllerDelegate

- (void)startApplicationInitially
{
    self.isReady = YES;
    if (![Settings sharedInstance].termsAreAccepted) {
        [self showTermsView];
    } else {
        [self startMainFlow];
    }
}


@end

@interface ApplicationLaunchCoordinator (LoginWithPinViewDelegate) <LoginWithPinViewDelegate>

@end

@implementation ApplicationLaunchCoordinator (LoginWithPinViewDelegate)

- (void)loginWithPinViewDidSelectForgotPin:(LoginWithPinViewController *)loginPinView
{
    [self showSignInScreen];
}

@end
