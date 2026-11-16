//
//  RecordListItemDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordListItemDataModel.h"

NSString *const kRecordListItemRecirdId = @"id";
NSString *const kRecordListItemIsSent = @"is_sent";
NSString *const kRecordListItemCreatedAt = @"created_at";
NSString *const kRecordListItemLongitude = @"longitude";
NSString *const kRecordListItemTime = @"time";
NSString *const kRecordListItemLatitude = @"latitude";
NSString *const kRecordListItemUserId = @"user_id";
NSString *const kRecordListItemUrl = @"url";
NSString *const kRecordListItemLocation = @"location";
NSString *const kRecordListItemDate = @"date";
NSString *const kRecordListItemUpdatedAt = @"updated_at";
NSString *const kRecordListItemDuration = @"duration";
NSString *const kRecordListItemName = @"name";

@interface RecordListItemDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RecordListItemDataModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.recordId = [self objectOrNilForKey:kRecordListItemRecirdId fromDictionary:dict];
            self.isSent = [[self objectOrNilForKey:kRecordListItemIsSent fromDictionary:dict] boolValue];
            self.createdAt = [self objectOrNilForKey:kRecordListItemCreatedAt fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kRecordListItemLongitude fromDictionary:dict];
            self.time = [self objectOrNilForKey:kRecordListItemTime fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kRecordListItemLatitude fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kRecordListItemUserId fromDictionary:dict];
            self.url = [self objectOrNilForKey:kRecordListItemUrl fromDictionary:dict];
            self.location = [self objectOrNilForKey:kRecordListItemLocation fromDictionary:dict];
            self.date = [self objectOrNilForKey:kRecordListItemDate fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kRecordListItemUpdatedAt fromDictionary:dict];
            self.duration = [[self objectOrNilForKey:kRecordListItemDuration fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kRecordListItemName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.recordId forKey:kRecordListItemRecirdId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isSent] forKey:kRecordListItemIsSent];
    [mutableDict setValue:self.createdAt forKey:kRecordListItemCreatedAt];
    [mutableDict setValue:self.longitude forKey:kRecordListItemLongitude];
    [mutableDict setValue:self.time forKey:kRecordListItemTime];
    [mutableDict setValue:self.latitude forKey:kRecordListItemLatitude];
    [mutableDict setValue:self.userId forKey:kRecordListItemUserId];
    [mutableDict setValue:self.url forKey:kRecordListItemUrl];
    [mutableDict setValue:self.location forKey:kRecordListItemLocation];
    [mutableDict setValue:self.date forKey:kRecordListItemDate];
    [mutableDict setValue:self.updatedAt forKey:kRecordListItemUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.duration] forKey:kRecordListItemDuration];
    [mutableDict setValue:self.name forKey:kRecordListItemName];

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

    self.recordId = [aDecoder decodeObjectForKey:kRecordListItemRecirdId];
    self.isSent = [aDecoder decodeBoolForKey:kRecordListItemIsSent];
    self.createdAt = [aDecoder decodeObjectForKey:kRecordListItemCreatedAt];
    self.longitude = [aDecoder decodeObjectForKey:kRecordListItemLongitude];
    self.time = [aDecoder decodeObjectForKey:kRecordListItemTime];
    self.latitude = [aDecoder decodeObjectForKey:kRecordListItemLatitude];
    self.userId = [aDecoder decodeObjectForKey:kRecordListItemUserId];
    self.url = [aDecoder decodeObjectForKey:kRecordListItemUrl];
    self.location = [aDecoder decodeObjectForKey:kRecordListItemLocation];
    self.date = [aDecoder decodeObjectForKey:kRecordListItemDate];
    self.updatedAt = [aDecoder decodeObjectForKey:kRecordListItemUpdatedAt];
    self.duration = [aDecoder decodeDoubleForKey:kRecordListItemDuration];
    self.name = [aDecoder decodeObjectForKey:kRecordListItemName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_recordId forKey:kRecordListItemRecirdId];
    [aCoder encodeBool:_isSent forKey:kRecordListItemIsSent];
    [aCoder encodeObject:_createdAt forKey:kRecordListItemCreatedAt];
    [aCoder encodeObject:_longitude forKey:kRecordListItemLongitude];
    [aCoder encodeObject:_time forKey:kRecordListItemTime];
    [aCoder encodeObject:_latitude forKey:kRecordListItemLatitude];
    [aCoder encodeObject:_userId forKey:kRecordListItemUserId];
    [aCoder encodeObject:_url forKey:kRecordListItemUrl];
    [aCoder encodeObject:_location forKey:kRecordListItemLocation];
    [aCoder encodeObject:_date forKey:kRecordListItemDate];
    [aCoder encodeObject:_updatedAt forKey:kRecordListItemUpdatedAt];
    [aCoder encodeDouble:_duration forKey:kRecordListItemDuration];
    [aCoder encodeObject:_name forKey:kRecordListItemName];
}

- (id)copyWithZone:(NSZone *)zone {
    RecordListItemDataModel *copy = [[RecordListItemDataModel alloc] init];
    
    
    
    if (copy) {

        copy.recordId = self.recordId;
        copy.isSent = self.isSent;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.userId = self.userId;
        copy.url = [self.url copyWithZone:zone];
        copy.location = [self.location copyWithZone:zone];
        copy.date = [self.date copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.duration = self.duration;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

@end
