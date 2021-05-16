//
//  MyProfileTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MyProfileTableViewCell.h"
#import "MyProfileSectionViewModel.h"

@implementation MyProfileTableViewCell

@synthesize delegate = _delegate;

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
    [self.clearButton setTitle:LOC(@"clear_tex_key") forState:UIControlStateNormal];
    self.myProfileTitleLabel.text = title;
}

- (void)configureCellWithViewModelData:(nonnull MyProfileRowViewModel *)viewData {
    self.myProfileTitleLabel.text = viewData.fieldTitle;
}


@end
