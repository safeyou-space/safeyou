//
//  ForumCommentsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <SDWebImage.h>

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
#import "ForumMoreRepliesTableViewCell.h"
#import "NotificationDataModel.h"
#import "SocketIOManager.h"

NSInteger __numberofItemsInPage = 5000;

@import SocketIO;

@interface ForumCommentsViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ForumCommentCellDelegate, MoreRepliesCellDelegate>


@property (weak, nonatomic) IBOutlet UIStackView *composerStackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SYDesignableView *replyingView;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *replyingUserAvatar;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *replyingNameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *replyingCommentLabel;
@property (weak, nonatomic) IBOutlet SYDesignableButton *secondaryBackButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelEditingGesture;

// composer view
@property (weak, nonatomic) IBOutlet SYDesignableView *composerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *composerViewheightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *composerTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *composerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet SYDesignableView *secondarynavigationView;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)cancelReplyButtonAction:(UIButton *)sender;
- (IBAction)sendButtonAction:(UIButton *)sender;

@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) ForumDetials *forumDetialsData;

@property (nonatomic) ForumCommentDataModel *replyingComment;

@property (nonatomic) NSArray *commecntsDataSource;

@end

@implementation ForumCommentsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageNumber = 0;
        self.level = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableKeyboardNotifications];
        
    // Do any additional setup after loading the view.
    [self configureComposerView];
    [self configureNibsForUsing];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.replyingView.hidden = YES;
    [self.secondaryBackButton sizeToFit];
    [self configureViewForLevel];
    [self.cancelEditingGesture setCancelsTouchesInView:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isForComposing || self.level > 0) {
        [self.composerTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - Pull to refresh functionality

- (void)configurePullToRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];

    [refreshControl addTarget:self action:@selector(loadOlderComments:)
    forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:refreshControl];
}

#pragma mark - Configure view for Level

- (void)configureViewForLevel
{
    if (self.level > 0) {
        self.secondarynavigationView.hidden = NO;
        SYDesignableBarButtonItem *backBarButton = [[SYDesignableBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonAction)];
        backBarButton.title = self.forumItemData.title;
        self.navigationItem.leftBarButtonItem = backBarButton;
    } else {
        [self fetchForumData];
        self.secondarynavigationView.hidden = YES;
    }
}

#pragma mark - Configure Nibs

- (void)configureNibsForUsing
{
    UINib *headerNib = [UINib nibWithNibName:@"ForumTitleHeaderView" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"ForumTitleHeaderView"];
    
    UINib *commentCellNib = [UINib nibWithNibName:@"ForumCommentCellRight" bundle:nil];
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"ForumCommentCellRight"];
    
    UINib *commentReplyCellNib = [UINib nibWithNibName:@"ForumCommentCellReply" bundle:nil];
    [self.tableView registerNib:commentReplyCellNib forCellReuseIdentifier:@"ForumCommentCellReply"];
    
    UINib *moreRepliesCellNib = [UINib nibWithNibName:@"ForumMoreRepliesTableViewCell" bundle:nil];
    [self.tableView registerNib:moreRepliesCellNib forCellReuseIdentifier:@"ForumMoreRepliesTableViewCell"];
}


#pragma mark - Translations
- (void)updateLocalizations
{
    self.title = LOC(@"forums_title_key");
    [[SocketIOManager sharedInstance].socketClient off:SOCKET_COMMAND_GET_FORUM_DETAILS];
    [self fetchForumData];
}

#pragma mark - Configure Subviews

- (void)configureComposerView
{
    UIEdgeInsets textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    self.composerTextView.contentInset = textInsets;
    self.composerTextView.font = [UIFont fontWithName:@"HayRoboto-Regular" size:17.0];
    self.composerTextView.tintColor = [UIColor mainTintColor2];
    self.composerTextView.delegate = self;
    self.composerTextView.layer.cornerRadius = 18.0;
    UIColor *borderColor = [UIColor mainTintColor1];
    self.composerTextView.layer.borderColor = borderColor.CGColor;
    self.composerTextView.layer.borderWidth = 1.0;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize calculatingSize = CGSizeMake(textView.frame.size.width - 10, MAXFLOAT);
    CGSize textSize = [textView.text boundingRectWithSize:calculatingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textView.font} context:nil].size;
    
    CGFloat heightWithMargins = textSize.height + 16 + 20; // text view margins, text bottom top insets
    
    if (heightWithMargins > 52) {
        if (textSize.height < 155) {
            self.composerViewheightConstraint.constant = heightWithMargins;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
    }
    
    
    NSLog(@"width = %@, height = %@", @(textSize.width), @(textSize.height));
}

#pragma mark - Socket data

- (void)fetchForumData
{
    weakify(self);
    [self showLoader];
    NSDictionary *params = @{
        @"language_code": [Settings sharedInstance].selectedLanguageCode,
        @"forum_id": self.forumItemData.forumItemId,
        @"comments_rows": @(__numberofItemsInPage),            // required, int
        @"comments_page": @(0)              // required, int
    };
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_REQUEST_FORUM_DETAILS with:@[params]];
    [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_FORUM_DETAILS callback:^(NSArray* responseData, SocketAckEmitter* ack) {
        strongify(self)
        if (self.pageNumber != 0) {
            return;
        }
        NSDictionary *receivedDict = responseData[0];
        NSDictionary *forumDataDict = receivedDict[@"data"];
        ForumDetials *forumData = [ForumDetials modelObjectWithDictionary:forumDataDict level:self.level];
        self.forumDetialsData = forumData;
        if (self.currentComment) {
            self.forumDetialsData.currentCommentId = self.currentComment.commentId;
        }
        [self hideLoader];
        [self.tableView reloadData];
        if ([self mainTabbarController].isFromNotificationsView) {
            [self mainTabbarController].isFromNotificationsView = NO;
            if ([self mainTabbarController].selectedNotificationData) {
                // handle scrolling to
                if ([self mainTabbarController].selectedNotificationData) {
                    NotificationDataModel *notificationData = [self mainTabbarController].selectedNotificationData;
                    ForumCommentDataModel *selectedComment = [self fetchCommentDataFromNotification:notificationData.replyId];
                    [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
                }
            }
        } else if ([Settings sharedInstance].receivedRemoteNotification) {
            NSDictionary *receibedNotification = [Settings sharedInstance].receivedRemoteNotification;
            NSString *notificationType = nilOrJSONObjectForKey(receibedNotification, @"notification_type");
            NSString *replyId = nilOrJSONObjectForKey(receibedNotification, @"reply_id");
            if ([notificationType isEqualToString:@"message"]) {
                ForumCommentDataModel *selectedComment = [self fetchCommentDataFromNotification:replyId];
                [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
            }
            [Settings sharedInstance].receivedRemoteNotification = nil;
        } else {
            if (self.commecntsDataSource.count > 0) {
                NSInteger lastIndex = self.commecntsDataSource.count - 1;
                NSIndexPath *scrollingIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
                [self.tableView performBatchUpdates:nil completion:^(BOOL finished) {
                    if (finished) {           
                        [self.tableView scrollToRowAtIndexPath:scrollingIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }];
            }
        }
    }];
}

- (ForumCommentDataModel *)fetchCommentDataFromNotification:(NSString *)replyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"replyId=%@", @(replyId.integerValue)];
    NSArray *filteredArray = [self.forumDetialsData.originalComments filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        ForumCommentDataModel *searchingReply = filteredArray.firstObject;
        NSPredicate *commentPredicate = [NSPredicate predicateWithFormat:@"commentId=%@", searchingReply.groupId];
        NSArray *filteredCommentArray = [self.forumDetialsData.originalComments filteredArrayUsingPredicate:commentPredicate];
        if (filteredCommentArray.count) {
            ForumCommentDataModel *searchingComment = filteredCommentArray.firstObject;
            return searchingComment;
        }
    }
    
    return nil;
}

- (void)loadOlderComments:(UIRefreshControl *)refreshControl
{
    ++self.pageNumber;
    [refreshControl beginRefreshing];
    weakify(self);
        NSDictionary *params = @{
            @"language_code": [Settings sharedInstance].selectedLanguageCode,
            @"forum_id": self.forumItemData.forumItemId,
            @"comments_rows": @(__numberofItemsInPage),
            @"comments_page": @(self.pageNumber)
        };
        [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_REQUEST_FORUM_DETAILS with:@[params]];
        [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_FORUM_DETAILS callback:^(NSArray* responseData, SocketAckEmitter* ack) {
            strongify(self);
            [refreshControl endRefreshing];
            NSDictionary *receivedDict = responseData[0];
            NSDictionary *forumDataDict = receivedDict[@"data"];
            ForumDetials *forumData = [ForumDetials modelObjectWithDictionary:forumDataDict];
            
            NSArray *receivedStripedComments = forumData.strippedComments;
            NSArray *receivedComments = forumData.comments;
            if (receivedComments.count == 0) {
                --self.pageNumber;
                return;
            }
            NSMutableArray *recentStrippedComments = [self.forumDetialsData.strippedComments mutableCopy];
            NSMutableArray *recentComments = [self.forumDetialsData.comments mutableCopy];
            
            NSIndexSet *receivedIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, receivedComments.count)];
            NSIndexSet *strippedIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, receivedStripedComments.count)];
            [recentComments insertObjects:receivedComments atIndexes:receivedIndexSet];
            [recentStrippedComments insertObjects:receivedStripedComments atIndexes:strippedIndexSet];
            
            self.forumDetialsData.comments = recentComments;
            self.forumDetialsData.strippedComments =  recentStrippedComments;
            if (self.currentComment) {
                self.forumDetialsData.currentCommentId = self.currentComment.commentId;
            }
            [self.tableView reloadData];
        }];
}

// TODO: Dublicate code no time
- (void)addComment
{
    weakify(self);
    [self showLoader];
    NSString *languageCode = [Settings sharedInstance].selectedLanguageCode;
    NSNumber *groupId = self.currentComment.groupId;
    if (!groupId) {
        groupId = self.currentComment.commentId;
    }
    NSDictionary *params = @{
        @"language_code": languageCode,
        @"forum_id": self.forumItemData.forumItemId,
        @"messages": self.composerTextView.text,
        @"level": @(0),
    };
    
    [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_ADD_NEW_COMMENT with:@[params]];
    [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_NEW_COMMENT callback:^(NSArray * responseData, SocketAckEmitter *ack) {
        strongify(self);
        self.composerTextView.text = @"";
        [self textViewDidChange:self.composerTextView];
        [self hideLoader];
        NSDictionary *receivedDataDict = responseData[0];
        NSDictionary *newCommentDict = receivedDataDict[@"data"];
        ForumCommentDataModel *newComment = [ForumCommentDataModel modelObjectWithDictionary:newCommentDict];
        NSMutableArray *commentsArray = [self.forumDetialsData.strippedComments mutableCopy];
        if (![commentsArray containsObject:newComment]) {
            [commentsArray addObject:newComment];
            self.forumDetialsData.strippedComments = commentsArray;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.forumDetialsData.comments.count - 1 inSection:0];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}


// TODO: Dublicate code no time
- (void)addReplyComment
{
    weakify(self);
    [self showLoader];
    if (self.composerTextView.text.length > 0) {
        NSInteger level = self.replyingComment.level.integerValue;
        
        NSString *languageCode = [Settings sharedInstance].selectedLanguageCode;
        NSNumber *groupId = self.currentComment.groupId;
        if (!groupId) {
            groupId = self.currentComment.commentId;
        }
        NSDictionary *params = @{
            @"language_code": languageCode,
            @"forum_id": self.forumItemData.forumItemId,
            @"messages": self.composerTextView.text,
            @"reply_id": self.replyingComment.commentId,
            @"group_id": groupId,
            @"level": @(++level),
            @"reply_user_id": self.replyingComment.userId
        };
        
        [[SocketIOManager sharedInstance].socketClient emit:SOCKET_COMMAND_ADD_NEW_COMMENT with:@[params]];
        [[SocketIOManager sharedInstance].socketClient on:SOCKET_COMMAND_GET_NEW_COMMENT callback:^(NSArray * responseData, SocketAckEmitter *ack) {
            strongify(self);
            self.composerTextView.text = @"";
            [self textViewDidChange:self.composerTextView];
            [self hideLoader];
            NSDictionary *receivedDataDict = responseData[0];
            NSDictionary *newCommentDict = receivedDataDict[@"data"];
            ForumCommentDataModel *newComment = [ForumCommentDataModel modelObjectWithDictionary:newCommentDict];
            
            ForumCommentDataModel *parentComment = [self fetchParentForReply:newComment];
            NSString *replyInfo = [self replyInfoForReply:newComment comment:parentComment];
            newComment.replyInfo = replyInfo;
            if (self.replyingComment != nil) {
                NSArray *allReplies = [self.forumDetialsData fetchRepliesForComment:self.replyingComment];
                NSInteger insertIndex;
                if (allReplies.count > 0) {
                    ForumCommentDataModel *lastreply = allReplies.lastObject;
                    NSInteger lastReplyIndex = [self.forumDetialsData.comments indexOfObject:lastreply];
                    insertIndex = lastReplyIndex + 1;
                } else {
                    NSInteger lastReplyIndex = [self.forumDetialsData.comments indexOfObject:self.replyingComment];
                    insertIndex = lastReplyIndex + 1;
                }
                
                NSMutableArray *tempComments = [self.forumDetialsData.comments mutableCopy];
                if (![tempComments containsObject:newComment]) {
                    [tempComments addObject:newComment];
                    self.forumDetialsData.comments = tempComments;
                }
                [self.tableView reloadData];
                [self cancelReplyButtonAction:nil];
            } else {
                [self cancelReplyButtonAction:nil];
            }
        }];
    }
}

- (NSString *)replyInfoForReply:(ForumCommentDataModel *)reply comment:(ForumCommentDataModel *)parentComment
{
    if (reply.isMine) {
        NSString *replyInfo = [NSString stringWithFormat:LOC(@"you_replied_to_{param}"), parentComment.name];
        return replyInfo;
    } else {
        NSString *replyInfo = [NSString stringWithFormat:LOC(@"{person1}_replied_to_{person2}"),reply.name, parentComment.name];
        return replyInfo;
    }
    return @"";
}

- (ForumCommentDataModel *)fetchParentForReply:(ForumCommentDataModel *)commentData
{
    NSNumber *searchingId;
    if (commentData.replyId) {
        searchingId = commentData.replyId;
    } else {
        searchingId = commentData.groupId;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId = %@", searchingId];
    NSArray *filteredArray = [self.commecntsDataSource filteredArrayUsingPredicate:predicate];
    ForumCommentDataModel *parentComment = filteredArray.firstObject;
    
    return parentComment;
}

- (NSArray *)commecntsDataSource
{
    if (self.level == 0) {
        return self.forumDetialsData.strippedComments;
    } else {
        return self.forumDetialsData.comments;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commecntsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentObject = self.commecntsDataSource[indexPath.row];
    NSString *cellIndentifier;
    
    if ([currentObject isKindOfClass:[NSNumber class]]) {
        cellIndentifier = @"ForumMoreRepliesTableViewCell";
        ForumMoreRepliesTableViewCell *moreRepliesCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        [moreRepliesCell configureWithNumber:currentObject];
        moreRepliesCell.viewMoreDelegate = self;
        
        return moreRepliesCell;
    }
    
    ForumCommentDataModel *currentComment = (ForumCommentDataModel *)currentObject;
    if (currentComment.isMine && currentComment.isReply) {
        cellIndentifier = @"ForumCommentCellReply";
    } else if (currentComment.isMine) {
        cellIndentifier = @"ForumCommentCellRight";
    } else if (currentComment.isReply) {
        cellIndentifier = @"ForumCommentCellReply";
    } else {
        cellIndentifier = @"ForumCommentCellRight";
    }
    
    ForumCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    commentCell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    commentCell.delegate = self;
    [commentCell configureWithCommentData:currentComment];
    
    return commentCell;
}

#pragma mark - UITapGesure Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell isKindOfClass:[ForumMoreRepliesTableViewCell class]]) {
        NSLog(@"Here");
    }
    
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

#pragma mark - Actions

- (void)backBarButtonAction
{
    UIViewController *destinationViewController = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:destinationViewController animated:YES];
}

- (IBAction)secondaryBackBattunAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonAction:(UIButton *)sender {
    if (self.composerTextView.text.length > 0) {
        if (self.replyingComment) {
            [self addReplyComment];
        } else if (self.level > 0) {
            self.replyingComment = self.currentComment;
            [self addReplyComment];
        } else {
            [self addComment];
        }
    }
}

- (IBAction)cancelReplyButtonAction:(UIButton *)sender {
    self.replyingComment = nil;
    [self closeReplyView];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Reply functionality



- (void)closeReplyView
{
    self.replyingView.hidden = YES;
    self.composerContainerView.shadowColorType = SYColorTypeLightGray;
    self.composerTextView.text = @"";
    [self textViewDidChange:self.composerTextView];
    [self.composerTextView resignFirstResponder];
}

- (void)commentCellDidSelectReply:(ForumCommentCell *)cell
{
//    Temporary, for testing
    if (self.level > 0) {
        [self.composerTextView becomeFirstResponder];
        self.replyingView.hidden = NO;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [self activateReplyMode:indexPath];
    } else {
        ForumCommentDataModel *selectedComment = cell.commentData;
        if (selectedComment.isReply) {
            ForumCommentDataModel *parentComment = [self.forumDetialsData fetchCommentForId:selectedComment.groupId];
            selectedComment = parentComment;
        }
        
        [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
    }
}

- (void)didSelectViewMoreReplies:(UITableViewCell *)selectedCell
{
    NSIndexPath *moreCellIndexPath = [self.tableView indexPathForCell:selectedCell];
    NSInteger commentIndex = moreCellIndexPath.row - 3;
    ForumCommentDataModel *selectedComment = [self.commecntsDataSource objectAtIndex:commentIndex];
    [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
}

- (void)activateReplyMode:(NSIndexPath *)indexPath
{
    self.replyingComment = self.forumDetialsData.comments[indexPath.row];
    [self configureReplyView];
}

- (void)configureReplyView
{
    self.composerContainerView.shadowColorType = SYColorTypeNone;
    NSString *avatarUrlString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, self.replyingComment.imagePath];
    NSString *replyingString = [NSString stringWithFormat:LOC(@"replying_to_{param}"),self.replyingComment.name];
    
    // TODO: implement right attributes for text
    /*
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:replyingString];
    NSRange range = [replyingString rangeOfString:self.replyingComment.name];
    NSRange startRange = NSMakeRange(0, range.location - 1);
    [attrString addAttributes:@{NSFontAttributeName:[UIFont hyRobotoFontRegularOfSize:12.0]} range:startRange];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont hyRobotoFontBoldOfSize:16.0]} range:range];
     */
    
    [self.replyingUserAvatar sd_setImageWithURL:[NSURL URLWithString:avatarUrlString]];
    self.replyingNameLabel.text = replyingString;
    self.replyingCommentLabel.text = self.replyingComment.message;
}

#pragma mark - Handle Open Notifications

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.composerViewBottomConstraint.constant = -kbSize.height;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height + self.composerContainerView.frame.size.height, 0);
    weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.composerViewBottomConstraint.constant = 0;
    weakify(self)
    [UIView animateWithDuration:0.25 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}


#pragma mark - Composer view // @TODO: REFACOTR, make separate class



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMoreRepliesSegue"]) {
        ForumCommentsViewController *destination = segue.destinationViewController;
        destination.forumItemData = self.forumItemData;
        destination.isForComposing = YES;
        destination.currentComment = (ForumCommentDataModel *)sender;
        destination.level = 1;
    }
}

@end
