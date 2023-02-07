//
//  AvatarTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/6/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "NGOAvatarTableViewCell.h"
#import "NGOAvatarCellViewModel.h"
#import <MBProgressHUD.h>
#import <SDWebImage.h>

@interface NGOAvatarTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableImageView *logoImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableButton *chatButton;

- (IBAction)chatButtonAction:(SYDesignableButton *)sender;

@end

@implementation NGOAvatarTableViewCell

- (void)configureCell:(NGOAvatarCellViewModel *)viewModel hideChatButton:(BOOL)hideChatButton
{
    [self showUserAvatar:viewModel.logoURL];
    self.titleLabel.text = viewModel.title;
    self.chatButton.hidden = hideChatButton;
}

- (void)showUserAvatar:(NSURL *)url
{
 
    [self.logoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ngo_logo"]];
}

- (IBAction)chatButtonAction:(SYDesignableButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ngoAvatarCellDidPressPrivateChat)]) {
        [self.delegate ngoAvatarCellDidPressPrivateChat];
    }
}
@end
