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
#import "DialogViewController.h"


@import SocketIO;

@interface ForumsViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, ForumFiltersViewControllerDelegate, DialogViewDelegate>

//@property (nonatomic) SocketIOClient* socketClient;
@property (nonatomic) NSMutableArray <ForumItemDataModel *>*forumItemsList;
@property (nonatomic) SYForumService *forumsSrvice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *filterButton;


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
    [self configureOpenSurveyActionDialog];
    weakify(self);
    [SocketIOManager sharedInstance].didReceiveCommentsCountForList = ^(NSInteger count, NSNumber * _Nonnull forumId) {
        strongify(self);
        [self handleCommentCountUpdate:count forumId:forumId];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    
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
    [[self mainTabbarController] hideTabbar:NO];
}

#pragma mark - Handle Remote Notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        RemoteNotificationType notifyType = [Settings sharedInstance].receivedRemoteNotification.notifyType;
        if (notifyType == NotificationTypeNewForum) {
            NSString *forumId = [[Settings sharedInstance].receivedRemoteNotification.forumId stringValue];
            [self showForumDetailsByForumId:forumId];
        } else if (notifyType == NotificationTypeMessage) {
            NSString *forumId = [[Settings sharedInstance].receivedRemoteNotification.messageForumId stringValue];
            [self showForumDetailsByForumId:forumId];
        }
    } else if ([self mainTabbarController].isFromNotificationsView) {
        RemoteNotificationType notifyType = self.mainTabbarController.selectedNotificationData.notifyType;
        if (notifyType == NotificationTypeNewForum) {
            NSString *forumId = [self.mainTabbarController.selectedNotificationData.forumData.forumId stringValue];
            [self showForumDetailsByForumId:forumId];
        } else if (notifyType == NotificationTypeMessage) {
            NSString *forumId = [self.mainTabbarController.selectedNotificationData.notificationMessage.messageForumId stringValue];
            [self showForumDetailsByForumId:forumId];
        }
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

- (void)showForumDetailsByForum:(ForumItemDataModel *)forum
{
    [self performSegueWithIdentifier:@"showForumDetails" sender:forum];
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
        for (ForumItemDataModel *forum in forumItems) {
            NSMutableArray *params = [NSMutableArray array];
            [params addObject:[NSNumber numberWithInt:SocketIOSignalCommentCount]];
            [params addObject:@{@"forum_id": forum.forumItemId}];
            [[SocketIOManager sharedInstance].socketClient emit:@"signal" with:params completion:^{
                NSLog(@"Subsicribed to comments count %@", forum.forumItemId);
            }];
        }
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
    [self.filterButton setTitle:LOC(@"filter") forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)appLanguageDidChange:(NSNotification *)notification
{
    [super appLanguageDidChange:notification];
    [self getForumsWithAppending:NO];
}

#pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumItemDataModel *selectedItem = self.forumItemsList[indexPath.row];
    [self resetForumActivity:selectedItem];
    selectedItem.viewsCount += 1;
    ForumItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self showForumDetailsByForum:selectedItem];
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
        if ([sender isKindOfClass:[NSString class]]) {
            destinationVC.forumItemId = (NSString *)sender;
        } else if ([sender isKindOfClass:[ForumItemDataModel class]]) {
            ForumItemDataModel *forum = (ForumItemDataModel *)sender;
            destinationVC.forumItemId = [forum.forumItemId stringValue];
            destinationVC.initialCommentsCount = forum.commentsCount;
        }
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

#pragma mark - Handle Socket Updates

- (void)handleCommentCountUpdate:(NSInteger)count forumId:(NSNumber *)forumId
{
    for (ForumItemDataModel *forum in self.forumItemsList) {
        if (forum.forumItemId == forumId) {
            forum.commentsCount = count;
        }
    }
    [self.tableView reloadData];
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

@end
