//
//  ChooseOptionsTableViewCell.h
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 1/25/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "BaseTableViewCellWithCheckMark.h"

IB_DESIGNABLE

@interface ChooseOptionsTableViewCell : BaseTableViewCellWithCheckMark

@property (weak, nonatomic) IBOutlet SYLabelRegular *optionNameLabel;
@property (nonatomic) SYChooseOptionType chooseOptionType;
@property (nonatomic) IBInspectable NSInteger labelTextColorType;
@property (nonatomic) IBInspectable NSInteger selectedLabelTextColorType;

- (void)configureForOptionName:(NSString*)optionName;

@end
