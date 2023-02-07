//
//  ReportCategoriesViewController.h
//  SafeYou
//
//  Created by Edgar on 23.07.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class ReportCategoryDataModel;

NS_ASSUME_NONNULL_BEGIN

@protocol ReportCategoriesViewControllerDelegate <NSObject>

- (void)reportCategory:(ReportCategoryDataModel *)categoryDataModel;

@end

@interface ReportCategoriesViewController : SYViewController

@property (weak, nonatomic) id<ReportCategoriesViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
