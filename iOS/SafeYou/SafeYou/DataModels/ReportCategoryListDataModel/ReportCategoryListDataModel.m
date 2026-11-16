//
//  ReportCategoryListDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/24/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "ReportCategoryListDataModel.h"
#import "ReportCategoryDataModel.h"

@implementation ReportCategoryListDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *key in dict.allKeys) {
        ReportCategoryDataModel *category = [[ReportCategoryDataModel alloc] initWithId:key name:dict[key]];
        [array addObject:category];
    }
    self.items = [NSArray arrayWithArray:array];
    
    return self;
}

@end
