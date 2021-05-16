//
//  MaritalStatusDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MaritalStatusDataModel.h"

NSString *const kMaritalStatusType = @"type";
NSString *const kMaritalStatusLabel = @"label";

@interface MaritalStatusDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MaritalStatusDataModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        float typeValue = [[self objectOrNilForKey:kMaritalStatusType fromDictionary:dict] floatValue];
        self.maritalStatusType = [NSNumber numberWithFloat:typeValue];
        self.localizedName = [self objectOrNilForKey:kMaritalStatusLabel fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    [mutableDict setValue:self.maritalStatusType forKey:kMaritalStatusType];
    [mutableDict setValue:self.localizedName forKey:kMaritalStatusLabel];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
