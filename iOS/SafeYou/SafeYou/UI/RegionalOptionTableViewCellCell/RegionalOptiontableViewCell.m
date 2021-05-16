//
//  RegionalOptiontableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "RegionalOptiontableViewCell.h"
#import "SYRadioButton.h"
#import "ChooseRegionalOptionViewModel.h"
#import <SDWebImage.h>
//#import "UIImageView+AFNetworking.h"

@interface RegionalOptiontableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet SYRadioButton *radioButton;

@end

@implementation RegionalOptiontableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected || self.viewData.isSelected) {
        self.titleLabel.textColorType = SYColorTypeMain1;
        [self.radioButton setImage:[UIImage imageNamed:@"radio_button_purple_selected"] forState:UIControlStateNormal];
    } else {
        self.titleLabel.textColorType = SYColorTypeBlack;
        [self.radioButton setImage:[UIImage imageNamed:@"radion_button_purple_empty"] forState:UIControlStateNormal];
    }
}


- (void)configureWithViewData:(ChooseRegionalOptionViewModel *)viewData
{
    _viewData = viewData;
    
//    self.selected = _viewData.isSelected;
    [self setSelected:_viewData.isSelected];
    
    BOOL imageAvailable = viewData.optionImageUrl;
    self.iconImageView.hidden = !imageAvailable;
    if (imageAvailable) {
        [self.iconImageView sd_setImageWithURL:viewData.optionImageUrl];
    }
    
    self.titleLabel.text = viewData.optionTitle;
}

@end
