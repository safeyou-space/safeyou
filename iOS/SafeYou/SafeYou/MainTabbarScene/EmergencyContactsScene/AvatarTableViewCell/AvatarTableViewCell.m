//
//  AvatarTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/6/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "AvatarTableViewCell.h"
#import "ProfileViewFieldViewModel.h"
#import <MBProgressHUD.h>
#import <SDWebImage.h>

@interface AvatarTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cameraButton;
@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *profilePictureLabel;
- (IBAction)camerButtonAction:(SYDesignableButton *)sender;

@end

@implementation AvatarTableViewCell

@synthesize delegate = _delegate;
@synthesize fieldData = _fieldData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (ProfileViewFieldViewModel *)fieldData
{
    return (ProfileViewFieldViewModel *)_fieldData;
}

- (void)configureCellWithViewModelData:(ProfileViewFieldViewModel *)avatartField
{
    _fieldData = avatartField;
    [self showUserAvatar:avatartField.fieldValue];
    self.profilePictureLabel.text = LOC(avatartField.fieldTitle);
}

- (void)updatePhotoWithLocalmage:(UIImage *)localImage
{
    if (localImage) {
        self.avatarImageView.image = localImage;
    } else {
        self.avatarImageView.image = [UIImage new];
        [self showUserAvatar:self.fieldData.fieldValue];
    }
}

- (void)showUserAvatar:(NSString *)avatarUrl
{
    NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", BASE_RESOURCE_URL, avatarUrl];
    NSURL *imageURL = [NSURL URLWithString:imageUrlString];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.avatarImageView animated:YES];
    hud.backgroundColor = [UIColor clearColor];
    [self.avatarImageView sd_setImageWithURL:imageURL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [hud hideAnimated:YES];
    }];
}

- (IBAction)camerButtonAction:(SYDesignableButton *)sender {
    if ([self.delegate respondsToSelector:@selector(actionCellDidPressEditButton:)]) {
        [self.delegate actionCellDidPressEditButton:self];
    }
}
@end
