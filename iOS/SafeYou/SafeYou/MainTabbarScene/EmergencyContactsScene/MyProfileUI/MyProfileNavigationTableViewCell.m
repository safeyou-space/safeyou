//
//  MyProfileNavigationTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MyProfileNavigationTableViewCell.h"
#import "MyProfileSectionViewModel.h"

@implementation MyProfileNavigationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (IBAction)clearButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidSelectClearButton:)]) {
        [self.delegate cellDidSelectClearButton:self];
    }
}

#pragma mark - MyProfileCellInterface

- (void)configureCellWithTitle:(NSString *)title
{
    [super configureCellWithTitle:title];
}

- (void)configureCellWithViewModelData:(MyProfileRowViewModel *)viewData
{
    self.clearButton.hidden = !viewData.showClearButton;
    self.arrowImageView.hidden = viewData.showClearButton;
    [self configureCellWithTitle:viewData.fieldTitle];
    if (viewData.iconImageName.length) {
        self.iconImageView.hidden = NO;
        UIImage *iconImage = [UIImage imageNamed:viewData.iconImageName];
        self.iconImageView.image = iconImage;
    } else {
        self.iconImageView.hidden = YES;
    }
}



@end
