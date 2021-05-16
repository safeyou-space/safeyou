//
//  BaseDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@implementation BaseDataModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    return nil;
}

- (NSDictionary *)dictionaryRepresentation
{
    return nil;
}


#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
