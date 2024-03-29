//
//  NotificationTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NotificationData.h"
#import <SDWebImage.h>

@interface NotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *userNameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *userActionLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *userDateLabel;
@property (weak, nonatomic) IBOutlet SYDesignableView *designableContentView;

@end

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.designableContentView.backgroundColorType = 3;
    self.designableContentView.backgroundColorAlpha = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 @property (nonatomic, strong) NSString *forumId;
 @property (nonatomic, strong) NSString *imagePath;
 @property (nonatomic, strong) NSString *notificationId;
 @property (nonatomic, strong) NSString *createdAt;
 @property (nonatomic, strong) NSString *replyId;
 @property (nonatomic, strong) NSString *userType;
 @property (nonatomic, strong) NSString *isReaded;
 @property (nonatomic, strong) NSString *userId;
 @property (nonatomic, strong) NSString *key;
 @property (nonatomic, strong) NSString *name;
 */
- (void)configureNotificationData:(NotificationData *)notificationData
{
    self.notificationData = notificationData;
    NSURL *imageUrl = [NSURL URLWithString:notificationData.notificationMessage.user.userImage];
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    self.userNameLabel.text = self.notificationData.notificationMessage.user.userUsername ? self.notificationData.notificationMessage.user.userUsername :self.notificationData.notificationMessage.user.userNgoName;
    self.userActionLabel.text = LOC(@"replied_to_your_comment");
    self.designableContentView.backgroundColorAlpha = 0;
    self.userDateLabel.text = notificationData.notificationMessage.formattedUpdatedDate;
}

@end
