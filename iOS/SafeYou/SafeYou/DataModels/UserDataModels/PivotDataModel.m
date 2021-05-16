//
//  PivotDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "PivotDataModel.h"


NSString *const kPivotUserId = @"user_id";
NSString *const kPivotNgoId = @"ngo_id";


@interface PivotDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PivotDataModel

@synthesize userId = _userId;
@synthesize ngoId = _ngoId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userId = [self objectOrNilForKey:kPivotUserId fromDictionary:dict];
            self.ngoId = [self objectOrNilForKey:kPivotNgoId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userId forKey:kPivotUserId];
    [mutableDict setValue:self.ngoId forKey:kPivotNgoId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.userId = [aDecoder decodeObjectForKey:kPivotUserId];
    self.ngoId = [aDecoder decodeObjectForKey:kPivotNgoId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userId forKey:kPivotUserId];
    [aCoder encodeObject:_ngoId forKey:kPivotNgoId];
}

- (id)copyWithZone:(NSZone *)zone {
    PivotDataModel *copy = [[PivotDataModel alloc] init];
    
    
    
    if (copy) {

        copy.userId = self.userId;
        copy.ngoId = self.ngoId;
    }
    
    return copy;
}


@end
