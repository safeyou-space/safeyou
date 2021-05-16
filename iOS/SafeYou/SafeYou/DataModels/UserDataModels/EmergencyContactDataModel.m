//
//  EmergencyContactDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "EmergencyContactDataModel.h"

NSString *const kEmergencyContactsId = @"id";
NSString *const kEmergencyContactsPhone = @"phone";
NSString *const kEmergencyContactsUserId = @"user_id";
NSString *const kEmergencyContactsName = @"name";
NSString *const kEmergencyContactsUpdatedAt = @"updated_at";
NSString *const kEmergencyContactsCreatedAt = @"created_at";


@interface EmergencyContactDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EmergencyContactDataModel

@synthesize emergencyContactId = _emergencyContactId;
@synthesize phone = _phone;
@synthesize userId = _userId;
@synthesize name = _name;
@synthesize updatedAt = _updatedAt;
@synthesize createdAt = _createdAt;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.emergencyContactId = [self objectOrNilForKey:kEmergencyContactsId fromDictionary:dict] ;
            self.phone = [self objectOrNilForKey:kEmergencyContactsPhone fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kEmergencyContactsUserId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kEmergencyContactsName fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kEmergencyContactsUpdatedAt fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kEmergencyContactsCreatedAt fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.emergencyContactId forKey:kEmergencyContactsId];
    [mutableDict setValue:self.phone forKey:kEmergencyContactsPhone];
    [mutableDict setValue:self.userId forKey:kEmergencyContactsUserId];
    [mutableDict setValue:self.name forKey:kEmergencyContactsName];
    [mutableDict setValue:self.updatedAt forKey:kEmergencyContactsUpdatedAt];
    [mutableDict setValue:self.createdAt forKey:kEmergencyContactsCreatedAt];

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

    self.emergencyContactId = [aDecoder decodeObjectForKey:kEmergencyContactsId];
    self.phone = [aDecoder decodeObjectForKey:kEmergencyContactsPhone];
    self.userId = [aDecoder decodeObjectForKey:kEmergencyContactsUserId];
    self.name = [aDecoder decodeObjectForKey:kEmergencyContactsName];
    self.updatedAt = [aDecoder decodeObjectForKey:kEmergencyContactsUpdatedAt];
    self.createdAt = [aDecoder decodeObjectForKey:kEmergencyContactsCreatedAt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_emergencyContactId forKey:kEmergencyContactsId];
    [aCoder encodeObject:_phone forKey:kEmergencyContactsPhone];
    [aCoder encodeObject:_userId forKey:kEmergencyContactsUserId];
    [aCoder encodeObject:_name forKey:kEmergencyContactsName];
    [aCoder encodeObject:_updatedAt forKey:kEmergencyContactsUpdatedAt];
    [aCoder encodeObject:_createdAt forKey:kEmergencyContactsCreatedAt];
}

- (id)copyWithZone:(NSZone *)zone {
    EmergencyContactDataModel *copy = [[EmergencyContactDataModel alloc] init];
    
    
    
    if (copy) {

        copy.emergencyContactId = self.emergencyContactId;
        copy.phone = [self.phone copyWithZone:zone];
        copy.userId = self.userId;
        copy.name = [self.name copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
    }
    
    return copy;
}


@end
