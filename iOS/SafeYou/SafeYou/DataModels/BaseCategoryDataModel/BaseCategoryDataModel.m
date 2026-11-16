//
//  BaseCategoryDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/2/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseCategoryDataModel.h"

@implementation BaseCategoryDataModel

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)categoryName
{
    self = [super init];
    if (self) {
        _categoryId = categoryId;
        _categoryName = categoryName;
    }
    
    return self;
}

#pragma mark - Helper

+ (NSArray <id> *)catgoriesFromDictionary:(NSDictionary *)categoriesDict
{
    NSArray *allKeys = [categoriesDict allKeys];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *key in allKeys) {
        BaseCategoryDataModel *categoryData = [[BaseCategoryDataModel alloc] initWithId:key name:categoriesDict[key]];
        [tempArray addObject:categoryData];
    }
    
    return [tempArray copy];
}

@end
