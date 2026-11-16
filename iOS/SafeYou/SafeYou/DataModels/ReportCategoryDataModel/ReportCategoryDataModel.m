//
//  ReportCategoryDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/24/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "ReportCategoryDataModel.h"

@implementation ReportCategoryDataModel

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)name
{
    self = [super init];
    self.categoryId = categoryId;
    self.name = name;
    
    return self;
}

@end
