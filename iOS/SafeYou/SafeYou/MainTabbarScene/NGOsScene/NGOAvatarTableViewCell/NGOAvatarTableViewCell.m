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
@property (weak, nonatomic) IBOutlet SYLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableButton *chatButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *reviewButton;

- (IBAction)chatButtonAction:(SYDesignableButton *)sender;

@end

@implementation NGOAvatarTableViewCell

- (void)configureCell:(NGOAvatarCellViewModel *)viewModel hideChatButton:(BOOL)hideChatButton
{
    [self showUserAvatar:viewModel.logoURL];
    self.titleLabel.text = viewModel.title;
    self.chatButton.hidden = hideChatButton;
    [self.reviewButton setTintColor:[UIColor mainTintColor1]];
    if (viewModel.rating > 0) {
        [self.reviewButton setImage:[UIImage systemImageNamed:@"star.fill"] forState:UIControlStateNormal];
        [self.reviewButton setTitle:[NSString stringWithFormat: @" %@/5", @(viewModel.rating)] forState:UIControlStateNormal];
    } else {
        [self.reviewButton setTitle:@"" forState:UIControlStateNormal];
    }
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

- (IBAction)reviewButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ngoAvatarCellDidPressReviewButton)]) {
        [self.delegate ngoAvatarCellDidPressReviewButton];
    }
}

@end
