//
//  AppIconTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 12/11/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "AppIconTableViewCell.h"
#import "SYRadioButton.h"
#import "ChooseIconCellViewModel.h"

@interface AppIconTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet SYRadioButton *radioButton;

@end

@implementation AppIconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected || self.viewData.isSelected) {
        self.titleLabel.textColorType = SYColorTypeMain1;
        [self.radioButton setImage:[UIImage imageNamed:@"radio_button_pink_selected"] forState:UIControlStateNormal];
    } else {
        self.titleLabel.textColorType = SYColorTypeBlack;
        [self.radioButton setImage:[UIImage imageNamed:@"radion_button_pink_empty"] forState:UIControlStateNormal];
    }
}

- (void)configureWithViewData:(ChooseIconCellViewModel *)viewData
{
    _viewData = viewData;
    
    [self setSelected:_viewData.isSelected];
    self.iconImageView.image = [UIImage imageNamed:viewData.iconImageName];
    self.titleLabel.text = viewData.optionTitle;
}

@end
