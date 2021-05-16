//
//  RecordSearchResult.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordSearchResult.h"

NSString *const kRecordResutlSeriveId = @"id";
NSString *const kRecordResutlSeriveName = @"location_with_date_time";

@interface RecordSearchResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end


@implementation RecordSearchResult

/**
 {
 id = 8;
 name = "MARK Varazdat last name";
 type = ngo;
 }
 */

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.serviceId = [self objectOrNilForKey:kRecordResutlSeriveId fromDictionary:dict];
        self.name = [self objectOrNilForKey:kRecordResutlSeriveName fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    [mutableDict setValue:self.serviceId forKey:kRecordResutlSeriveId];
    [mutableDict setValue:self.name forKey:kRecordResutlSeriveName];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
