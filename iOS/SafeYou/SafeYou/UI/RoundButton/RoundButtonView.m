//
//  RoundButtonView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RoundButtonView.h"
#import "SYDesignableView.h"
#import "UIColor+SyColors.h"

@interface RoundButtonView ()

{
    SYDesignableView * _contentView;
}

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageViewWithTitle;


@end

@implementation RoundButtonView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.title.length == 0) {
        _contentView = [self viewFromNibWithoutTitle];
    } else {
        _contentView = [self viewFromNibWithTitle];
    }
    _contentView.frame = self.bounds;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    [self.iconImageView setImage:self.image];
    [self.iconImageViewWithTitle setImage:self.image];
    [self.titleLabel setText:self.title];
    
    [self configureShadowOnView:_contentView];
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.iconImageView setImage:self.image];
    [self.iconImageViewWithTitle setImage:self.image];
}

- (void)configureShadowOnView:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(.0f,0.25f);
    view.layer.shadowRadius = _contentView.cornerRadius/2;
    view.layer.shadowOpacity = .7f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
}

#pragma mark - LayoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.cornerRadius = self.frame.size.height/2;
    [self.titleLabel sizeToFit];
    
}

#pragma mark - Action

- (IBAction)roundButtonAction:(id)sender {
    if ([self.roundButtonAction respondsToSelector:@selector(roundButtonPressed:)]) {
        [self.roundButtonAction roundButtonPressed:self];
    }
}


#pragma mark - Helper

- (SYDesignableView *)viewFromNibWithTitle
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"RoundButton" owner:self options:nil];
    return (SYDesignableView *)nibViews.firstObject;
}

- (SYDesignableView *)viewFromNibWithoutTitle
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"RoundButton" owner:self options:nil];
    return (SYDesignableView *)nibViews.lastObject;
}

@end
