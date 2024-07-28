//
//  ForumCommentCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumCommentCell.h"
#import "ChatMessageDataModel.h"
#import <SDWebImage.h>
#import "UserDataModel.h"
#import "SocketIOManager.h"
#import "MessageFileDataModel.h"

@interface ForumCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet SYLabelBold *userNameLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *userRoleLabel;

@property (weak, nonatomic) IBOutlet UITextView *commentContentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *messageContentImageView;

@property (weak, nonatomic) IBOutlet SYLabelLight *commentDateLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *userCheckIconImageView;

@property (weak, nonatomic) IBOutlet SYDesignableButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *likeButtonDotSeperator;
@property (weak, nonatomic) IBOutlet SYDesignableButton *messageButton;
@property (weak, nonatomic) IBOutlet UIView *messageButtonDotSeperator;
@property (weak, nonatomic) IBOutlet SYDesignableButton *replyButton;
@property (weak, nonatomic) IBOutlet UIView *replyButtonDotSeperator;
@property (weak, nonatomic) IBOutlet SYDesignableButton *moreButton;

@property (weak, nonatomic) IBOutlet SYDesignableView *mainContentView;

@property (weak, nonatomic) IBOutlet SYDesignableView *likesCountView;
@property (weak, nonatomic) IBOutlet SYLabelLight *likesCountLabel;


@property (weak, nonatomic) IBOutlet SYDesignableView *replyInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyInfoHeightConstraint;
@property (weak, nonatomic) IBOutlet SYLabelItalic *replyInfoLabel;

@end

@implementation ForumCommentCell

//@synthesize messageData = _messageData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithMessageData:(ChatMessageDataModel *)messageData language:(NSString *)language andUserAge:(BOOL)isMinorUser
{
    self.messageData = messageData;
    [self.avatarImageView sd_setImageWithURL:self.messageData.sender.avatarUrl];
    self.userNameLabel.text = self.messageData.sender.userName;
    
    if (messageData.messageFiles.count > 0) {
        MessageFileDataModel *messageFileDataModel = [MessageFileDataModel modelObjectWithDictionary:messageData.messageFiles[0]];
        if (messageFileDataModel.type == FileTypeImage) {
            self.messageContentImageView.hidden = NO;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)];
            [self.messageContentImageView addGestureRecognizer:tapGesture];
            [self.messageContentImageView sd_setImageWithURL:[messageFileDataModel mediaPath] placeholderImage:messageData.messageImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if(image != nil) {
                    messageData.messageImage = image;
                }
            }];
        }
    } else {
        self.messageContentImageView.hidden = YES;
    }
    
    if ((([SocketIOManager sharedInstance].chatOnlineUser.role == ChatUserRoleUser) && (_messageData.sender.role == ChatUserRoleUser)) || isMinorUser) {
        self.messageButton.hidden = YES;
        self.messageButtonDotSeperator.hidden = YES;
    } else {
        self.messageButton.hidden = NO;
        self.messageButtonDotSeperator.hidden = NO;
    }
    
    self.commentContentTextView.text = self.messageData.messageContent;
    self.commentDateLabel.text = self.messageData.formattedCreatedDate;
    
    if (self.messageData.sender.role == ChatUserRoleUser) {
        self.userCheckIconImageView.hidden = YES;
    } else {
        self.userCheckIconImageView.hidden = NO;
    }
    self.userRoleLabel.textColorType = SYColorTypeMain1;
    
    if (self.messageData.sender.role != ChatUserRoleUser) {
        NSString *appLanguage = [self.messageData.sender.profession objectForKey:language];
        self.userRoleLabel.text = appLanguage;
    } else {
        self.userRoleLabel.text = @"";
    }
    if (self.replyInfoLabel && messageData.isReply) {
        self.replyInfoLabel.text = messageData.replyInfo;
    }
    
    [self configureLikeButton];
    
    if (messageData.isMine) {
        self.mainContentView.backgroundColorType = SYColorTypeMain6;
        self.mainContentView.backgroundColorAlpha = 1;
    } else {
        self.mainContentView.backgroundColorType = SYColorTypeWhite;
        self.mainContentView.backgroundColorAlpha = 1;
    }
    
    if (self.messageData.messageLevel > 0) {
        self.replyInfoView.hidden = NO;
        self.replyInfoHeightConstraint.constant = 30;
        self.replyInfoLabel.text = self.messageData.replyInfo;
    } else {
        self.replyInfoView.hidden = YES;
        self.replyInfoHeightConstraint.constant = 0;
    }
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 3);
}

- (void)configureLikeButton
{
    if (self.messageData.likesCount > 0) {
        self.likesCountView.hidden = NO;
        NSString *likesCountText = [NSString stringWithFormat:@"%@", @(self.messageData.likesCount)];
        self.likesCountLabel.text = likesCountText;
    } else {
        self.likesCountView.hidden = YES;
    }
    
    if (self.messageData.isLiked) {
        [self.likeButton setImage:[[UIImage imageNamed:@"icon_like_selected"] imageWithTintColor:UIColor.mainTintColor1] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[[UIImage imageNamed:@"icon_like"] imageWithTintColor:UIColor.mainTintColor1] forState:UIControlStateNormal];
    }
}

#pragma mark - IBActions

- (IBAction)likeButtonPressed:(SYDesignableButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectLike:isLiked:)]) {
        self.messageData.isLiked = !self.messageData.isLiked;
        self.messageData.likesCount = self.messageData.isLiked ? self.messageData.likesCount + 1 : self.messageData.likesCount - 1;
        [self configureLikeButton];
        [self.delegate commentCellDidSelectLike:self.messageData.messageId isLiked:self.messageData.isLiked];
    }
}

- (IBAction)messageButtonPressed:(SYDesignableButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectMessage:)]) {
        [self.delegate commentCellDidSelectMessage:self];
    }
}

- (IBAction)replyButtonPressed:(SYDesignableButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectReply:)]) {
        [self.delegate commentCellDidSelectReply:self];
    }
}

- (IBAction)moreButtonPressed:(SYDesignableButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectMore:moreButton:)]) {
        [self.delegate commentCellDidSelectMore:self moreButton:sender];
    }
}

- (void)tapOnImageView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectImage:)]) {
        [self.delegate commentCellDidSelectImage:self];
    }
}

@end
