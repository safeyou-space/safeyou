//
//  MoreViewTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/3/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "MoreViewTableViewCell.h"
#import "SettingsViewFieldViewModel.h"
#import "SYSwitchControl.h"
#import <SDWebImage.h>

@interface MoreViewTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableImageView *iconImageView;
@property (weak, nonatomic) IBOutlet SYLabelLight *secondaryLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *mainLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet SYSwitchControl *switchControll;

- (IBAction)switchControlAction:(UISwitch *)sender;

@end

@implementation MoreViewTableViewCell

@synthesize viewData = _viewData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _switchControll.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.switchControll setOn:YES animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure Cell

- (void)configureWithViewData:(SettingsViewFieldViewModel *)viewData
{
    self.iconImageView.image = nil;
    _viewData = viewData;
    if (_viewData.isIconImageFromURL) {
        NSURL *iconImageURL = [NSURL URLWithString:_viewData.iconImageUrl];
        [self.iconImageView sd_setImageWithURL:iconImageURL];
    } else {
        if (_viewData.iconImageName.length) {
            self.iconImageView.hidden = NO;
            [self.iconImageView setImage:[[UIImage imageNamed:_viewData.iconImageName] imageWithTintColor:UIColor.mainTintColor1]];
        } else {
            self.iconImageView.hidden = YES;
        }
    }
    self.mainLabel.text = _viewData.mainTitle;
    self.mainLabel.accessibilityLabel = _viewData.mainTitle;
    
    
    self.secondaryLabel.hidden = YES;
    if (_viewData.accessoryType == FieldAccessoryTypeSwitch) {
        self.switchControll.on = _viewData.isStateOn;
    } else if (_viewData.accessoryType == FieldAccessoryTypeUnknown) {
        self.arrowImageView.hidden = YES;
    } else {
        self.arrowImageView.hidden = NO;
    }
    
    if (_viewData.secondaryTitle.length > 0) {
        NSLog(@"%@", _viewData.secondaryTitle);
        self.secondaryLabel.hidden = NO;
        self.secondaryLabel.text = _viewData.secondaryTitle;
        self.iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.iconImageView.layer.cornerRadius = 0;
        self.secondaryLabel.accessibilityLabel = _viewData.secondaryTitle;
    }
}

- (IBAction)switchControlAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(swithActionCell:didChangeState:)]) {
        [self.delegate swithActionCell:self didChangeState:sender.on];
    }
}
@end
