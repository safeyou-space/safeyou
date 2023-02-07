//
//  NotificationsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationTableViewCell.h"
#import "MainTabbarController.h"
#import "ForumsViewController.h"
#import "NotificationData.h"
#import "SocketIOManager.h"
#import "ForumNotificationsManager.h"

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <NotificationData *> *notificationsDataSource;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[ForumNotificationsManager sharedInstance] resetBadgeCount];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNotificationsBarButtonitem:NO];
    self.notificationsDataSource = [[ForumNotificationsManager sharedInstance] allNotifications];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NotificationData *selectedNotification = selectedCell.notificationData;
    [[ForumNotificationsManager sharedInstance] readNotification:selectedNotification];
    [self openForumFromNotification:indexPath];
}

#pragma mark - Open Forum From Notification

- (void)openForumFromNotification:(NSIndexPath *)indexPath
{
    MainTabbarController *tabbatController = (MainTabbarController *)self.navigationController.tabBarController;
    NotificationData *selectedNotification = self.notificationsDataSource[indexPath.row];
    self.mainTabbarController.selectedNotificationData = selectedNotification;
    tabbatController.isFromNotificationsView = YES;
    if (tabbatController.selectedIndex != 0) {
        tabbatController.selectedIndex = 0;
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *notCell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    NotificationData *notificationData = self.notificationsDataSource[indexPath.row];
    [notCell configureNotificationData:notificationData];
    
    return notCell;
}

@end
