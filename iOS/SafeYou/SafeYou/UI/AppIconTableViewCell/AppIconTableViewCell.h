//
//  AppIconTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 12/11/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseIconCellViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface AppIconTableViewCell : UITableViewCell

@property (nonatomic, readonly) ChooseIconCellViewModel *viewData;

- (void)configureWithViewData:(ChooseIconCellViewModel *)viewData;

@end

NS_ASSUME_NONNULL_END
