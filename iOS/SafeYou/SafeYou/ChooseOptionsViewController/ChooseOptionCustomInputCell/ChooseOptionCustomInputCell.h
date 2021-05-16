//
//  ChooseOptionCustomInputCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/27/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseTableViewCellWithCheckMark.h"

@class ChooseOptionCustomInputCell;

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseOptionCustomInputCellDelegate <NSObject>

- (void)customOptionCell:(ChooseOptionCustomInputCell *)cell didChangeText:(NSString *)text;

@end

@interface ChooseOptionCustomInputCell : BaseTableViewCellWithCheckMark

@property (nonatomic) SYChooseOptionType chooseOptionType;

@property (nonatomic, weak) id <ChooseOptionCustomInputCellDelegate> delegate;

- (void)configureWithTitle:(NSString *)title placeholder:(NSString *)placeholder;
- (NSString *)inputvalue;

@end

NS_ASSUME_NONNULL_END
