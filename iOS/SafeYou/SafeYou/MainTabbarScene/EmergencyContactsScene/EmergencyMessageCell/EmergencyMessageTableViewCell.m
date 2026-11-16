//
//  EmergencyMessageTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/15/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "EmergencyMessageTableViewCell.h"
#import "MyProfileSectionViewModel.h"

@interface EmergencyMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet SYLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *valueLabel;

@end

@implementation EmergencyMessageTableViewCell

@synthesize fieldData = _fieldData;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithViewModelData:(MyProfileRowViewModel *)viewData
{
    self.fieldData = viewData;
    self.iconImageView.image = [UIImage imageNamed:viewData.iconImageName];
    self.titleLabel.text = viewData.fieldTitle;
    self.valueLabel.text = viewData.fieldValue;
}

@end
