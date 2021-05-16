//
//  ForumCommentCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumCommentCell.h"
#import "ForumCommentDataModel.h"
#import <SDWebImage.h>

@interface ForumCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *userNameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *userRoleLabel;

@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *commentContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *commentDateLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *userCheckIconImageView;
@property (weak, nonatomic) IBOutlet SYDesignableView *shadowedContentView;

@property (weak, nonatomic) IBOutlet SYDesignableView *replyInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyInfoHeightConstraint;
@property (weak, nonatomic) IBOutlet HyRobotoLabelItalic *replyInfoLabel;

- (IBAction)replyButtonPressed:(UIButton *)sender;


@end

@implementation ForumCommentCell

@synthesize commentData = _commentData;

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

- (void)configureWithCommentData:(ForumCommentDataModel *)commentData
{
    _commentData = commentData;
    NSString *avatarUrlString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, commentData.imagePath];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrlString]];
    self.userNameLabel.text = commentData.name;
    
    self.commentContentLabel.text = commentData.message;
    self.commentDateLabel.text = commentData.formattedCreatedDate;
    if (commentData.userTypeId.integerValue == 1) {
        self.userCheckIconImageView.hidden = NO;
    } else {
        self.userCheckIconImageView.hidden = YES;
    }
    self.userRoleLabel.textColorType = SYColorTypeMain1;
    if (commentData.userTypeId.integerValue == 4) {
        self.userCheckIconImageView.hidden = NO;
    } else {
        self.userCheckIconImageView.hidden = YES;
    }
    
    if (![commentData.userType.lowercaseString isEqualToString:@"visitor"]) {
        self.userRoleLabel.text = commentData.userType.uppercaseString;
    } else {
        self.userRoleLabel.text = @"";
    }
    [self.replyButton setTitle:LOC(@"reply_text_key") forState:UIControlStateNormal];
    if (self.replyInfoLabel && commentData.isReply) {
        self.replyInfoLabel.text = commentData.replyInfo;
    }
    
    if (commentData.isMine) {
        self.shadowedContentView.backgroundColorType = SYColorTypeMain3;
        self.shadowedContentView.backgroundColorAlpha = 1;
    } else {
        self.shadowedContentView.backgroundColorType = SYColorTypeWhite;
        self.shadowedContentView.backgroundColorAlpha = 1;
    }
    
    if (self.commentData.level.integerValue > 1) {
        self.replyInfoView.hidden = NO;
        self.replyInfoHeightConstraint.constant = 30;
        self.replyInfoLabel.text = _commentData.replyInfo;
    } else {
        self.replyInfoView.hidden = YES;
        self.replyInfoHeightConstraint.constant = 0;
    }
}

- (IBAction)replyButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectReply:)]) {
        [self.delegate commentCellDidSelectReply:self];
    }
}
@end
