//
//  ReportCategoryTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/24/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportCategoryDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ReportCategoryTableViewCell : UITableViewCell

- (void)configureWithViewData:(ReportCategoryDataModel *)viewData;

@end

NS_ASSUME_NONNULL_END
