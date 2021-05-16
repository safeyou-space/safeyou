//
//  ForumDetailsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/16/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ForumDetailsViewController.h"

#import "ForumCommentsViewController.h"
#import "ForumCommentCell.h"
#import "ForumTitleHeaderView.h"
#import "ForumDescriptionCell.h"
#import "ForumDetials.h"
#import "ForumCommentDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import "ForumTitleHeaderView.h"
#import "ForumItemDataModel.h"
#import "MainTabbarController.h"
#import "ForumCommentsViewController.h"
#import <SDWebImage.h>

@import SocketIO;

@interface ForumDetailsViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HyRobotoButton *commentButton;
@property (weak, nonatomic) IBOutlet HyRobotoButton *commentsCountButton;


- (IBAction)commentButtonAction:(UIButton *)sender;
- (IBAction)commenctCountButtonAction:(UIButton *)sender;

@property (nonatomic) ForumDetials *forumDetialsData;

// Reply mode

@property (nonatomic) ForumCommentDataModel *replyingComment;


@end

@implementation ForumDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableKeyboardNotifications];
    [self configureNibs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.forumItemData.title;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self mainTabbarController].isFromNotificationsView) {
        // handle event
        [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
    } else {
        [self handleReceivedNotification];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)updateLocalizations
{
    self.title = LOC(@"forums_title_key");
    NSString *buttonTitle = [NSString stringWithFormat:LOC(@"{param}_comments"), @(self.forumItemData.commentsCount)];
    [self.commentsCountButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.commentButton setTitle:LOC(@"comment") forState:UIControlStateNormal];
}

#pragma mark - Hendle remote Notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        NSDictionary *receivedNoitificationData = [Settings sharedInstance].receivedRemoteNotification;
        NSString *notificationType = nilOrJSONObjectForKey(receivedNoitificationData, @"notification_type");
        if ([notificationType isEqualToString:@"forum"]) {
            [Settings sharedInstance].receivedRemoteNotification = nil;
        } else {
            [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
        }
    }
}


#pragma mark - Configure Nibs

- (void)configureNibs
{
    UINib *headerNib = [UINib nibWithNibName:@"ForumTitleHeaderView" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"ForumTitleHeaderView"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Actions
- (IBAction)commenctCountButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
}

- (IBAction)commentButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showForumComments" sender:@(YES)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"ForumDescriptionCell"];
    [descriptionCell configureWithForumData:self.forumItemData];
    return descriptionCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 283;
    }
    
    return 153;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 100;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        ForumTitleHeaderView *sectionHeaderView = (ForumTitleHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ForumTitleHeaderView"];
        [sectionHeaderView configureWithFourmData:self.forumItemData];
        
        return sectionHeaderView;
        
    }
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showForumComments"]) {
        BOOL isForComposing = [sender boolValue];
        ForumCommentsViewController *commentsController = (ForumCommentsViewController *)segue.destinationViewController;
        commentsController.isForComposing = isForComposing;
        commentsController.forumItemData = self.forumItemData;
    }
}

@end
