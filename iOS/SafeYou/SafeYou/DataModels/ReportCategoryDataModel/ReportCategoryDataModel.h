//
//  ReportCategoryDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/24/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportCategoryDataModel : BaseDataModel

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *name;

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
