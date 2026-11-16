//
//  NGODetailsContactCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/9/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGOContactViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface NGODetailsContactCell : UITableViewCell

- (void)configureWithViewModel:(NGOContactViewModel *)viewData;

@end

NS_ASSUME_NONNULL_END
