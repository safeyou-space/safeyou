//
//  ForumCommentsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <SDWebImage.h>

#import "ForumCommentsViewController.h"
#import "ReportViewController.h"
#import "ForumCommentCell.h"
#import "ForumTitleHeaderView.h"
#import "ForumDetialsData.h"
#import "ChatMessageDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import "ForumTitleHeaderView.h"
#import "ForumItemDataModel.h"
#import "MainTabbarController.h"
#import "ForumMoreRepliesTableViewCell.h"
#import "NotificationData.h"
#import "SocketIOManager.h"
#import "SocketIOAPIService.h"
#import "RoomDataModel.h"
#import "PrivateChatRoomViewController.h"
#import "SendMessageFileDataModel.h"
#import "MessageOptionsView.h"

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhotoViewerArrayDataSource.h>
#import "NYTPhotoModel.h"
#import "UserDataModel.h"
#import "SafeYou-Swift.h"

NSInteger __numberofItemsInPage = 5000;
#define COMPOSER_VIEW_MIN_HEIGHT 51

#define NUMBER_OF_REPLIES_TO_SHOW 2



@import SocketIO;


@interface ForumCommentsViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ForumCommentCellDelegate, MoreRepliesCellDelegate, MessageOptionsViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SocketIOManagerDelegate>

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
@property (weak, nonatomic) IBOutlet UIView *pickedPhotoViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *pickedPhotoImageView;
@property (weak, nonatomic) IBOutlet SYDesignableView *secondarynavigationView;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)cancelReplyButtonAction:(UIButton *)sender;
- (IBAction)sendButtonAction:(UIButton *)sender;

@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) ForumDetialsData *forumDetialsData;

@property (nonatomic) ChatMessageDataModel *replyingComment;

@property (nonatomic) NSArray *viewDataSource;

@property (nonatomic) SocketIOAPIService *socketAPIService;
@property (nonatomic) ForumCommentCell *moreOptionSelectedCell;
@property (nonatomic) MessageOptionsView *selectedMessageOptionsView;
@property (nonatomic) NSString *roomKey;
@property (nonatomic) BOOL isActiveEditMode;
@property (nonatomic) BOOL isUserMinorAndCountryArm;

@property (nonatomic) int commentsCountToSkip;
@property (nonatomic) BOOL isNeedToLoadNewComments;
@property (nonatomic) BOOL requestingForNewComments;

@end

@implementation ForumCommentsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageNumber = 0;
        self.level = 0;
        self.socketAPIService = [[SocketIOAPIService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentsCountToSkip = 0;
    self.isNeedToLoadNewComments = NO;
    self.requestingForNewComments = YES;
    
    [self enableKeyboardNotifications];
    
    [self.composerTextView setValue:LOC(@"type_a_comment") forKey:@"placeholder"];
    
    // Do any additional setup after loading the view.
    [self configureComposerView];
    [self configureNibsForUsing];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.replyingView.hidden = YES;
    [self.secondaryBackButton sizeToFit];
    [self configureViewForLevel];
    [self.cancelEditingGesture setCancelsTouchesInView:NO];
    if (self.level == 0) {
        [self joinToRoom];
    }
    [SocketIOManager sharedInstance].delegate = self;

    self.isUserMinorAndCountryArm = [[Settings sharedInstance].selectedCountryCode isEqualToString:@"arm"] && ![Helper isUserAdultWithBirthday: [Settings sharedInstance].onlineUser.birthday isRegisteration:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainTabbarController] hideTabbar:YES];
    if (self.isForComposing || self.level > 0) {
        [self.composerTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    if (self.level == 0) {
        [self leaveRoom];
    }
}

#pragma mark - Private Methods

- (void)clearCommentData
{
    self.composerTextView.text = @"";
    [self removePhotoButtonAction:nil];
}

- (void)removeMessageOptionsView
{
    if(self.selectedMessageOptionsView != nil) {
        [self.selectedMessageOptionsView removeFromSuperview];
    }
}

- (void)editCommentMessage
{
    self.isActiveEditMode = YES;
    [self removeMessageOptionsView];
    if (self.moreOptionSelectedCell.messageData.messageFiles.count > 0) {
        self.pickedPhotoImageView.image = self.moreOptionSelectedCell.messageData.messageImage;
        self.pickedPhotoViewContainer.hidden = NO;
    }
    self.composerTextView.text = self.moreOptionSelectedCell.messageData.messageContent;
}

- (void)copyCommentMessage
{
    ChatMessageDataModel *chatMessageDataModel = self.moreOptionSelectedCell.messageData;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (chatMessageDataModel.messageContent) {
        pasteboard.string = chatMessageDataModel.messageContent;
    } else if (chatMessageDataModel.messageFiles.count > 0) {
        pasteboard.image = chatMessageDataModel.messageImage;
    }
    [self removeMessageOptionsView];
}

#pragma mark - Service API

- (void)joinToRoom
{
    weakify(self);
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    [self.socketAPIService joinToRoom:forumId success:^(RoomDataModel  * _Nonnull  roomData) {
        strongify(self);
        self.roomKey = roomData.roomKey;
        [self getMeswsagesForRoomKey:roomData.roomKey skip:0];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error");
    }];
}

- (void)leaveRoom
{
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    [self.socketAPIService leaveRoom:forumId success:^(id  _Nonnull response) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getMeswsagesForRoomKey:(NSString *)roomKey skip:(int)skip
{
    weakify(self);
    [self showLoader];
    [self.socketAPIService getRoomMessages:roomKey skip:skip success:^(NSArray<ChatMessageDataModel *> * _Nonnull receivedMessages) {
        strongify(self);
        [self hideLoader];
        NSMutableArray *newDataSource = [[NSMutableArray alloc] initWithArray:receivedMessages];
        [newDataSource addObjectsFromArray:self.viewDataSource];
        self.viewDataSource = newDataSource;
        [self.tableView reloadData];
        self.isNeedToLoadNewComments = receivedMessages.count > 9;
        [self scrollToBottom:receivedMessages.count];
        [self handleReceivedNotification];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)scrollToBottom:(NSUInteger)dataSourceCount
{
    if (dataSourceCount) {
        weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            strongify(self);
            NSInteger lastMessageIndex = dataSourceCount - 1;
            NSInteger scrollRowIndex = [self tableView:self.tableView numberOfRowsInSection:lastMessageIndex] - 1;
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:scrollRowIndex inSection:lastMessageIndex];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.requestingForNewComments = NO;
        });
    }
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
    [self.secondaryBackButton setTitle:LOC(@"comments") forState:UIControlStateNormal];
    [[SocketIOManager sharedInstance].socketClient off:SOCKET_COMMAND_GET_FORUM_DETAILS];
    [self fetchForumData];
}

#pragma mark - Configure Subviews

- (void)configureComposerView
{
    self.composerTextView.tintColor = [UIColor blackColor];
    self.composerTextView.delegate = self;
}

#pragma mark - Pick Photo

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.allowsEditing = YES;
    pickerView.delegate = self;
    if (sourceType == UIImagePickerControllerSourceTypeCamera && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        pickerView.sourceType = sourceType;
    }
    [self presentViewController:pickerView animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    self.pickedPhotoImageView.image = img;
    self.pickedPhotoViewContainer.hidden = NO;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{

}

#pragma mark - Socket data

- (void)fetchForumData
{

}

- (ChatMessageDataModel *)fetchCommentDataFromNotification:(NSString *)replyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"replyId=%@", @(replyId.integerValue)];
    NSArray *filteredArray = [self.forumDetialsData.originalComments filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        ChatMessageDataModel *searchingReply = filteredArray.firstObject;
        NSPredicate *commentPredicate = [NSPredicate predicateWithFormat:@"commentId=%@", searchingReply.roomId];
        NSArray *filteredCommentArray = [self.forumDetialsData.originalComments filteredArrayUsingPredicate:commentPredicate];
        if (filteredCommentArray.count) {
            ChatMessageDataModel *searchingComment = filteredCommentArray.firstObject;
            return searchingComment;
        }
    }
    
    return nil;
}

- (void)loadOlderComments:(UIRefreshControl *)refreshControl
{
    //@TODO: Implement Pagination Functionality
}

// TODO: Dublicate code no time
- (void)addComment
{
    SendMessageFileDataModel *sendMessageFileDataModel = [[SendMessageFileDataModel alloc]
                                                          initWithMessage:self.composerTextView.text
                                                          image:self.pickedPhotoImageView.image
                                                                                        
                                                          audioFileDirectory:nil
                                                                                                 
                                                          commentId:nil];
    [self clearCommentData];
    [self removeMessageOptionsView];
    weakify(self);
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    [self.socketAPIService sendMessageToRoom:forumId sendMessageFile:sendMessageFileDataModel success:^(ChatMessageDataModel * _Nonnull messageObject) {
        strongify(self);
        [self textViewDidChange:self.composerTextView];
        NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
        messageObject.messageImage = self.pickedPhotoImageView.image;
        [mDataSource addObject:messageObject];
        self.viewDataSource = [mDataSource copy];
        if (self.viewDataSource.count == 0) {
            [self.tableView reloadData];
        } else {
            NSInteger insertingSection = self.viewDataSource.count > 1 ? self.viewDataSource.count - 1 : 1;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:insertingSection];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self scrollToBottom:self.viewDataSource.count];
        }
    } failure:^(NSError * _Nonnull error) {
        // handle if needed
    }];
}

- (void)editComment
{
    SendMessageFileDataModel *sendMessageFileDataModel = [[SendMessageFileDataModel alloc] initWithMessage:self.composerTextView.text
                                                                                                     image:self.pickedPhotoImageView.image
                                                                                        audioFileDirectory:nil
                                                                                                 commentId:nil];
    [self clearCommentData];
    [self removeMessageOptionsView];
    weakify(self);
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    [self.socketAPIService editMessageInRoom:forumId
                                   messageId:self.moreOptionSelectedCell.messageData.messageId
                             sendMessageFile:sendMessageFileDataModel
                                     success:^(ChatMessageDataModel * _Nonnull messageObject) {
        self.isActiveEditMode = NO;
        strongify(self);
        NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.moreOptionSelectedCell];
        [mDataSource replaceObjectAtIndex:indexPath.section withObject:messageObject];
        self.viewDataSource = [mDataSource copy];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)deleteCommentMessage
{
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    [self.socketAPIService deleteMessageInRoom:forumId messageId:self.moreOptionSelectedCell.messageData.messageId success:^(BOOL success) {
        if(success) {
            if (self.level > 0) {
                NSMutableArray *mDataSource = [self.currentComment.replies mutableCopy];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:self.moreOptionSelectedCell];
                ChatMessageDataModel *sectionData = self.currentComment.replies[indexPath.row - 1];
                [mDataSource removeObject:sectionData];
                self.currentComment.replies = mDataSource;
                 
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:self.moreOptionSelectedCell];
                ChatMessageDataModel *sectionData = self.viewDataSource[indexPath.section];
                [mDataSource removeObject:sectionData];
                self.viewDataSource = mDataSource;

                NSInteger deletedSection = indexPath.section;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:deletedSection];
                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)reportUser
{
    [self performSegueWithIdentifier:@"reportUser" sender:self.moreOptionSelectedCell.messageData];
}

- (void)likeMessageWith:(NSNumber *)messageId like:(BOOL)like
{
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    int likeInt = (like ? 1 : 0);
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:[NSNumber numberWithInt:SocketIOSignalMessageLIKED]];
    [params addObject:@{@"like_room_id": forumId,
                        @"like_message_id": messageId,
                        @"like_is_liked": [NSNumber numberWithInt:likeInt]}];
    [[SocketIOManager sharedInstance].socketClient emit:@"signal" with:params completion:^{
        NSLog(@"Did reset");
    }];
}


// TODO: Dublicate code no time
- (void)addReplyComment
{
    weakify(self);
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    SendMessageFileDataModel *sendMessageFileDataModel = [[SendMessageFileDataModel alloc] initWithMessage:self.composerTextView.text
                                                                                                     image:self.pickedPhotoImageView.image
                                                                                        audioFileDirectory:nil
                                                                                                 commentId:self.currentComment.messageId];
    [self clearCommentData];
    [self.socketAPIService sendMessageToRoom:forumId sendMessageFile:sendMessageFileDataModel success:^(ChatMessageDataModel * _Nonnull messageObject) {
        
        strongify(self);
        self.replyingComment = nil;
        self.replyingView.hidden = YES;
        self.composerTextView.text = @"";
        [self textViewDidChange:self.composerTextView];
        NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
        [mDataSource addObject:messageObject];
        self.viewDataSource = [mDataSource copy];
        NSInteger insertingSection = self.viewDataSource.count - 1;
        if (self.level == 0) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:insertingSection];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.currentComment addReplyMessage:messageObject];
            [self.tableView reloadData];
        }
        [self scrollToBottom:self.viewDataSource.count];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Message Send Failed");
    }];
}

- (NSString *)replyInfoForReply:(ChatMessageDataModel *)reply comment:(ChatMessageDataModel *)parentComment
{
    if (reply.isOwner) {
        NSString *replyInfo = [NSString stringWithFormat:LOC(@"you_replied_to_text_key"), parentComment.sender.userName];
        return replyInfo;
    } else {
        NSString *replyInfo = [NSString stringWithFormat:LOC(@"replied_to_text_key"),reply.sender.userName, parentComment.sender.userName];
        return replyInfo;
    }
    return @"";
}

- (ChatMessageDataModel *)fetchParentForReply:(ChatMessageDataModel *)commentData
{
    NSNumber *searchingId;
    if (commentData.messageLevel > 0) {
        searchingId = commentData.parentMessageId;
    } else {
        searchingId = commentData.roomId;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId = %@", searchingId];
    NSArray *filteredArray = [self.viewDataSource filteredArrayUsingPredicate:predicate];
    ChatMessageDataModel *parentComment = filteredArray.firstObject;
    
    return parentComment;
}

- (NSArray *)viewDataSource
{
    return _viewDataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.level == 1) {
        return 1;
    }
    return self.viewDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.level > 0) {
        return self.currentComment.replies.count + 1;
    }
    
    ChatMessageDataModel *sectionData = self.viewDataSource[section];
    if (sectionData.replies.count > NUMBER_OF_REPLIES_TO_SHOW) {
        return NUMBER_OF_REPLIES_TO_SHOW + 2;
    }

    return sectionData.replies.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.requestingForNewComments && self.isNeedToLoadNewComments && indexPath.section == 0) {
        self.requestingForNewComments = YES;
        self.commentsCountToSkip += 10;
        [self getMeswsagesForRoomKey:self.roomKey skip:self.commentsCountToSkip];
    }

    NSString *cellIndentifier;
    ChatMessageDataModel *sectionData = self.viewDataSource[indexPath.section];
    if (self.level == 0) {
        if (indexPath.row > 2) {
            cellIndentifier = @"ForumMoreRepliesTableViewCell";
            ForumMoreRepliesTableViewCell *moreRepliesCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            NSInteger numberOfRmeiningComments = sectionData.replies.count - NUMBER_OF_REPLIES_TO_SHOW;

            [moreRepliesCell configureWithNumber:@(numberOfRmeiningComments)];
            moreRepliesCell.viewMoreDelegate = self;
            
            return moreRepliesCell;
        }
    } else {
        sectionData = self.currentComment;
    }
    
    id currentObject;
    if (indexPath.row == 0) {
        currentObject = sectionData;
    } else {
        currentObject = sectionData.replies[indexPath.row - 1];
    }
    
    ChatMessageDataModel *currentComment = (ChatMessageDataModel *)currentObject;
    if (currentComment.isReply && (currentComment.messageLevel > 0)) {
        cellIndentifier = @"ForumCommentCellReply";
    } else if (currentComment.isMine) {
        if (currentComment.messageLevel > 0) {
            cellIndentifier = @"ForumCommentCellReply";
        } else {
            cellIndentifier = @"ForumCommentCellRight";
        }
    } else if (currentComment.messageLevel > 0) {
        cellIndentifier = @"ForumCommentCellReply";
    } else {
        cellIndentifier = @"ForumCommentCellRight";
    }
    
    ForumCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    commentCell.delegate = self;
    [commentCell configureWithMessageData:currentComment andUserAge:self.isUserMinorAndCountryArm];
    
    return commentCell;
}

- (void)socketIOManager:(SocketIOManager *)manager didInsertMessage:(id)messageData
{
    ChatMessageDataModel *chatMessageDataModel = (ChatMessageDataModel *)messageData;
    NSLog(@"Received Data: %@", messageData);
    if (chatMessageDataModel.parentMessageId != 0) {
        if (self.level > 0) {
            [self addReplyInReplyView:chatMessageDataModel];
        } else {
            [self addReplyInCommentView:chatMessageDataModel.parentMessageId repliedMessage:chatMessageDataModel];
        }
    } else {
        if ([self.viewDataSource containsObject:chatMessageDataModel]) {
            return;
        }
        NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
        [mDataSource addObject:chatMessageDataModel];
        self.viewDataSource = [mDataSource copy];
        NSInteger insertingSection = self.viewDataSource.count - 1;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:insertingSection];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)addReplyInCommentView:(NSNumber *)commentMessageId repliedMessage:(ChatMessageDataModel *)repliedMessage {
    int index = 0;
    for (ChatMessageDataModel *comment in self.viewDataSource) {
        if (comment.messageId == commentMessageId) {
            repliedMessage.isReply = YES;
            [comment addReplyMessage:repliedMessage];
            if (comment.replies.count > 2) {
                [self.tableView reloadData];
            } else {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:comment.replies.count-1 inSection:index];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        }
        index += 1;
    }
}

- (void)addReplyInReplyView:(ChatMessageDataModel *)repliedMessage
{
    [self.currentComment addReplyMessage:repliedMessage];
    [self.tableView reloadData];
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
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self removeMessageOptionsView];
}


#pragma mark - Actions

- (void)backBarButtonAction {
    UIViewController *destinationViewController = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:destinationViewController animated:YES];
}

- (IBAction)secondaryBackBattunAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonAction:(UIButton *)sender {
    if (self.composerTextView.text.length > 0 || self.pickedPhotoImageView.image != nil) {
        if(self.isActiveEditMode) {
            [self editComment];
        } else {
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
}

- (IBAction)cancelReplyButtonAction:(UIButton *)sender {
    self.replyingComment = nil;
    [self closeReplyView];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self removeMessageOptionsView];
    [self.view endEditing:YES];
}

- (IBAction)openPhotoLibraryButtonAction:(id)sender
{
    [self removeMessageOptionsView];
    [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)openCameraButtonAction:(id)sender
{
    [self removeMessageOptionsView];
    [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)removePhotoButtonAction:(id)sender
{
    self.pickedPhotoViewContainer.hidden = YES;
    self.pickedPhotoImageView.image = nil;
}

#pragma mark - Service API

- (void)startChatWithUser:(ChatUserDataModel *)chatUserData
{
    [self showLoader];
    weakify(self);
    [self.socketAPIService joinToPrivateRoomWithUser:chatUserData success:^(RoomDataModel * roomData) {
        strongify(self);
        [self hideLoader];
        [self showPrivateChatView:roomData];
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        [self joinToRoom];
    }];
}

- (void)showPrivateChatView:(RoomDataModel *)roomData
{
    [self performSegueWithIdentifier:@"showPrivateChatFromForumComments" sender:roomData];
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

- (void)commentCellDidSelectLike:(NSNumber *)messageId isLiked:(BOOL)isLiked
{
    [self removeMessageOptionsView];
    [self likeMessageWith:messageId like:isLiked];
}

- (void)commentCellDidSelectMessage:(ForumCommentCell *)cell
{
    [self removeMessageOptionsView];
    ChatMessageDataModel *messageData = cell.messageData;
    NSString *forumId = [NSString stringWithFormat:@"%@", self.forumItemData.forumItemId];
    weakify(self);
    [self.socketAPIService leaveRoom:forumId success:^(RoomDataModel * _Nonnull response) {
        strongify(self);
        [self startChatWithUser:messageData.sender];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self joinToRoom];
    }];
}

- (void)commentCellDidSelectReply:(ForumCommentCell *)cell
{
    [self removeMessageOptionsView];
//    Temporary, for testing
    if (self.level > 0) {
        [self.composerTextView becomeFirstResponder];
        self.replyingView.hidden = NO;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self activateReplyMode:indexPath];
    } else {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        ChatMessageDataModel *selectedComment = self.viewDataSource[cellIndexPath.section];
        
        [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
    }
}

- (void)commentCellDidSelectMore:(ForumCommentCell *)cell moreButton:(SYDesignableButton *)button
{
    [self removeMessageOptionsView];
    self.moreOptionSelectedCell = cell;
    CGPoint convertedPoint = [button.superview convertPoint:CGPointMake(button.frame.origin.x, button.frame.origin.y) toView:self.view];
    
    NSMutableArray <MessageOptionButton *> *buttonsArray = [[NSMutableArray alloc] init];
    if(self.moreOptionSelectedCell.messageData.isOwner) {
        MessageOptionButton *editButton = [[MessageOptionButton alloc] initWithTitle:LOC(@"edit_key") image:[UIImage imageNamed:@"edit_button"] tag:Edit];
        MessageOptionButton *deleteButton = [[MessageOptionButton alloc] initWithTitle:LOC(@"delete_key") image:[UIImage imageNamed:@"delete_recycle_icon"] tag:Delete];
        [buttonsArray addObject:editButton];
        [buttonsArray addObject:deleteButton];
    } else {
        MessageOptionButton *reportButton = [[MessageOptionButton alloc] initWithTitle:LOC(@"report") image:[UIImage imageNamed:@"report_icon"] tag:Report];
        [buttonsArray addObject:reportButton];
    }
    MessageOptionButton *copyButton = [[MessageOptionButton alloc] initWithTitle:LOC(@"copy") image:[UIImage imageNamed:@"copy_icon"] tag:Copy];
    [buttonsArray addObject:copyButton];
    self.selectedMessageOptionsView = [[MessageOptionsView alloc] initWithButtonsArray:[NSArray arrayWithArray:buttonsArray]];
    
    CGFloat messageOptionPrigin_Y;
    if(convertedPoint.y + button.frame.size.height + self.selectedMessageOptionsView.frame.size.height > self.composerStackView.frame.origin.y) {
        messageOptionPrigin_Y = convertedPoint.y + button.frame.size.height - self.selectedMessageOptionsView.frame.size.height;
    } else {
        messageOptionPrigin_Y = convertedPoint.y + button.frame.size.height;
    }
    self.selectedMessageOptionsView.frame = CGRectMake(self.selectedMessageOptionsView.frame.size.width - 10,
                                                       messageOptionPrigin_Y,
                                                       self.selectedMessageOptionsView.frame.size.width,
                                                       self.selectedMessageOptionsView.frame.size.height);
    
    self.selectedMessageOptionsView.delegate = self;
    [self.view addSubview:self.selectedMessageOptionsView];
}

- (void)commentCellDidSelectImage:(ForumCommentCell *)cell
{
    [self removeMessageOptionsView];
    NYTPhotoModel *photo = [[NYTPhotoModel alloc] init];
    photo.image = cell.messageData.messageImage;
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:@[photo]];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:dataSource initialPhoto:nil delegate:nil];
    photosViewController.rightBarButtonItem = nil;
    [self presentViewController:photosViewController animated:NO completion:nil];
}

- (void)didSelectViewMoreReplies:(UITableViewCell *)selectedCell
{
    [self removeMessageOptionsView];
    NSIndexPath *moreCellIndexPath = [self.tableView indexPathForCell:selectedCell];
    ChatMessageDataModel *selectedComment = [self.viewDataSource objectAtIndex:moreCellIndexPath.section];
    [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
}

- (void)activateReplyMode:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.replyingComment = self.currentComment;
    } else {
        self.replyingComment = self.currentComment.replies[indexPath.row - 1];
    }
    [self configureReplyView];
}

- (void)configureReplyView
{
    self.replyingNameLabel.text = self.replyingComment.sender.ngoName ? self.replyingComment.sender.ngoName : self.replyingComment.sender.userName;
    self.replyingCommentLabel.text = self.replyingComment.messageContent;
}

#pragma mark - ConfigureDataSource

- (NSArray *)viewDataSourceFromAllMessages
{
    return nil;
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
    
    [self removeMessageOptionsView];
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
        destination.currentComment = (ChatMessageDataModel *)sender;
        destination.level = 1;
    } else if ([segue.identifier isEqualToString:@"showPrivateChatFromForumComments"]) {
        PrivateChatRoomViewController *destinationVC = segue.destinationViewController;
        destinationVC.roomData = sender;
    } else if ([segue.identifier isEqualToString:@"reportUser"]) {
        ReportViewController *destinationVC = segue.destinationViewController;
        destinationVC.comment = sender;
        destinationVC.forumId = self.forumItemData.forumItemId;
        destinationVC.roomKey = self.roomKey;
        destinationVC.isForumReport = YES;
    }
}

#pragma mark - MessageOptionsViewDelegate Methods

- (void)messageOptionsDidSelectButton:(MessageOptionButton *)button {
    [self removeMessageOptionsView];
    switch (button.tag) {
        case Edit:
            [self editCommentMessage];
            break;
        case Delete:
            [self deleteCommentMessage];
            break;
        case Copy:
            [self copyCommentMessage];
            break;
        case Report:
            [self reportUser];
            break;
        default:
            break;
    }
}

#pragma mark - Remote notification

- (void)handleReceivedNotification
{
    if ([Settings sharedInstance].receivedRemoteNotification) {
        RemoteNotificationType notifyType = [[Settings sharedInstance].receivedRemoteNotification[@"notify_type"] integerValue];
        if (notifyType == NotificationTypeMessage) {
            NSString *messageParrentIdStr = [Settings sharedInstance].receivedRemoteNotification[@"message_parent_id"];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *messageParrentId = [formatter numberFromString:messageParrentIdStr];
            ChatMessageDataModel *selectedComment = [self fetchSelectedCommentWithId: messageParrentId];
            if (selectedComment) {
                [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
            }
        }
        [Settings sharedInstance].receivedRemoteNotification = nil;
    } else if ([self mainTabbarController].isFromNotificationsView) {
        NSInteger messageParentId = self.mainTabbarController.selectedNotificationData.notificationMessage.messageParentId;
        ChatMessageDataModel *selectedComment = [self fetchSelectedCommentWithId: [NSNumber numberWithInteger:messageParentId]];
        if (selectedComment) {
            [self performSegueWithIdentifier:@"showMoreRepliesSegue" sender:selectedComment];
        }
        [self mainTabbarController].isFromNotificationsView = NO;
    }
}

- (ChatMessageDataModel *)fetchSelectedCommentWithId:(NSNumber *)messageId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId=%@", messageId];
    NSArray *filteredArray =  [self.viewDataSource filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        ChatMessageDataModel *selectedForum = filteredArray.firstObject;
        return selectedForum;
    }
    return nil;
}

@end
