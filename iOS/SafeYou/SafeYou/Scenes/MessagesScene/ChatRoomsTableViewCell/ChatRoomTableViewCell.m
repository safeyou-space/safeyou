//
//  ChatRoomTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ChatRoomTableViewCell.h"

#import <SDWebImage.h>
#import "RoomDataModel.h"

@interface ChatRoomTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *nameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *roleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *dateLabel;


@end

@implementation ChatRoomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithData:(RoomDataModel *)roomData
{
    ChatUserDataModel * userData = [roomData getOtherMember];
    [self.avatarImageView sd_setImageWithURL:userData.avatarUrl];
    self.nameLabel.text = userData.userName;
    if (userData.role == ChatUserRoleUser) {
        self.roleLabel.text = @"";
    } else {
        self.roleLabel.text = userData.roleLabel;
    }
    self.dateLabel.text = roomData.formattedUpdatedDate;
}

@end
