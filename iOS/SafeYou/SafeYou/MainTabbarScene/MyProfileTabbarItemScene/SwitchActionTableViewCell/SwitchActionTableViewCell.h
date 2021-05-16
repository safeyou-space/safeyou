//
//  MyProfileSwitchTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MyProfileTableViewCell.h"
@class ProfileViewFieldViewModel;

@class SwitchActionTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol SwitchActionTableViewCellDelegate <NSObject>

- (void)swithActionCell:(SwitchActionTableViewCell *_Nonnull)cell didChangeState:(BOOL)isOn;

@end

@interface SwitchActionTableViewCell : MyProfileTableViewCell

@property (nonatomic) id fieldData;

@end

NS_ASSUME_NONNULL_END
