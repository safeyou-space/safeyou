//
//  ForumsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumsViewController.h"
#import "ForumItemTableViewCell.h"
#import "ForumListDataModels.h"
#import "ForumCommentsViewController.h"
#import "MainTabbarController.h"
#import "NotificationDataModel.h"
#import "SocketIOManager.h"


NSInteger __numberOfItemInsPage = 1000;
@import SocketIO;

@interface ForumsViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

//@property (nonatomic) SocketIOClient* socketClient;
@property (nonatomic) ForumItemListDataModel *forumItemsList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *currentLanguage;

@property (nonatomic) BOOL isFirstShow;

@end

@implementation ForumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirstShow = YES;
    
    self.navigationController.delegate = self;
    self.tableView.estimatedRowHeight = 450;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.currentLanguage = [Settings sharedInstance].selectedLanguageCode;
    
    if ([SocketIOManager sharedInstance].socketClient.status == SocketIOStatusConnected) {
        [self getForums];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect) name:SOCKET_IO_DID_CONNECT_NOTIFICATION_NAME object:nil];
    }
}

- (void)socketDidConnect
{
    [self getForums];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.currentLanguage isEqualToString:[Settings sharedInstance].selectedLanguageCode]) {
        self.currentLanguage = [Settings sharedInstance].selectedLanguageCode;
        [self getForums];
    }
    self.tabBarController.tabBar.hidden = NO;
    [((MainTabbarController *)self.tabBarController) showCenterButton:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isFirstShow = NO;
    if ([self mainTabbarController].isFromNotificationsView) {
        ForumItemDataModel *selectedForum = [self fetchForumWithId:self.mainTabbarController.selectedNotificationData.forumId];
        if (selectedForum) {
            [self performSegueWithIdentifier:@"showForumDetails" sender:selectedForum];
        }
    }
    [self handleReceivedNotification];
}

#pragma mark - Handle Openin From Remote Notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        NSDictionary *receivedNoitificationData = [Settings sharedInstance].receivedRemoteNotification;
        NSString *notificationType = nilOrJSONObjectForKey(receivedNoitificationData, @"notification_type");
        if ([notificationType isEqualToString:@"forum"]) {
            [Settings sharedInstance].receivedRemoteNotification = nil;
        } else {
            //TODO: Garnik, handle comment reply notification type
            ForumItemDataModel *selectedForum = [self fetchForumWithId:receivedNoitificationData[@"forum_id"]];
            if (selectedForum) {
                [self performSegueWithIdentifier:@"showForumDetails" sender:selectedForum];
            }
        }
    }
}



#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    if (viewController == self) {
        if (!self.isFirstShow) {
            [self listenForumData];
        }
    }
}

#pragma mark - Socket Data
- (void)getProfile
{
    [[SocketIOManager sharedInstance].socketClient on:@"SafeYOU_V4##PROFILE_INFO#RESULT" callback:^(NSArray *data, SocketAckEmitter* ack) {
        NSLog(@"Forum data %@", data);
    }];
}

- (void)getForums
{
    [self showLoader];
    NSDictionary *param1 = @{
        @"language_code": self.currentLanguage,
        @"forums_rows": @(__numberOfItemInsPage),
        @"forums_page": @(0)
    };
    
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_REQUEST_FORUMS with:@[param1] completion:^{
        NSLog(@"Forum data ");
        strongify(self);
        [self listenForumData];
    }];
}

- (void)listenForumData
{
    //    SafeYOU_V4##GET_ALL_FORUMS#RESULT
    weakify(self);
    [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_FORUMS_RESULT callback:^(NSArray *data, SocketAckEmitter* ack) {
        strongify(self);
        [self hideLoader];
        NSLog(@"Forum data %@", data);
        NSDictionary *receivedData = ((NSArray *)data)[0];
        BOOL needHandleNotification = NO;
        if (self.forumItemsList == nil) {
            needHandleNotification = YES;
        }
        self.forumItemsList = [ForumItemListDataModel modelObjectWithDictionary:receivedData];
        if (needHandleNotification) {
            [self handleReceivedNotification];
        }
        [self.tableView reloadData];
    }];
}

- (void)offForumData
{
    [[SocketIOManager sharedInstance].socketClient off:@"SafeYOU_V4##GET_ALL_FORUMS#RESULT"];
}


#pragma mark - Localizations

- (void)updateLocalizations
{
    self.title = LOC(@"forums_title_key");
    self.tabBarItem.title = LOC(@"forums_title_key");
    [self.tableView reloadData];
}

#pragma mark - DataSource

- (ForumItemDataModel *)fetchForumWithId:(NSString *)forumId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"forumItemId=%@", @(forumId.integerValue)];
    NSArray *filteredArray =  [self.forumItemsList.forumItems filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        ForumItemDataModel *selectedForum = filteredArray.firstObject;
        return selectedForum;
    }
    return nil;
}

#pragma mark - UITableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tabBarController.tabBar.hidden = YES;
    [((MainTabbarController *)self.tabBarController) showCenterButton:NO];
    ForumItemDataModel *selectedItem = self.forumItemsList.forumItems[indexPath.row];
    [self resetForumActivity:selectedItem];
    [self performSegueWithIdentifier:@"showForumDetails" sender:selectedItem];
}

- (void)resetForumActivity:(ForumItemDataModel *)forumItem
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger seconds = time;
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSInteger finalSeconds = seconds + timeZoneSeconds;
    NSDictionary *params = @{@"forum_id": forumItem.forumItemId,
                             @"datetime": @(finalSeconds)};
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_GET_NEW_COMMENTS_COUNT with:@[params] completion:^{
        forumItem.newMessagesCount = 0;
        NSLog(@"Did reset");
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.forumItemsList.forumItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForumItemTableViewCell"];
    
    ForumItemDataModel *currentItem = self.forumItemsList.forumItems[indexPath.row];
    
    [cell configureWithForumItem:currentItem];
    
    return cell;
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showForumDetails"]) {
        ForumCommentsViewController *destinationVC = segue.destinationViewController;
        destinationVC.forumItemData = (ForumItemDataModel *)sender;
    }
}


@end
