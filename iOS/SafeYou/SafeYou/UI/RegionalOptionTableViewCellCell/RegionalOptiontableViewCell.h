//
//  RegionalOptiontableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseRegionalOptionViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface RegionalOptiontableViewCell : UITableViewCell

- (void)configureWithViewData:(ChooseRegionalOptionViewModel *)viewData;

@property (nonatomic, readonly) ChooseRegionalOptionViewModel *viewData;

@end

NS_ASSUME_NONNULL_END
