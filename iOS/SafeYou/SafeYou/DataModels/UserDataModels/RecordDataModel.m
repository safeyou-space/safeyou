//
//  RecordDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordDataModel.h"


NSString *const kRecordsId = @"id";
NSString *const kRecordsIsSent = @"is_sent";
NSString *const kRecordsCreatedAt = @"created_at";
NSString *const kRecordsLongitude = @"longitude";
NSString *const kRecordsTime = @"time";
NSString *const kRecordsLatitude = @"latitude";
NSString *const kRecordsUserId = @"user_id";
NSString *const kRecordsSize = @"size";
NSString *const kRecordsPath = @"path";
NSString *const kRecordsDate = @"date";
NSString *const kRecordsUpdatedAt = @"updated_at";
NSString *const kRecordsDuration = @"duration";
NSString *const kRecordsName = @"name";


@interface RecordDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RecordDataModel

@synthesize recordId = _recordId;
@synthesize isSent = _isSent;
@synthesize createdAt = _createdAt;
@synthesize longitude = _longitude;
@synthesize time = _time;
@synthesize latitude = _latitude;
@synthesize userId = _userId;
@synthesize size = _size;
@synthesize path = _path;
@synthesize date = _date;
@synthesize updatedAt = _updatedAt;
@synthesize duration = _duration;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.recordId = [self objectOrNilForKey:kRecordsId fromDictionary:dict];
            self.isSent = [[self objectOrNilForKey:kRecordsIsSent fromDictionary:dict] boolValue];
            self.createdAt = [self objectOrNilForKey:kRecordsCreatedAt fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kRecordsLongitude fromDictionary:dict];
            self.time = [self objectOrNilForKey:kRecordsTime fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kRecordsLatitude fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kRecordsUserId fromDictionary:dict];
            self.size = [self objectOrNilForKey:kRecordsSize fromDictionary:dict];
            self.path = [self objectOrNilForKey:kRecordsPath fromDictionary:dict];
            self.date = [self objectOrNilForKey:kRecordsDate fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kRecordsUpdatedAt fromDictionary:dict];
            self.duration = [self objectOrNilForKey:kRecordsDuration fromDictionary:dict];
            self.name = [self objectOrNilForKey:kRecordsName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.recordId forKey:kRecordsId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isSent] forKey:kRecordsIsSent];
    [mutableDict setValue:self.createdAt forKey:kRecordsCreatedAt];
    [mutableDict setValue:self.longitude forKey:kRecordsLongitude];
    [mutableDict setValue:self.time forKey:kRecordsTime];
    [mutableDict setValue:self.latitude forKey:kRecordsLatitude];
    [mutableDict setValue:self.userId forKey:kRecordsUserId];
    [mutableDict setValue:self.size forKey:kRecordsSize];
    [mutableDict setValue:self.path forKey:kRecordsPath];
    [mutableDict setValue:self.date forKey:kRecordsDate];
    [mutableDict setValue:self.updatedAt forKey:kRecordsUpdatedAt];
    [mutableDict setValue:self.duration forKey:kRecordsDuration];
    [mutableDict setValue:self.name forKey:kRecordsName];

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

    self.recordId = [aDecoder decodeObjectForKey:kRecordsId];
    self.isSent = [aDecoder decodeBoolForKey:kRecordsIsSent];
    self.createdAt = [aDecoder decodeObjectForKey:kRecordsCreatedAt];
    self.longitude = [aDecoder decodeObjectForKey:kRecordsLongitude];
    self.time = [aDecoder decodeObjectForKey:kRecordsTime];
    self.latitude = [aDecoder decodeObjectForKey:kRecordsLatitude];
    self.userId = [aDecoder decodeObjectForKey:kRecordsUserId];
    self.size = [aDecoder decodeObjectForKey:kRecordsSize];
    self.path = [aDecoder decodeObjectForKey:kRecordsPath];
    self.date = [aDecoder decodeObjectForKey:kRecordsDate];
    self.updatedAt = [aDecoder decodeObjectForKey:kRecordsUpdatedAt];
    self.duration = [aDecoder decodeObjectForKey:kRecordsDuration];
    self.name = [aDecoder decodeObjectForKey:kRecordsName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_recordId forKey:kRecordsId];
    [aCoder encodeBool:_isSent forKey:kRecordsIsSent];
    [aCoder encodeObject:_createdAt forKey:kRecordsCreatedAt];
    [aCoder encodeObject:_longitude forKey:kRecordsLongitude];
    [aCoder encodeObject:_time forKey:kRecordsTime];
    [aCoder encodeObject:_latitude forKey:kRecordsLatitude];
    [aCoder encodeObject:_userId forKey:kRecordsUserId];
    [aCoder encodeObject:_size forKey:kRecordsSize];
    [aCoder encodeObject:_path forKey:kRecordsPath];
    [aCoder encodeObject:_date forKey:kRecordsDate];
    [aCoder encodeObject:_updatedAt forKey:kRecordsUpdatedAt];
    [aCoder encodeObject:_duration forKey:kRecordsDuration];
    [aCoder encodeObject:_name forKey:kRecordsName];
}

- (id)copyWithZone:(NSZone *)zone {
    RecordDataModel *copy = [[RecordDataModel alloc] init];
    
    
    
    if (copy) {

        copy.recordId = self.recordId;
        copy.isSent = self.isSent;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.userId = self.userId;
        copy.size = [self.size copyWithZone:zone];
        copy.path = [self.path copyWithZone:zone];
        copy.date = [self.date copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.duration = [self.duration copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
