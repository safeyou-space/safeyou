//
//  MainTabbarController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MainTabbarController.h"
#import "UIColor+SYColors.h"
#import "SYUIKit.h"
#import "NotificationsViewController.h"
#import "SocketIOManager.h"
#import "ForumNotificationsManager.h"
#import "ForumsViewController.h"
#import "HelpTabbarItemViewController.h"
#import "AppDelegate.h"
#import "RoomDataModel.h"
#import "SocketIOAPIService.h"


@interface MainTabbarController () <UITabBarControllerDelegate>

@property (nonatomic) SYDesignableButton *centerButton;
@property (nonatomic) SYDesignableImageView *forumActivitiIcon;
@property (nonatomic) HelpTabbarItemViewController *helpTabBarController;
@property (nonatomic) NSInteger forumActivityCount;
@property (nonatomic) SocketIOAPIService *socketAPIService;

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SocketIOManager sharedInstance];
    [ForumNotificationsManager sharedInstance];
    self.socketAPIService = [[SocketIOAPIService alloc] init];
    [Settings sharedInstance].unreadPrivateMessages = [[NSMutableDictionary alloc] init];
    self.selectedIndex = 2;
    self.delegate = self;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLanguageDidChange:) name:ApplicationLanguageDidChangeNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDynamicLink) name:ApplicationOpenedByDynamicLinkNotificationName object:nil];
    [self configureHelpButton];
    [self configureTabbarNotificationsIcon];
    [self listenForForumActivites];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFromBackground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLocalizations];
    [self.tabBar setTintColor:[UIColor mainTintColor1]];
    [self.tabBar setUnselectedItemTintColor:[UIColor purpleColor1]];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.opaque = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkReceivedNotification];
}


#pragma mark - Handle Application State
- (void)openFromBackground
{
    [self checkReceivedNotification];
}

#pragma mark - Subscribe for data updates

- (void)listenForForumActivites
{
    if ([SocketIOManager sharedInstance].socketClient.status != SocketIOStatusConnected) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketDidConnect) name:SOCKET_IO_DID_CONNECT_NOTIFICATION_NAME object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SOCKET_IO_DID_CONNECT_NOTIFICATION_NAME object:nil];
        [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_GET_NEW_COMMENTS_COUNT with:@[] completion:^{
            NSLog(@"Emitted");
        }];
        weakify(self);
        [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_NEW_COMMENTS_COUNT_RESULT callback:^(NSArray *data, SocketAckEmitter* ack) {
            strongify(self);
            NSDictionary *receivedDataDict = data.firstObject;
            NSInteger activityCount = 0;
            if ([receivedDataDict objectForKey:@"data"]) {
                NSArray *dictArray = receivedDataDict[@"data"];
                NSArray *countsArray = [dictArray valueForKeyPath:@"count"];
                for (NSNumber *count in countsArray) {
                    activityCount += count.integerValue;
                }
            }
            self.forumActivityCount = activityCount;
            if (self.forumActivityCount > 0) {
                if (self.selectedIndex != 1) {
                    self.forumActivitiIcon.hidden = NO;
                } else {
                    self.forumActivitiIcon.hidden = YES;
                }
            } else {
                self.forumActivitiIcon.hidden = YES;
            }
        }];
    }
}

- (void)webSocketDidConnect
{
    [self listenForForumActivites];
    [[ForumNotificationsManager sharedInstance] startListeningForNotifications];
    [self getUnreadMessages];
    [self listenForPrivateMessagesUpdate];
}
    
#pragma mark - Custom View

- (void)configureTabbarNotificationsIcon
{
    UIImage *notificationsIconImage = [UIImage imageNamed:@"tabbar_notification_icon"];
    self.forumActivitiIcon = [[SYDesignableImageView alloc] initWithImage:notificationsIconImage];
    
    UIWindow *window = APP_DELEGATE.window;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    CGFloat step = self.tabBar.frame.size.width / self.tabBar.items.count;
    CGFloat originX = step + step/2 - notificationsIconImage.size.width/2;
    CGFloat originY = self.view.frame.size.height - bottomPadding - self.tabBar.frame.size.height - 40;
    CGRect frame = CGRectMake(originX, originY, notificationsIconImage.size.width, notificationsIconImage.size.height);
    [self.view addSubview:self.forumActivitiIcon];
    self.forumActivitiIcon.frame = frame;
    self.forumActivitiIcon.hidden = YES;
}

- (void)configureHelpButton
{
    CGFloat buttonSize = 130;
    self.centerButton = [[SYDesignableButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
    NSString *imageName = @"help_button_empty";
    UIImage *localizedImage = [[UIImage imageNamed:imageName] imageWithTintColor:UIColor.mainTintColor1];
    
    [self.centerButton setBackgroundImage:localizedImage forState:UIControlStateNormal];// setImage:localizedImage forState:UIControlStateNormal];
    
    UIFont *font = [UIFont extraBoldFontOfSize:18];
    [self.centerButton.titleLabel setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.centerButton.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.centerButton.titleColorType = SYColorTypeOtherAccent;
    self.centerButton.titleColorTypeAlpha = 1.0;

    [self.centerButton setTitle:LOC(@"help_title_key").uppercaseString forState:UIControlStateNormal];
        
    UIWindow *window = APP_DELEGATE.window;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    
    CGRect centerButtonFrame = self.centerButton.frame;
    centerButtonFrame.origin.y = (self.tabBar.frame.origin.y - 60 - bottomPadding);
    centerButtonFrame.origin.x = self.view.bounds.size.width/2 - centerButtonFrame.size.width/2;
    
    self.centerButton.frame = centerButtonFrame;
    
    [self.centerButton addTarget:self action:@selector(helpButtonPressedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerButton addTarget:self action:@selector(helpButtonPressedUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.centerButton addTarget:self action:@selector(helpButtonPressedDown:) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:self.centerButton];
    
    [self.view layoutIfNeeded];
}

- (void)hideCenterButton:(BOOL)hide
{
    self.centerButton.hidden = hide;
    [self.view bringSubviewToFront:self.centerButton];
}

- (void)hideTabbar:(BOOL)hide
{
    self.tabBar.hidden = hide;
    [self hideCenterButton:hide];
}

- (void)showActivityIcon:(BOOL)show
{
    if (show) {
        if (!self.forumActivitiIcon.isHidden) {
            self.forumActivitiIcon.hidden = !show;
        }
    } else {
        self.forumActivitiIcon.hidden = YES;//!show;
    }
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - Handle Notifications

- (void)appLanguageDidChange:(NSNotification *)notification
{
    [self updateLocalizations];
}

- (void)updateLocalizations
{
    [self.centerButton setTitle:LOC(@"help_title_key").uppercaseString forState:UIControlStateNormal];
    [[self.tabBar.items objectAtIndex:0] setTitle:LOC(@"forums_title_key")];
    [[self.tabBar.items objectAtIndex:1] setTitle:LOC(@"network_title")];
    [[self.tabBar.items objectAtIndex:3] setTitle:LOC(@"messages")];
    [[self.tabBar.items objectAtIndex:4] setTitle:LOC(@"title_menu")];
    
    
    [self.tabBar.items objectAtIndex:2].isAccessibilityElement = NO;
}

#pragma mark - Actions

- (void)helpButtonPressedDown:(UIButton *)sender
{
    //start recording
    self.selectedIndex = 2;
    
    if (self) {
        for (UIViewController *childViewController in self.viewControllers) {
            if ([childViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navController = (UINavigationController *)childViewController;
                if ([navController.topViewController isKindOfClass:[HelpTabbarItemViewController class]]) {
                    self.helpTabBarController = navController.topViewController;
                    [self.helpTabBarController helpTabBarButtonPressed];
                }
            }
        }
    }
}

- (void)helpButtonPressedUp:(UIButton *)sender
{
    // stop reqording
    [self.helpTabBarController helpTabBarButtonPressedUp];
}

#pragma mark - UItabbarController Delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *selectedNVC = (UINavigationController *)self.selectedViewController;
    if ([selectedNVC.viewControllers.lastObject isKindOfClass:[NotificationsViewController class]]) {
        [selectedNVC popViewControllerAnimated:NO];
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger itemIndex = [self.tabBar.items indexOfObject:item];
    if (itemIndex == 1) {
        self.forumActivitiIcon.hidden = YES;
    } else {
        self.forumActivitiIcon.hidden = !(self.forumActivityCount > 0);
    }
    
}

- (void)checkReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        RemoteNotificationType notifyType = [Settings sharedInstance].receivedRemoteNotification.notifyType;
        if (notifyType == NotificationTypeNewForum || notifyType == NotificationTypeMessage) {
            self.selectedIndex = 0;
        } else {
            [Settings sharedInstance].receivedRemoteNotification = nil;
        }
    } else if ([Settings sharedInstance].dynamicLinkUrl) {
        self.selectedIndex = 0;
    }
}

#pragma mark - Handle dynamic link

- (void)handleDynamicLink
{
    if ([Settings sharedInstance].dynamicLinkUrl) {
        self.selectedIndex = 0;
    }
}

#pragma mark - Get unread messages

- (void)getUnreadMessages
{
    weakify(self);
    [self.socketAPIService getRoomsForType:RoomTypePrivateOnToOne success:^(NSArray <RoomDataModel *> * _Nonnull roomsList) {
        strongify(self);
        NSArray *rooms = roomsList;
        for (RoomDataModel *room in rooms) {
            weakify(self);
            [self.socketAPIService getRoomUnreadMessages:room.roomKey success:^(NSArray<NSNumber *> * _Nonnull unreadMessageIds) {
                strongify(self);
                if (unreadMessageIds.count > 0) {
                    [self setPrivateMessageBadge];
                    [Settings sharedInstance].unreadPrivateMessages[room.roomKey] = unreadMessageIds;
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"Error when getting unread nessages ");
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error when getting rooms");
    }];
}

- (void)listenForPrivateMessagesUpdate
{
    weakify(self);
    [SocketIOManager sharedInstance].receivePrivateMessageBlock = ^(NSString * _Nonnull roomKey, NSNumber * _Nonnull messageId) {
        strongify(self);
        NSLog(@"Received new message with key: %@", roomKey);
        NSMutableDictionary *unreadPrivateMessages = [Settings sharedInstance].unreadPrivateMessages;
        NSMutableArray *unreadMessages = [unreadPrivateMessages objectForKey:roomKey];
        if (unreadMessages == nil) {
            unreadMessages = [NSMutableArray arrayWithObject:messageId];
            [self setPrivateMessageBadge];
        } else {
            [unreadMessages addObject:messageId];
        }
        [unreadPrivateMessages setObject:unreadMessages forKey:roomKey];
        [Settings sharedInstance].unreadPrivateMessages = unreadPrivateMessages;
    };
}

- (void)setPrivateMessageBadge
{
    [[self.tabBar.items objectAtIndex:3] setBadgeColor:[UIColor mainTintColor1]];
    [[self.tabBar.items objectAtIndex:3] setBadgeValue:@""];
}

@end
