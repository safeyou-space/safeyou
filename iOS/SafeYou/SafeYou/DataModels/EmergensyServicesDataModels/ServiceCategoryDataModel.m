//
//  ServiceCategoryDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/8/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ServiceCategoryDataModel.h"

@implementation ServiceCategoryDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSArray *keys = [dict allKeys];
        _categoryId = keys.firstObject;
        _categoryName = dict[_categoryId];
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)categoryName
{
    self = [super init];
    if (self) {
        _categoryId = categoryId;
        _categoryName = categoryName;
    }
    
    return self;
}

@end
