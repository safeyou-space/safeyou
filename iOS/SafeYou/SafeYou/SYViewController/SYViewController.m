//
//  SYViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"
#import "ForgotPasswordViewController.h"
#import "MBProgressHUD.h"
#import "NotificationsViewController.h"
#import "NotificationsIconView.h"
#import "MainTabbarController.h"
#import "ForumNotificationsManager.h"

@interface SYViewController () <NotificationsIconViewAction>

@property (nonatomic) NotificationsIconView *notificationsBarItemView;
@property (nonatomic) SYDesignableBarButtonItem *notificationsBarButtonItem;

@end

@implementation SYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPinHasChanged:) name:UserPinChangedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLanguageDidChange:) name:ApplicationLanguageDidChangeNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationsCount:) name:InAppNotificationsCountDidChangeNotificationName object:nil];
    [self configureBackgroundColor];
    [self configureNotificationsBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainTabbarController] hideTabbar:NO];
    [self updateLocalizations];
    [self handleNotificationsCount:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.backButtonTitle = @" ";
    [super viewWillDisappear:animated];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark - UI Customization
- (void)configureBackgroundColor {
    self.view.backgroundColor = [UIColor mainTintColor8];
}


#pragma mark - Maintabar Controller
- (MainTabbarController *)mainTabbarController
{
    return (MainTabbarController *)self.tabBarController;
}

#pragma mark - Override methods

- (void)addChildViewController:(UIViewController *)childController onView:(UIView *)childContentView
{
    childController.view.frame = childContentView.bounds;
    [childContentView addSubview:childController.view];
    [super addChildViewController:childController];
    [childController didMoveToParentViewController:self];
}

#pragma mark - Notifications BarButtonItem

- (void)configureNotificationsBarButtonItem
{
    if (self.tabBarController || self.navigationController.tabBarController) {
        if ([Settings sharedInstance].onlineUser) {
            if (!self.notificationsBarItemView) {
                self.notificationsBarItemView = [[NotificationsIconView alloc] init];
                self.notificationsBarItemView.delegate = self;
                [self.notificationsBarItemView updateBadgeValue:@""];
                self.notificationsBarButtonItem = [[SYDesignableBarButtonItem alloc] initWithCustomView:self.notificationsBarItemView];
                
                self.navigationItem.rightBarButtonItems = @[self.notificationsBarButtonItem];
            }
        }
    }
}

- (void)showNotificationsBarButtonitem:(BOOL)show
{
    if (show) {
        self.navigationItem.rightBarButtonItems = @[self.notificationsBarButtonItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[];
    }
}


#pragma mark - NotificationsIconViewAction
- (void)notificationBarItemAction:(NotificationsIconView *)notificationBarItem
{
    UIStoryboard *notificationsStoryboard = [UIStoryboard storyboardWithName:@"Notifications" bundle:nil];
    NotificationsViewController *notificationsVC = [notificationsStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:notificationsVC animated:YES];
}

#pragma mark - Handle Notifications

- (void)userPinHasChanged:(NSNotification *)notification
{
    
}

- (void)appLanguageDidChange:(NSNotification *)notification
{
    [self updateLocalizations];
}

- (void)handleNotificationsCount:(NSNotification *)not
{
    NSInteger count = [[ForumNotificationsManager sharedInstance] unreadNotificationsCount];
    NSString *badge = [NSString stringWithFormat:@"%@", @(count)];
    [self.notificationsBarItemView updateBadgeValue:badge];
}
    


#pragma mark - Interface Methods
- (void)updateLocalizations
{
}

- (void)showLoader
{
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:self.view];
    if (HUD != nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)hideLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}

@end

@implementation SYViewController (KeyboardNotifications)

- (void)enableKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}

- (void)disableKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

@end

@implementation SYViewController (Navigation)

- (void)showForgotPasswordFlow:(SYViewController *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    ForgotPasswordViewController *forgotPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    if (self.navigationController) {
        [self.navigationController pushViewController:forgotPasswordVC animated:YES];
    } else {
        UINavigationController *forgotPasswordNVC = [[UINavigationController alloc] initWithRootViewController:forgotPasswordVC];
        [self presentViewController:forgotPasswordNVC animated:YES completion:nil];
    }
}

@end

