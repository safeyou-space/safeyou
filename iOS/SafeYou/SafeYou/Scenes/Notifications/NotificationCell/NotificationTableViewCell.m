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
@property (weak, nonatomic) IBOutlet SYLabelRegular *userNameLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *userActionLabel;
@property (weak, nonatomic) IBOutlet SYLabelLight *userDateLabel;
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
    self.designableContentView.backgroundColorAlpha = 0;
    
    if (notificationData.notifyRead == 0) {
        [self.userNameLabel setFont:[UIFont fontWithName:@"HayRoboto-Bold" size:self.userNameLabel.font.pointSize]];
    }

    if (notificationData.notifyType == NotificationTypeNewForum) {
        [self configureNewForum:notificationData];
    } else if (notificationData.notifyType == NotificationTypeDashboardMessage) {
        [self configureDashboardMessage:notificationData];
    } else {
        [self configureNewMessage:notificationData];
    }
}

- (void)configureNewMessage:(NotificationData *)notificationData
{
    NSURL *imageUrl = [NSURL URLWithString:notificationData.notificationMessage.user.userImage];
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    self.userNameLabel.text = notificationData.notificationMessage.user.userUsername ? notificationData.notificationMessage.user.userUsername : notificationData.notificationMessage.user.userNgoName;
    self.userActionLabel.text = LOC(@"replied_to_your_comment");
    self.userDateLabel.text = notificationData.notificationMessage.formattedUpdatedDate;
}

- (void)configureNewForum:(NotificationData *)notificationData
{
    NSURL *imageUrl = [NSURL URLWithString:notificationData.forumData.imageUrl];
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    self.userNameLabel.text = notificationData.forumData.title;
    self.userActionLabel.text = LOC(@"forum_was_created");
    self.userDateLabel.text = notificationData.forumData.formattedCreatedDate;
}

- (void)configureDashboardMessage:(NotificationData *)notificationData
{
    self.userNameLabel.text = notificationData.notifyTitle;
    self.userActionLabel.text = notificationData.notificationDashboardMessage.message;
    self.userDateLabel.text = notificationData.formattedCreatedDate;
}

@end
