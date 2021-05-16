//
//  MoreViewTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/3/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingsViewFieldViewModel, MoreViewTableViewCell;

@protocol MoreViewTableViewCellDelegate <NSObject>

- (void)swithActionCell:(MoreViewTableViewCell *_Nonnull)cell didChangeState:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MoreViewTableViewCell : UITableViewCell

- (void)configureWithViewData:(SettingsViewFieldViewModel *)viewData;

@property (nonatomic, readonly) SettingsViewFieldViewModel *viewData;
@property (nonatomic, weak) id <MoreViewTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
