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
#import "DialogViewController.h"
#import "SocketIOAPIService.h"

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource, DialogViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <NotificationData *> *notificationsDataSource;
@property (nonatomic) SocketIOAPIService *socketAPIService;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.socketAPIService = [[SocketIOAPIService alloc] init];
    self.notificationsDataSource = [[NSArray alloc] init];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;

    self.extendedLayoutIncludesOpaqueBars = YES;
    [self configureNavigationBar];
    [self configureOpenSurveyActionDialog];
    [self loadNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNotificationsBarButtonitem:NO];
}

- (void)loadNotifications
{
    [self showLoader];
    weakify(self);
    [self.socketAPIService getUserNotificationsSuccess:^(id  _Nonnull response) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSDictionary *notificationsDict = response[@"data"];
        for (NSDictionary *notificationDict in notificationsDict) {
            NotificationData *notificationData = [[NotificationData alloc] initWithDictionary:notificationDict];
            if (notificationData.notifyType == NotificationTypeMessage && notificationData.notificationMessage && notificationData.notificationMessage.user) {
                [tempArray addObject:notificationData];
            } else if (notificationData.notifyType == NotificationTypeNewForum && notificationData.forumData) {
                [tempArray addObject:notificationData];
            } else if (notificationData.notifyType == NotificationTypeDashboardMessage &&
                       notificationData.notificationDashboardMessage) {
                [tempArray addObject:notificationData];
            }
        }
        strongify(self);
        [self hideLoader];
        self.notificationsDataSource = tempArray;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: Getting all notifications");
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NotificationData *selectedNotification = selectedCell.notificationData;
    if (selectedNotification.notifyRead == 0) {
        [[ForumNotificationsManager sharedInstance] readNotification:selectedNotification.notifyId];
        selectedNotification.notifyRead = 1;
    }
    if (selectedNotification.notifyType != NotificationTypeDashboardMessage) {
        [self openForumFromNotification:indexPath];
    }
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
        [self.navigationController popToRootViewControllerAnimated:NO];
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

#pragma mark - Confirm Survay Action Dialog

- (void)configureOpenSurveyActionDialog
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_OPEN_SURVEY_NOTIFICATION_SHOWN] && ![Settings sharedInstance].isOpenSurveyPopupShown) {
        [[Settings sharedInstance] setOpenSurveyPopupShown:YES];
        DialogViewController *surveyActionDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeSurveyAction title:LOC(@"survey_notification_popup_title") message:LOC(@"survey_notification_popup_description")];
        surveyActionDialogView.delegate = self;
        surveyActionDialogView.showCancelButton = YES;
        surveyActionDialogView.continueButtonText = LOC(@"take_survey_key");
        [self addChildViewController:surveyActionDialogView onView:self.view];
    }
}

#pragma mark - DialogViewDelegate

- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView
{
    if (dialogView.actionType == DialogViewTypeSurveyAction) {
        [self performSegueWithIdentifier:OPEN_SURVEY_STORYBOARD_SEGUE sender:nil];
    }
}

#pragma mark - UI Customization

- (void)configureNavigationBar
{
    self.navigationController.navigationBar.standardAppearance.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor = [UIColor whiteColor];
}

@end
