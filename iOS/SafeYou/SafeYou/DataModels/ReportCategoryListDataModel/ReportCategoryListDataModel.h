//
//  ReportCategoryListDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/24/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class ReportCategoryDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ReportCategoryListDataModel : BaseDataModel

@property (nonatomic, strong) NSArray <ReportCategoryDataModel *>*items;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
