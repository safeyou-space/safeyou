//
//  ReviewDataModel.m
//  SafeYou
//
//  Created by Edgar on 14.02.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "ReviewDataModel.h"

NSString *const kUserRateRate = @"rate";
NSString *const kComment = @"comment";

@implementation ReviewDataModel

@synthesize rate = _rate;
@synthesize comment = _comment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.rate = [[self objectOrNilForKey:kUserRateRate fromDictionary:dict] integerValue];
        self.comment = [self objectOrNilForKey:kComment fromDictionary:dict];
    }

    return self;
}


@end
