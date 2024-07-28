//
//  MyProfileSwitchTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SwitchActionTableViewCell.h"
#import "ProfileViewFieldViewModel.h"
#import "SYUIKit.h"

@interface SwitchActionTableViewCell ()

@property (nonatomic, weak) IBOutlet UISwitch *switchControl;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation SwitchActionTableViewCell

@synthesize fieldData = _fieldData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchControlAction:(SYSwitchControl *)sender {
    if ([self.delegate respondsToSelector:@selector(swithActionCell:didChangeState:)]) {
        [self.delegate swithActionCell:self didChangeState:sender.on];
    }
}

#pragma mark - MyProfileCellInterface

- (void)configureCellWithTitle:(NSString *)title state:(BOOL)isOn
{
    self.titleLabel.text = title;
    self.switchControl.enabled = isOn;
}

- (void)configureCellWithViewModelData:(nonnull ProfileViewFieldViewModel *)viewData {
    self.fieldData = viewData;
    self.switchControl.on = viewData.isStateOn;
    self.titleLabel.text = viewData.fieldTitle;
    if (viewData.iconImageName.length) {
        self.iconImageView.hidden = NO;
        self.iconImageView.image = [[UIImage imageNamed:viewData.iconImageName] imageWithTintColor:UIColor.mainTintColor1];
    } else {
        self.iconImageView.hidden = YES;
    }
}

@end
