//
//  ConsultantExpertiseFieldDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ConsultantExpertiseFieldDataModel.h"

@implementation ConsultantExpertiseFieldDataModel

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
