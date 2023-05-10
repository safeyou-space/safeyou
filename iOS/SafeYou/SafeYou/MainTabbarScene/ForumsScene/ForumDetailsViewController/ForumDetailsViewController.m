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
#import "ForumDetialsData.h"
#import "ChatMessageDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import "ForumTitleHeaderView.h"
#import "ForumItemDataModel.h"
#import "MainTabbarController.h"
#import "ForumCommentsViewController.h"
#import <SDWebImage.h>
#import "SYForumService.h"
#import "SocketIOManager.h"
#import <WebKit/WebKit.h>
#import "ImageDataModel.h"
#import "NSString+HTML.h"

@import SocketIO;

@interface ForumDetailsViewController () <UITextViewDelegate, UINavigationControllerDelegate, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet HyRobotoButton *commentButton;
@property (weak, nonatomic) IBOutlet HyRobotoButton *commentsCountButton;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *forumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *forumShorDescriptionLabel;
@property (weak, nonatomic) IBOutlet WKWebView *forumContentWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forumContentHeightConstraint;

- (IBAction)commentButtonAction:(UIButton *)sender;
- (IBAction)commenctCountButtonAction:(UIButton *)sender;

@property (nonatomic) ForumItemDataModel *forumItemData;

@property (nonatomic) SYForumService *forumService;

// Reply mode

@property (nonatomic) ChatMessageDataModel *replyingComment;


@end

@implementation ForumDetailsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.forumService = [[SYForumService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableKeyboardNotifications];
    
    self.titleImageView.clipsToBounds = YES;
        
    [self configureWebView];
    
    [self loadForumDetailsById: self.forumItemId];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    weakify(self);
    [SocketIOManager sharedInstance].didReceiveUpdateBlock = ^(id  _Nonnull updateData) {
        strongify(self);
        [self handleCommentCountUpdate:updateData];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self handleReceivedNotification];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)updateLocalizations
{
    [self updateCommentsCount:self.forumItemData.commentsCount viewsCount:self.forumItemData.viewsCount];
    [self.commentButton setTitle:LOC(@"comment") forState:UIControlStateNormal];
}

- (void)updateCommentsCount:(NSInteger)commentsCount viewsCount:(NSInteger)viewsCount
{
    NSString *commentsCountText = [NSString stringWithFormat:LOC(@"count_comments"), @(self.forumItemData.commentsCount)];
    NSString *viewsCountText = [NSString stringWithFormat:LOC(@"count_views"), @(self.forumItemData.viewsCount)];
    NSString *buttonTitle = [NSString stringWithFormat:@"%@ | %@", viewsCountText, commentsCountText];
    [self.commentsCountButton setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - Fetch Data
- (void)loadForumDetailsById:(NSString *)forumId
{
    [self showLoader];
    weakify(self);
    [self.forumService getForumDetails:forumId forLanguage:[Settings sharedInstance].selectedLanguageCode withComplition:^(ForumItemDataModel * _Nonnull forumItem) {
        strongify(self);
        [self hideLoader];
        self.forumItemData = forumItem;
        [self configureWithForumData:self.forumItemData];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

#pragma mark - Handle Socket Updates

- (void)handleCommentCountUpdate:(NSDictionary *)receivedUpdate
{
    NSInteger commentsCount = [receivedUpdate[@"messages_count"] integerValue];
    self.forumItemData.commentsCount = commentsCount;
    [self updateCommentsCount:commentsCount viewsCount:self.forumItemData.viewsCount];
}

#pragma mark - Hendle remote Notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        RemoteNotificationType notifyType = [[Settings sharedInstance].receivedRemoteNotification[@"notify_type"] integerValue];
        if (notifyType == NotificationTypeMessage) {
            [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
        }
    } else if ([self mainTabbarController].isFromNotificationsView) {
        [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
    }
}

#pragma mark - Actions
- (IBAction)commenctCountButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
}

- (IBAction)commentButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showForumComments" sender:@(YES)];
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

#pragma mark - WKWebView Navigation delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if (navigationAction.request.URL) {
            if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler: nil];
                decisionHandler(WKNavigationActionPolicyCancel);
            }
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (!webView.isLoading) {
        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id result, NSError * _Nullable error) {
            CGFloat height = [result doubleValue];
            self.forumContentHeightConstraint.constant = height;
        }];
    }
}

#pragma mark - View configs

- (void)configureWebView
{
    self.forumContentWebView.navigationDelegate = self;
    self.forumContentWebView.scrollView.scrollEnabled = NO;
    self.forumContentWebView.scrollView.bounces = NO;
}

- (void)configureWithForumData:(ForumItemDataModel *)forumItemData
{
    self.title = forumItemData.title;
    [self.titleImageView sd_setImageWithURL:forumItemData.imageData.imageFullURL];
    self.forumTitleLabel.text = forumItemData.title;
    
    NSMutableAttributedString *mAttrShortDescription = [[NSString attributedStringFromHTML:forumItemData.shortDescription] mutableCopy];
    [mAttrShortDescription addAttribute:NSFontAttributeName value:[UIFont hyRobotoFontRegularOfSize:18.0] range:NSMakeRange(0, mAttrShortDescription.length)];
    [mAttrShortDescription addAttribute:NSForegroundColorAttributeName value:[UIColor mainTintColor3] range:NSMakeRange(0, mAttrShortDescription.length)];
    
    self.forumShorDescriptionLabel.attributedText = mAttrShortDescription;
    
    // meta info helps web view to show currect size
    NSString *htmlContent = [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width,initial-scale=1,maximum-scale=1'/> %@", forumItemData.forumItemDescription];
    [self.forumContentWebView loadHTMLString:htmlContent baseURL:nil];
    
    [self updateCommentsCount:forumItemData.commentsCount viewsCount:forumItemData.viewsCount];
}

@end
