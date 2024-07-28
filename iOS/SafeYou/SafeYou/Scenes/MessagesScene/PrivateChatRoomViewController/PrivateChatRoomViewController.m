//
//  PrivateChatRoomViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "PrivateChatRoomViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage.h>
#import "PrivateChatTableViewCell.h"
#import "ChatMessageDataModel.h"
#import "ChatUserDataModel.h"
#import "MainTabbarController.h"
#import "NotificationData.h"
#import "SocketIOManager.h"
#import "SocketIOAPIService.h"
#import "RoomDataModel.h"
#import <Speech/Speech.h>
#import <AVKit/AVKit.h>
#import "SendMessageFileDataModel.h"
#import "MessageFileDataModel.h"
#import "ReportViewController.h"
#import "UserDataModel.h"

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhotoViewerArrayDataSource.h>
#import "NYTPhotoModel.h"

#define CHAT_LEFT_CELL_IDENTIFIER @"ChatLeftTableViewCell"
#define CHAT_RIGHT_CELL_IDENTIFIER @"ChatRightTableViewCell"
#define CHAT_LEFT_AUDIO_CELL_IDENTIFIER @"ChatLeftTableViewAudioCell"
#define CHAT_RIGHT_AUDIO_CELL_IDENTIFIER @"ChatRightTableViewAudioCell"
#define TABLE_VIEW_TOP_CONTENT_INSET 6
#define TABLE_VIEW_BOTTOM_CONTENT_INSET 8
#define COMPOSER_VIEW_MIN_HEIGHT 51
#define NUMBER_OF_REPLIES_TO_SHOW 2

@import SocketIO;

@interface PrivateChatRoomViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SocketIOManagerDelegate, PrivateChatTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *composerStackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SYDesignableView *replyingView;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *replyingUserAvatar;
@property (weak, nonatomic) IBOutlet SYLabelBold *replyingNameLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *replyingCommentLabel;
@property (weak, nonatomic) IBOutlet SYDesignableButton *secondaryBackButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelEditingGesture;

// composer view
@property (weak, nonatomic) IBOutlet SYDesignableView *composerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *composerViewheightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *composerTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *audioRecordButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *composerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *pickedPhotoViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *pickedPhotoImageView;
@property (weak, nonatomic) IBOutlet SYDesignableView *secondarynavigationView;
@property (weak, nonatomic) IBOutlet SYDesignableView *sendAudioVoiceView;
@property (weak, nonatomic) IBOutlet SYLabelLight *audioTimerLabel;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)cancelReplyButtonAction:(UIButton *)sender;
- (IBAction)sendButtonAction:(UIButton *)sender;

@property (nonatomic) NSUInteger pageNumber;

@property (nonatomic) ChatMessageDataModel *replyingComment;
@property (nonatomic) ChatMessageDataModel *selectedMessage;

@property (nonatomic) NSArray *viewDataSource;
@property (nonatomic) NSIndexPath *indexPath;

@property (nonatomic) SocketIOAPIService *socketAPIService;

@property (nonatomic) AVAudioSession *audioSession;
@property (nonatomic) AVAudioRecorder *audioRecorder;
@property (nonatomic) NSTimer *voiceRecordTimer;
@property (nonatomic) BOOL isVoiceRecordingEnabled;
@property (nonatomic) int voiceRecordTime;

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) PrivateChatTableViewCell *audioOlayedCell;

@property (nonatomic, strong) UIBarButtonItem *notificationButton;

@property (nonatomic) int commentsCountToSkip;
@property (nonatomic) BOOL isNeedToLoadNewComments;
@property (nonatomic) BOOL requestingForNewComments;
@property (nonatomic) BOOL isRoomExist;

// For Shoing

@end

@implementation PrivateChatRoomViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageNumber = 0;
        self.socketAPIService = [[SocketIOAPIService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNumber *userId = [Settings sharedInstance].onlineUser.userId;
    if (self.chatData != nil) {
        if ([self.chatData.ngoName isKindOfClass:NSString.class]) {
            self.title = self.chatData.ngoName;
        } else {
            self.title = self.chatData.userName;
        }
        self.roomKey = [
            [NSString alloc]
            initWithFormat:@"PRIVATE_CHAT_%@_%@",
            userId, self.chatData.userId
        ];
    } else {
        self.title = self.roomData.roomName;
        self.roomKey = self.roomData.roomKey;
    }
    self.commentsCountToSkip = 0;
    self.isNeedToLoadNewComments = NO;
    self.requestingForNewComments = YES;
    
    [self enableKeyboardNotifications];
    
    [self.composerTextView setValue:LOC(@"type_a_message") forKey:@"placeholder"];
    
    // Do any additional setup after loading the view.
    [self setVoiceRecordUIActive:NO];
    [self configureComposerView];
    [self configureNibsForUsing];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(TABLE_VIEW_TOP_CONTENT_INSET, 0, TABLE_VIEW_BOTTOM_CONTENT_INSET, 0);
    self.replyingView.hidden = YES;
    [self.secondaryBackButton sizeToFit];
    [self.cancelEditingGesture setCancelsTouchesInView:NO];
    [self joinToRoom];
    [self readAllMessages];
    [SocketIOManager sharedInstance].delegate = self;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.tableView addGestureRecognizer:lpgr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainTabbarController] hideTabbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [self leaveRoom];
    [super viewWillDisappear:animated];
    
}

#pragma mark - Private Methods

- (void)clearCommentData
{
    self.composerTextView.text = @"";
    [self removePhotoButtonAction:nil];
}

-(void)copyMessage
{
    ChatMessageDataModel *chatMessageDataModel = self.selectedMessage;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (chatMessageDataModel.messageFiles.count == 0) {
        pasteboard.string = chatMessageDataModel.messageContent;
    } else {
        pasteboard.image = chatMessageDataModel.messageImage;
    }
    [self showNotificationButton];
}

-(void)openReportView
{
    [self showNotificationButton];
    [self performSegueWithIdentifier:@"reportUser" sender:self.selectedMessage];
}

#pragma mark - Voice record methods

- (void)startVoiceRecording {
    NSURL *audioFileDirectory = [self getAudioFileDirectory];
    NSDictionary *settings = @{ AVEncoderAudioQualityKey : @(AVAudioQualityHigh),
                                AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                AVSampleRateKey : @12000,
                                AVNumberOfChannelsKey : @1};
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioFileDirectory settings:settings error:nil];
    if (self.audioRecorder != nil) {
        [self.audioRecorder record];
        [self startVoiceRecordTimer];
        [self setVoiceRecordUIActive:YES];
        self.isVoiceRecordingEnabled = YES;
    }
}

- (void)stopVoiceRecording {
    [self.audioRecorder stop];
    [self stopVoiceRecordTimer];
    [self setVoiceRecordUIActive:NO];
    self.isVoiceRecordingEnabled = NO;
}

- (void)startVoiceRecordTimer {
    if(self.voiceRecordTimer != nil) {
        [self.voiceRecordTimer invalidate];
    }
    self.voiceRecordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementAudioTimer) userInfo:nil repeats:YES];
}

- (void)stopVoiceRecordTimer {
    [self.voiceRecordTimer invalidate];
}

- (void)setVoiceRecordUIActive:(BOOL)active {
    if(active) {
        self.sendAudioVoiceView.hidden = NO;
        [self updateAudioTimerLabel];
    } else {
        self.sendAudioVoiceView.hidden = YES;
        self.voiceRecordTime = 0;
    }
}

- (void)incrementAudioTimer {
    self.voiceRecordTime += 1;
    [self updateAudioTimerLabel];
}

- (void)updateAudioTimerLabel {
    int seconds = self.voiceRecordTime % 60;
    int minutes = (self.voiceRecordTime / 60) % 60;
    self.audioTimerLabel.text = [NSString stringWithFormat:@"%d:%.2d", minutes, seconds];
}

- (NSURL*)getAudioFileDirectory {
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *url = paths[0];
    return [url URLByAppendingPathComponent:@"recording.m4a"];
}

#pragma mark - Service API

- (void)joinToRoom
{
    self.isRoomExist = YES;
    weakify(self);
    NSString *roomKey = [NSString stringWithFormat:@"%@", self.roomKey];
    [self.socketAPIService joinToRoom:roomKey success:^(RoomDataModel  * _Nonnull  roomData) {
        strongify(self);
        if (self.roomData.roomName != nil) {
            self.title = self.roomData.roomName;
        }
        [self getMeswsagesForRoomKey:self.roomKey skip:0];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Join Room Error %@", error);
        strongify(self);
        if (error.code == 400) {
            [self getMeswsagesForRoomKey:self.roomKey skip:0];
        }
        if (error.code == 404) {
            self.isRoomExist = NO;
        }
    }];
}

- (void)leaveRoom
{
    NSString *roomKey = [NSString stringWithFormat:@"%@", self.roomKey];
    [self.socketAPIService leaveRoom:roomKey success:^(id  _Nonnull response) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getMeswsagesForRoomKey:(NSString *)roomKey skip:(int)skip
{
    weakify(self);
    [self showLoader];
    [self.socketAPIService getRoomMessages:roomKey skip:skip success:^(NSArray<ChatMessageDataModel *> * _Nonnull receivedMessages) {
        strongify(self);
        NSMutableArray *newDataSource = [[NSMutableArray alloc] initWithArray:receivedMessages];
        [newDataSource addObjectsFromArray:self.viewDataSource];
        [self hideLoader];
        self.viewDataSource = newDataSource;
        [self.tableView reloadData];
        self.isNeedToLoadNewComments = receivedMessages.count > 9;
        [self scrollToBottom:receivedMessages.count];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)scrollToBottom:(NSUInteger)dataSourceCount
{
    if (dataSourceCount) {
        weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            strongify(self);
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:dataSourceCount - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.requestingForNewComments = NO;
        });
    }
}

#pragma mark - Pull to refresh functionality

- (void)configurePullToRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];

    [refreshControl addTarget:self action:@selector(loadOlderMessages:)
    forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:refreshControl];
}

- (void)loadOlderMessages
{
    
}

#pragma mark - Configure Nibs

- (void)configureNibsForUsing
{
    UINib *leftCellNib = [UINib nibWithNibName:@"ChatLeftTableViewCell" bundle:nil];
    [self.tableView registerNib:leftCellNib forCellReuseIdentifier:CHAT_LEFT_CELL_IDENTIFIER];
    
    UINib *rightCellNib = [UINib nibWithNibName:@"ChatRightTableViewCell" bundle:nil];
    [self.tableView registerNib:rightCellNib forCellReuseIdentifier:CHAT_RIGHT_CELL_IDENTIFIER];
    
    UINib *leftAudioCellNib = [UINib nibWithNibName:@"ChatLeftTableViewCell" bundle:nil];
    [self.tableView registerNib:leftCellNib forCellReuseIdentifier:CHAT_LEFT_AUDIO_CELL_IDENTIFIER];
    
    UINib *rightAudioCellNib = [UINib nibWithNibName:@"ChatRightTableViewCell" bundle:nil];
    [self.tableView registerNib:rightCellNib forCellReuseIdentifier:CHAT_RIGHT_AUDIO_CELL_IDENTIFIER];
}


#pragma mark - Translations
- (void)updateLocalizations
{
    [[SocketIOManager sharedInstance].socketClient off:SOCKET_COMMAND_GET_FORUM_DETAILS];
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
//    CGSize calculatingSize = CGSizeMake(textView.frame.size.width - 10, MAXFLOAT);
//    CGSize textSize = [textView.text boundingRectWithSize:calculatingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textView.font} context:nil].size;
//
//    CGFloat heightWithMargins = textSize.height + 16 + 20; // text view margins, text bottom top insets
//
//    if (heightWithMargins > 52) {
//        if (textSize.height < 155) {
//            self.composerViewheightConstraint.constant = heightWithMargins;
//            [self.view setNeedsLayout];
//            [self.view layoutIfNeeded];
//        }
//    }
    
    
//    NSLog(@"width = %@, height = %@", @(textSize.width), @(textSize.height));
}

#pragma mark - Socket data


//- (ChatMessageDataModel *)fetchCommentDataFromNotification:(NSString *)replyId
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"replyId=%@", @(replyId.integerValue)];
//    NSArray *filteredArray = [self.forumDetialsData.originalComments filteredArrayUsingPredicate:predicate];
//    if (filteredArray.count) {
//        ChatMessageDataModel *searchingReply = filteredArray.firstObject;
//        NSPredicate *commentPredicate = [NSPredicate predicateWithFormat:@"commentId=%@", searchingReply.roomId];
//        NSArray *filteredCommentArray = [self.forumDetialsData.originalComments filteredArrayUsingPredicate:commentPredicate];
//        if (filteredCommentArray.count) {
//            ChatMessageDataModel *searchingComment = filteredCommentArray.firstObject;
//            return searchingComment;
//        }
//    }
//
//    return nil;
//}

// TODO: Dublicate code no time
- (void)addComment
{
    NSLog(@"We are here");
    /**
     NSDictionary *params = @{
     //            @"language_code": languageCode,
     //            @"forum_id": self.forumItemData.forumItemId,
     //            @"messages": self.composerTextView.text,
     //            @"reply_id": self.replyingComment.commentId,
     //            @"group_id": groupId,
     //            @"level": @(++level),
     //            @"reply_user_id": self.replyingComment.userId
     //        };
     */
    
    /**
     message_content:Hello Chat!
         message_type:1
         message_mention_options:[{"test": "text"}]
         message_replies[0]:431
         message_replies[1]:432
         message_files[0]:<binary_file>
         message_files[1]:<binary_file>
         message_deleted_files[0]:1
         message_deleted_files[1]:2
     */
    NSURL *audioUrl;
    if(self.isVoiceRecordingEnabled) {
        [self stopVoiceRecording];
        audioUrl = [self getAudioFileDirectory];
    }
    SendMessageFileDataModel *sendMessageFileDataModel = [[SendMessageFileDataModel alloc] initWithMessage:self.composerTextView.text
                                                                                                     image:self.pickedPhotoImageView.image
                                                                                        audioFileDirectory:audioUrl
                                                                                                 commentId:nil];
    [self clearCommentData];
    weakify(self);
    NSString *roomKey = [NSString stringWithFormat:@"%@", self.roomKey];
    [self.socketAPIService sendMessageToRoom:roomKey sendMessageFile:sendMessageFileDataModel success:^(ChatMessageDataModel * _Nonnull messageObject) {
        strongify(self);
        [self textViewDidChange:self.composerTextView];
        NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
        messageObject.messageImage = self.pickedPhotoImageView.image;
        [mDataSource addObject:messageObject];
        self.viewDataSource = [mDataSource copy];
        [self.tableView reloadData];
        [self scrollToBottom:self.viewDataSource.count];
    } failure:^(NSError * _Nonnull error) {
        // handle if needed
    }];
}

// TODO: Dublicate code no time
- (void)addReplyComment
{
    NSLog(@"We are here");
    /**
     NSDictionary *params = @{
     //            @"language_code": languageCode,
     //            @"forum_id": self.forumItemData.forumItemId,
     //            @"messages": self.composerTextView.text,
     //            @"reply_id": self.replyingComment.commentId,
     //            @"group_id": groupId,
     //            @"level": @(++level),
     //            @"reply_user_id": self.replyingComment.userId
     //        };
     */
    
    /**
     message_content:Hello Chat!
         message_type:1
         message_mention_options:[{"test": "text"}]
         message_replies[0]:431
         message_replies[1]:432
         message_files[0]:<binary_file>
         message_files[1]:<binary_file>
         message_deleted_files[0]:1
         message_deleted_files[1]:2
     */
    weakify(self);
    NSString *roomKey = [NSString stringWithFormat:@"%@", self.roomKey];
    SendMessageFileDataModel *sendMessageFileDataModel = [[SendMessageFileDataModel alloc] initWithMessage:self.composerTextView.text
                                                                                                     image:self.pickedPhotoImageView.image
                                                                                        audioFileDirectory:nil
                                                                                                 commentId:nil];
    [self.socketAPIService sendMessageToRoom:roomKey sendMessageFile:sendMessageFileDataModel success:^(ChatMessageDataModel * _Nonnull messageObject) {
        NSLog(@"Message Sent");
        strongify(self);
        self.composerTextView.text = @"";
        [self textViewDidChange:self.composerTextView];
        NSMutableArray *mDataSource = [self.viewDataSource mutableCopy];
        [mDataSource addObject:messageObject];
        self.viewDataSource = [mDataSource copy];
        NSInteger insertingSection = self.viewDataSource.count - 1;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:insertingSection];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (BOOL)getAudioChatCell:(NSUInteger )index
{
    ChatMessageDataModel *currentMessage = self.viewDataSource[index];
    BOOL type = false;
    
    if (currentMessage.messageType == MessageTypeMedia) {
        
        MessageFileDataModel *messageFileDataModel  = [MessageFileDataModel modelObjectWithDictionary:currentMessage.messageFiles[0]];

            if([messageFileDataModel.mimetype isEqualToString:@"audio/mpeg"] || [messageFileDataModel.mimetype isEqualToString:@"audio/wav"]) {
               
                type = YES;
        }
    }
    return  type;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data = [self.viewDataSource objectAtIndex:indexPath.row];
    BOOL lastItemReached = [data isEqual:[self.viewDataSource lastObject]];
    self.indexPath = indexPath;
    NSLog(@"index  %ld", (long)indexPath.row);
    if (!self.requestingForNewComments && self.isNeedToLoadNewComments && !lastItemReached && indexPath.row == 0) {
        self.requestingForNewComments = YES;
        self.commentsCountToSkip += 10;
        [self getMeswsagesForRoomKey:self.roomKey skip:self.commentsCountToSkip];
    }
    
    PrivateChatTableViewCell *cell;
    ChatMessageDataModel *currentMessage = self.viewDataSource[indexPath.row];

    if ([self getAudioChatCell:indexPath.row]) {
        
    }
    
    if (currentMessage.isMine) {
        cell = [tableView dequeueReusableCellWithIdentifier:CHAT_RIGHT_CELL_IDENTIFIER forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CHAT_LEFT_CELL_IDENTIFIER forIndexPath:indexPath];
    }
    [cell configureWithMessageData:currentMessage];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITapGesure Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    
    return YES;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath != nil && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self configureBarItems:indexPath];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //@TODO: handle chat message selection
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
    if(self.composerTextView.text.length == 0 && self.pickedPhotoImageView.image == nil && !self.isVoiceRecordingEnabled) {
        return;
    }
    if (self.replyingComment) {
        [self addReplyComment];
    } else {
        if (_isRoomExist) {
            [self addComment];
        } else {
            [self.socketAPIService createRoomWithUser:_chatData success:^(RoomDataModel  * _Nonnull  roomData) {
                [self joinToRoom];
                [self addComment];
                
            } failure:^(NSError * _Nonnull error) {
              //  NSLog(@"Join Room Error %@", error);
            }];
        }
        
    }
}

- (IBAction)startVoiceRecordButtonAction:(id)sender {
    self.audioSession = AVAudioSession.sharedInstance;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [self.audioSession requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self startVoiceRecording];
            }
        });
    }];
}

- (IBAction)cancelVoiceRecordButtonAction:(id)sender {
    [self stopVoiceRecording];
}

- (IBAction)cancelReplyButtonAction:(UIButton *)sender {
    self.replyingComment = nil;
    [self closeReplyView];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)openPhotoLibraryButtonAction:(id)sender
{
    [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)openCameraButtonAction:(id)sender
{
    [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)removePhotoButtonAction:(id)sender
{
    self.pickedPhotoViewContainer.hidden = YES;
    self.pickedPhotoImageView.image = nil;
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

- (void)activateReplyMode:(NSIndexPath *)indexPath
{
//    self.replyingComment = self.forumDetialsData.comments[indexPath.row];
//    [self configureReplyView];
}

- (void)configureReplyView
{
//    self.composerContainerView.shadowColorType = SYColorTypeNone;
//    NSString *avatarUrlString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, self.replyingComment.imagePath];
//    NSString *replyingString = [NSString stringWithFormat:LOC(@"replying_to_text_key"),self.replyingComment.name];
//
//    // TODO: implement right attributes for text
//    /*
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:replyingString];
//    NSRange range = [replyingString rangeOfString:self.replyingComment.name];
//    NSRange startRange = NSMakeRange(0, range.location - 1);
//    [attrString addAttributes:@{NSFontAttributeName:[UIFont regularFontOfSize:12.0]} range:startRange];
//    [attrString addAttributes:@{NSFontAttributeName:[UIFont hyRobotoFontBoldOfSize:16.0]} range:range];
//     */
//
//    [self.replyingUserAvatar sd_setImageWithURL:[NSURL URLWithString:avatarUrlString]];
//    self.replyingNameLabel.text = replyingString;
//    self.replyingCommentLabel.text = self.replyingComment.messageContent;
}

#pragma mark - ConfigureDataSource

- (NSArray *)viewDataSourceFromAllMessages
{
    return nil;
}

#pragma mark - SocketIOManagerDelegate

- (void)socketIOManager:(SocketIOManager *)manager didInsertMessage:(ChatMessageDataModel *)messageData
{
    if (![messageData.sender.userId isEqual:[SocketIOManager sharedInstance].chatOnlineUser.userId]) {
        [self readPrivateMessage:messageData.messageId roomId:messageData.roomId];
        
        NSMutableArray *tempDataSource = [self.viewDataSource mutableCopy];
        [tempDataSource addObject:messageData];
        self.viewDataSource = [tempDataSource copy];
        [self.tableView reloadData];
    }
}

#pragma mark - Handle Open Notifications

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        self.composerViewBottomConstraint.constant = -kbSize.height + bottomPadding;
    } else {
        self.composerViewBottomConstraint.constant = -kbSize.height;
    }
    
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

#pragma mark - AVAudioRecorderDelegate Events

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
}

#pragma mark - PrivateChatTableViewCellDelegate Events

- (void)commentCellDidSelectImage:(PrivateChatTableViewCell *)cell{
    NYTPhotoModel *photo = [[NYTPhotoModel alloc] init];
    photo.image = cell.messageData.messageImage;
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:@[photo]];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:dataSource initialPhoto:nil delegate:nil];
    photosViewController.rightBarButtonItem = nil;
    [self presentViewController:photosViewController animated:NO completion:nil];
}

- (void)commentCellDidSelectPlayAudio:(PrivateChatTableViewCell *)cell {
    if(self.audioOlayedCell != nil) {
        [self.audioOlayedCell stopPlayingAudio];
    }
    self.audioOlayedCell = cell;
    NSURL *audioPath = [cell.messageFileDataModel mediaPath];
    NSData *data = [NSData dataWithContentsOfURL:audioPath];
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    [self.player play];
}

- (void)commentCellDidSelectPauseAudio {
    [self.player pause];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reportUser"]) {
        ReportViewController *destinationVC = segue.destinationViewController;
        destinationVC.comment = sender;
        destinationVC.roomKey = self.roomKey;
        destinationVC.isForumReport = NO;
    }
}

#pragma mark - Navigation bar configuration

-(void)configureBarItems:(NSIndexPath *)indexPath
{
    self.selectedMessage = self.viewDataSource[indexPath.row];
    NSMutableArray *barButtons = [[NSMutableArray alloc] init];
    
    if (!self.selectedMessage.isMine) {
        UIBarButtonItem *reportButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"report_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(openReportView)];
        [barButtons addObject:reportButton];
    }
    
    UIBarButtonItem *copyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"copy_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(copyMessage)];
    [barButtons addObject:copyButton];
    
    if (self.navigationItem.rightBarButtonItem != nil && [self.navigationItem.rightBarButtonItem isKindOfClass:[SYDesignableBarButtonItem class]]) {
        self.notificationButton = self.navigationItem.rightBarButtonItem;
    }
    self.navigationItem.rightBarButtonItems = barButtons;
}

-(void)showNotificationButton
{
    self.navigationItem.rightBarButtonItems = nil;
    if (self.notificationButton != nil) {
        self.navigationItem.rightBarButtonItem = self.notificationButton;
    }
}

-(void)readAllMessages
{
    NSArray *unreadMessages = [Settings sharedInstance].unreadPrivateMessages[self.roomKey];
    if (unreadMessages.count > 0) {
        for (NSNumber *messageId in unreadMessages) {
            [self readPrivateMessage:messageId roomId:self.roomData.roomId];
        }
        [[Settings sharedInstance].unreadPrivateMessages removeObjectForKey:self.roomKey];
        if ([Settings sharedInstance].unreadPrivateMessages.count < 1) {
            [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
        }
    }
}

-(void)readPrivateMessage:(NSNumber *)messageId roomId:(NSNumber *)roomId
{
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:[NSNumber numberWithInt:SocketIOSignalMessageRECEIVED]];
    [params addObject:@{@"received_room_id": roomId,
                        @"received_message_id": messageId,
                        @"received_type": @2}];
    [[SocketIOManager sharedInstance].socketClient emit:@"signal" with:params completion:^{
        NSLog(@"Did send read notification for private message %@", messageId);
    }];
}

@end
