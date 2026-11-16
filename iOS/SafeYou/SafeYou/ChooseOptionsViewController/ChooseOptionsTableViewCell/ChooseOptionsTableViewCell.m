//
//  ChooseOptionsTableViewCell.m
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 1/25/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "ChooseOptionsTableViewCell.h"
//#import "ModuleSettings.h"

@implementation ChooseOptionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _labelTextColorType = -1;
        _selectedLabelTextColorType = -1;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setChooseOptionType:(SYChooseOptionType)chooseOptionType
{
    _chooseOptionType = chooseOptionType;
    if (chooseOptionType == SYChooseOptionTypeRadio) {
        self.checkDeactiveImageView.hidden = NO;
    } else {
        self.checkDeactiveImageView.hidden = YES;
    }
}

- (void)configureForOptionName:(NSString *)optionName
{
    _optionNameLabel.text = optionName;
    [self setIsSelect:self.isSelect];
    [self setIsMultiSelect:self.isMultiSelect];
}

- (void)setIsSelect:(BOOL)isSelect
{
    [super setIsSelect:isSelect];
    if (self.chooseOptionType == SYChooseOptionTypeRadio) {
        self.checkDeactiveImageView.hidden = NO;
    } else {
        self.checkDeactiveImageView.hidden = YES;
    }
}

- (void)setIsMultiSelect:(BOOL)isMultiSelect
{
    [super setIsMultiSelect:isMultiSelect];
    if (self.chooseOptionType == SYChooseOptionTypeRadio) {
        self.checkDeactiveImageView.hidden = NO;
    } else {
        self.checkDeactiveImageView.hidden = YES;
    }
    
}

@end
