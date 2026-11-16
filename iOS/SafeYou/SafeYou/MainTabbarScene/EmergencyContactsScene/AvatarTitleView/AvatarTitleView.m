//
//  AvatarTitleView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "AvatarTitleView.h"
#import <SDWebImage/SDWebImage.h>

@interface AvatarTitleView()

@property (weak, nonatomic) IBOutlet SYLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *avatarImageView;

@end

@implementation AvatarTitleView

+ (instancetype)createAvatarTitleView
{
    
    AvatarTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"AvatarTitleView" owner:self options:nil] objectAtIndex:0];
    return  view;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    self.avatarImageView.image = image;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
    [self.avatarImageView sd_setImageWithURL:imageUrl];
}


- (IBAction)navTitleButtonPressed:(id)sender
{
    [self.delegate navTitleButtonPressed];
}

#pragma mark - Layout Subviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarImageView.cornerRadius = self.avatarImageView.frame.size.width/2;
}


@end
