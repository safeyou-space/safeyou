//
//  BaseCategoryDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/2/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCategoryDataModel : BaseDataModel

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *categoryName;

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)categoryName;

+ (NSArray <id> *)catgoriesFromDictionary:(NSDictionary *)categoriesDict;

@end

NS_ASSUME_NONNULL_END
