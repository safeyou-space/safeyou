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
#import "ForumDetailsViewController.h"
#import "ForumFiltersViewController.h"
#import "MainTabbarController.h"
#import "NotificationData.h"
#import "SocketIOManager.h"
#import "SYForumService.h"


@import SocketIO;

@interface ForumsViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, ForumFiltersViewControllerDelegate>

//@property (nonatomic) SocketIOClient* socketClient;
@property (nonatomic) NSMutableArray <ForumItemDataModel *>*forumItemsList;
@property (nonatomic) SYForumService *forumsSrvice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *filtersButtonTitleLabel;

@property (nonatomic) NSString *selectedLanguage;
@property (nonatomic) NSArray<NSString *> *selectedCategories;

@property (nonatomic) BOOL reloadForums;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger lastPage;

@end

@implementation ForumsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.forumsSrvice = [[SYForumService alloc] init];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    self.forumItemsList = [[NSMutableArray alloc] init];
    self.reloadForums = YES;
    
    self.navigationController.delegate = self;
    self.tableView.estimatedRowHeight = 450;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if ([self checkNotifications]) {
        [self handleReceivedNotification];
    } else if (self.reloadForums) {
        self.reloadForums = NO;
        [self getForumsWithAppending:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Handle Remote Notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        RemoteNotificationType notifyType = [[Settings sharedInstance].receivedRemoteNotification[@"notify_type"] integerValue];
        if (notifyType == NotificationTypeNewForum) {
            [Settings sharedInstance].receivedRemoteNotification = nil;
            [self getForumsWithAppending:NO];
        } else if (notifyType == NotificationTypeMessage) {
            NSString *forumId = [Settings sharedInstance].receivedRemoteNotification[@"message_forum_id"];
            [self showForumDetailsByForumId:forumId];
        }
    } else if ([self mainTabbarController].isFromNotificationsView) {
        NSString *forumId = [self.mainTabbarController.selectedNotificationData.notificationMessage.messageForumId stringValue];
        [self showForumDetailsByForumId:forumId];
    } else if ([Settings sharedInstance].dynamicLinkUrl) {
        NSString *forumId = [self getForumIdFromDynamicLink:[Settings sharedInstance].dynamicLinkUrl];
        [Settings sharedInstance].dynamicLinkUrl = NULL;
        [self showForumDetailsByForumId:forumId];
    }
}

- (void)showForumDetailsByForumId:(NSString *)forumId
{
    [self performSegueWithIdentifier:@"showForumDetails" sender:forumId];
}

- (BOOL)checkNotifications
{
    return [Settings sharedInstance].receivedRemoteNotification || [self mainTabbarController].isFromNotificationsView || [Settings sharedInstance].dynamicLinkUrl;
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    // empty
}

#pragma mark - Socket Data
- (void)getProfile
{
    [[SocketIOManager sharedInstance].socketClient on:@"SafeYOU_V4##PROFILE_INFO#RESULT" callback:^(NSArray *data, SocketAckEmitter* ack) {
        NSLog(@"Forum data %@", data);
    }];
}

- (void)getForumsWithAppending:(BOOL)needAppend
{
    NSString *language = [Settings sharedInstance].selectedLanguageCode;
    if (self.selectedLanguage && ![self.selectedLanguage isEqualToString:@""]) {
        language = self.selectedLanguage;
    }
    NSArray<NSString *> *categories = @[];
    if (self.selectedCategories && self.selectedCategories.count > 0) {
        categories = self.selectedCategories;
    }
    
    if (!needAppend) {
        self.currentPage = 1;
    }
        
    [self showLoader];
    
    weakify(self);
    [self.forumsSrvice getForumsForLanguage:language categories:categories page:self.currentPage withComplition:^(NSArray<ForumItemDataModel *> * _Nonnull forumItems, NSInteger lastPage) {
        strongify(self);
        [self hideLoader];
        self.lastPage = lastPage;
        if (needAppend) {
            [self.forumItemsList addObjectsFromArray: forumItems];
        } else {
            self.forumItemsList = [forumItems mutableCopy];
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        // hanle if needed
    }];
}

#pragma mark - Localizations
- (void)updateLocalizations
{
    self.title = LOC(@"forums_title_key");
    self.filtersButtonTitleLabel.text = LOC(@"filter");
    [self.tableView reloadData];
}

#pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumItemDataModel *selectedItem = self.forumItemsList[indexPath.row];
    [self resetForumActivity:selectedItem];
    selectedItem.viewsCount += 1;
    ForumItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell updateComments:selectedItem.commentsCount andViewsCount:selectedItem.viewsCount];
    [self showForumDetailsByForumId:[selectedItem.forumItemId stringValue]];
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
    return self.forumItemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.forumItemsList.count - 1 && self.currentPage < self.lastPage) {
        ++self.currentPage;
        [self getForumsWithAppending:YES];
    }
    ForumItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForumItemTableViewCell"];
    ForumItemDataModel *currentItem = self.forumItemsList[indexPath.row];
    [cell configureWithForumItem:currentItem];
    return cell;
}

#pragma mark - IBActions

- (IBAction)filtersButtonAction:(id)sender
{
    [self performSegueWithIdentifier:@"ShowForumFiltersFromForumsViewSegue" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showForumDetails"]) {
        ForumDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.forumItemId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"ShowForumFiltersFromForumsViewSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ForumFiltersViewController *destinationVC = navigationController.viewControllers[0];
        destinationVC.delegate = self;
        destinationVC.selectedLanguage = self.selectedLanguage;
        destinationVC.selectedCategories = self.selectedCategories;
    }
}


#pragma mark - ForumFiltersViewControllerDelegate
- (void)didForumFilter:(ForumFiltersViewController *)filterOptions withLanguage:(NSString *)language andCategories:(NSArray<NSString *>*)categories
{
    self.selectedLanguage = language;
    self.selectedCategories = categories;
    self.reloadForums = YES;
}

#pragma mark - Handle dynamic link

- (NSString *)getForumIdFromDynamicLink:(NSURL *)dynamicLinkUrl
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:dynamicLinkUrl resolvingAgainstBaseURL:NO];
    NSArray<NSURLQueryItem *> *queryItems = components.queryItems;
    for (NSURLQueryItem *queryItem in queryItems) {
        if ([queryItem.name isEqualToString:@"forumId"]) {
            return queryItem.value;
        }
    }
    return NULL;
}

@end
