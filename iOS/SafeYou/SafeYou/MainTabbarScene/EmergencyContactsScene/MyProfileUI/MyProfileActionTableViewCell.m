//
//  MyProfileActionTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MyProfileActionTableViewCell.h"
#import "MyProfileSectionViewModel.h"

@implementation MyProfileActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - MyProfileCellInterface

- (void)configureCellWithTitle:(NSString *)title
{
    [super configureCellWithTitle:title];
}

- (void)configureCellWithViewModelData:(MyProfileRowViewModel *)viewData
{
    self.myProfileTitleLabel.text = viewData.fieldTitle;
}

@end
