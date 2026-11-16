//
//  ServiceCategoryDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/8/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceCategoryDataModel : BaseDataModel

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *categoryName;

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)categoryName;

@end

NS_ASSUME_NONNULL_END
