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
#import "ReviewDataModel.h"
#import "SafeYou-Swift.h"
#import "NotificationData.h"
#import "ForumNotificationsManager.h"

@import SocketIO;
@import Firebase;

@interface ForumDetailsViewController () <UITextViewDelegate, UINavigationControllerDelegate, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet SYRegularButtonButton *commentButton;
@property (weak, nonatomic) IBOutlet SYRegularButtonButton *commentsCountButton;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *forumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *forumShorDescriptionLabel;
@property (weak, nonatomic) IBOutlet WKWebView *forumContentWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forumContentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *rateButton;

- (IBAction)commentButtonAction:(UIButton *)sender;
- (IBAction)commenctCountButtonAction:(UIButton *)sender;

@property (nonatomic) ForumItemDataModel *forumItemData;

@property (nonatomic) SYForumService *forumService;

@property (nonatomic) BOOL isCommentsReadFromApi;

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
    self.isCommentsReadFromApi = NO;
    
    [self configureShareButton];
    
    [self configureWebView];
    weakify(self);
    [SocketIOManager sharedInstance].didReceiveCommentsCount = ^(NSInteger count) {
        strongify(self);
        [self handleCommentCountUpdate:count];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor1];
    [self loadForumDetailsById: self.forumItemId];
    [[self mainTabbarController] hideTabbar:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)updateLocalizations
{

}

- (void)updateCommentsCount:(NSInteger)count
{
//    NSString *commentsCountText = [NSString stringWithFormat:LOC(@"count_comments"), @(self.forumItemData.commentsCount)];
//    NSString *viewsCountText = [NSString stringWithFormat:LOC(@"count_views"), @(self.forumItemData.viewsCount)];
   // NSString *buttonTitle = [NSString stringWithFormat:@"%@ | %@", viewsCountText, commentsCountText];
    
    NSString *commentCount = [NSString stringWithFormat: @"   %ld", (long)count];
    [self.commentsCountButton setTitle:commentCount forState:UIControlStateNormal];
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
        if (self.forumItemData.forumItemId) {
            [self handleReceivedNotification];
        } else {
            [Settings sharedInstance].receivedRemoteNotification = nil;
            [self mainTabbarController].isFromNotificationsView = NO;
        }
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        NSLog(@"NSError loadForumDetailsById %@", error);
        [Settings sharedInstance].receivedRemoteNotification = nil;
        [self mainTabbarController].isFromNotificationsView = NO;
        [self hideLoader];
    }];
}

#pragma mark - Handle Socket Updates

- (void)handleCommentCountUpdate:(NSInteger)commentsCount
{
    self.forumItemData.commentsCount = commentsCount;
    [self updateCommentsCount:commentsCount];
}

#pragma mark - Hendle remote Notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        RemoteNotificationType notifyType = [Settings sharedInstance].receivedRemoteNotification.notifyType;
        if (notifyType == NotificationTypeMessage) {
            [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
        } else if (notifyType == NotificationTypeNewForum) {
            NSNumber *notifyId = [Settings sharedInstance].receivedRemoteNotification.notifyId;
            [[ForumNotificationsManager sharedInstance] readNotification:notifyId];
            [Settings sharedInstance].receivedRemoteNotification = nil;
        }
    } else if ([self mainTabbarController].isFromNotificationsView) {
        RemoteNotificationType notifyType = self.mainTabbarController.selectedNotificationData.notifyType;
        if (notifyType == NotificationTypeMessage) {
            [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
        } else if (notifyType == NotificationTypeNewForum) {
            [self mainTabbarController].isFromNotificationsView = NO;
        }
    }
}

#pragma mark - Actions
- (IBAction)commenctCountButtonAction:(UIButton *)sender {
    if (self.forumItemData.forumItemId) {
        [self performSegueWithIdentifier:@"showForumComments" sender:@(NO)];
    }
}

- (IBAction)commentButtonAction:(UIButton *)sender {
    if (self.forumItemData.forumItemId) {
        [self performSegueWithIdentifier:@"showForumComments" sender:@(YES)];
    }
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    if (self.forumItemData.forumItemId) {
        [self generateDynamicLink];
    }
}

- (IBAction)rateButtonAction:(UIButton *)sender {
    if (self.forumItemData.forumItemId) {
        [self performSegueWithIdentifier:@"showForumReview" sender:@(NO)];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showForumComments"]) {
        BOOL isForComposing = [sender boolValue];
        ForumCommentsViewController *commentsController = (ForumCommentsViewController *)segue.destinationViewController;
        commentsController.isForComposing = isForComposing;
        commentsController.forumItemData = self.forumItemData;
    } else if ([segue.identifier isEqualToString:@"showForumReview"]) {
        ForumReviewViewController *reviewViewController = (ForumReviewViewController *)segue.destinationViewController;
        [reviewViewController setForumItemData:self.forumItemData];
        [self.mainTabbarController hideTabbar:YES];
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

- (void)configureShareButton
{
    UIImage *shareImage = [[UIImage imageNamed:@"send_icon_white"] imageWithTintColor: UIColor.mainTintColor1];
    [self.shareButton setImage:shareImage forState:UIControlStateNormal];
    [self.shareButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)configureWithForumData:(ForumItemDataModel *)forumItemData
{
    self.title = forumItemData.title;
    [self.titleImageView sd_setImageWithURL:forumItemData.imageData.imageFullURL];
    self.forumTitleLabel.text = forumItemData.title;
    
    NSMutableAttributedString *mAttrShortDescription = [[NSString attributedStringFromHTML:forumItemData.shortDescription] mutableCopy];
    [mAttrShortDescription addAttribute:NSFontAttributeName value:[UIFont regularFontOfSize:12.0] range:NSMakeRange(0, mAttrShortDescription.length)];
    [mAttrShortDescription addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor3] range:NSMakeRange(0, mAttrShortDescription.length)];
    
    self.forumShorDescriptionLabel.attributedText = mAttrShortDescription;
    
    // meta info helps web view to show currect size
    NSString *htmlContent = [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width,initial-scale=1,maximum-scale=1'/> %@", forumItemData.forumItemDescription];
    [self.forumContentWebView loadHTMLString:htmlContent baseURL:nil];
    
    if (forumItemData.reviewData.rate > 0) {
        [self.rateButton setImage:[[UIImage imageNamed:@"icon_like_selected"] imageWithTintColor:UIColor.mainTintColor1] forState:UIControlStateNormal];
        [self.rateButton setTitle:[NSString stringWithFormat: @" %@/5", @(forumItemData.reviewData.rate)] forState:UIControlStateNormal];
    } else {
        [self.rateButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (!self.isCommentsReadFromApi) {
        if (self.initialCommentsCount) {
            [self updateCommentsCount:self.initialCommentsCount];
        }
        self.isCommentsReadFromApi = YES;
    }
}

#pragma mark - Share forum configs

- (void)generateDynamicLink
{
    NSString *linkStr = [NSString stringWithFormat:@"https://safeyou.space?forumId=%@", self.forumItemData.forumItemId];
    NSURL *link = [[NSURL alloc] initWithString:linkStr];
    NSString *dynamicLinksDomainURIPrefix = @"https://safeyou.page.link";
    FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
                                             initWithLink:link
                                             domainURIPrefix:dynamicLinksDomainURIPrefix];
    
    NSString *bundleId = NSBundle.mainBundle.bundleIdentifier;
    if (bundleId) {
        linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc] initWithBundleID:bundleId];
    }
    linkBuilder.iOSParameters.appStoreID = @"1491665304";
    
    linkBuilder.androidParameters = [[FIRDynamicLinkAndroidParameters alloc] initWithPackageName:@"fambox.pro"];
    
    linkBuilder.socialMetaTagParameters = [[FIRDynamicLinkSocialMetaTagParameters alloc] init];
    linkBuilder.socialMetaTagParameters.title = LOC(@"access_safe_you_forum");
    
    [linkBuilder shortenWithCompletion:^(NSURL * _Nullable shortURL,
                                         NSArray<NSString *> * _Nullable warnings,
                                         NSError * _Nullable error) {
        if (error || shortURL == nil) {
            return;
        }
        [self shareAction:shortURL];
    }];
}

- (void)shareAction:(NSURL *)text
{
    NSArray* sharedObjects=[NSArray arrayWithObjects:text,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
