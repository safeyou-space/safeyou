//
//  UserDetail.m
//
//  Created by   on 10/15/19
//  Copyright (c) 2019 __MyCompanyName__. All rights reserved.
//

#import "UserDetail.h"
#import "ImageDataModel.h"


NSString *const kUserDetailId = @"id";
NSString *const kUserDetailNickname = @"nickname";
NSString *const kUserDetailCheckPolice = @"check_police";
NSString *const kUserDetailPhone = @"phone";
NSString *const kUserDetailImage = @"image";
NSString *const kUserDetailStatus = @"status";
NSString *const kUserDetailCreatedAt = @"created_at";
NSString *const kUserDetailImageId = @"image_id";
NSString *const kUserDetailIsVerifyingOtp = @"is_verifying_otp";
NSString *const kUserDetailLocation = @"location";
NSString *const kUserDetailChangePhone = @"change_phone";
NSString *const kUserDetailBirthday = @"birthday";
NSString *const kUserDetailUpdatedAt = @"updated_at";
NSString *const kUserDetailFirstName = @"first_name";
NSString *const kUserDetailRole = @"role";
NSString *const kUserDetailLastName = @"last_name";
NSString *const kUserDetailIsAdmin = @"is_admin";
NSString *const kUserDetailEmail = @"email";
NSString *const kUserDetailEmergencyMessage = @"emergency_message";


@interface UserDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserDetail

@synthesize userDetailId = _userDetailId;
@synthesize nickname = _nickname;
@synthesize checkPolice = _checkPolice;
@synthesize phone = _phone;
@synthesize image = _image;
@synthesize status = _status;
@synthesize createdAt = _createdAt;
@synthesize imageId = _imageId;
@synthesize isVerifyingOtp = _isVerifyingOtp;
@synthesize location = _location;
@synthesize changePhone = _changePhone;
@synthesize birthday = _birthday;
@synthesize updatedAt = _updatedAt;
@synthesize firstName = _firstName;
@synthesize role = _role;
@synthesize lastName = _lastName;
@synthesize isAdmin = _isAdmin;
@synthesize email = _email;
@synthesize emergencyMessage = _emergencyMessage;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userDetailId = [self objectOrNilForKey:kUserDetailId fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kUserDetailNickname fromDictionary:dict];
            self.checkPolice = [[self objectOrNilForKey:kUserDetailCheckPolice fromDictionary:dict] doubleValue];
            self.phone = [self objectOrNilForKey:kUserDetailPhone fromDictionary:dict];
            self.image = [ImageDataModel modelObjectWithDictionary:[dict objectForKey:kUserDetailImage]];
            self.status = [[self objectOrNilForKey:kUserDetailStatus fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kUserDetailCreatedAt fromDictionary:dict];
            self.imageId = [self objectOrNilForKey:kUserDetailImageId fromDictionary:dict];
            self.isVerifyingOtp = [[self objectOrNilForKey:kUserDetailIsVerifyingOtp fromDictionary:dict] doubleValue];
            self.location = [self objectOrNilForKey:kUserDetailLocation fromDictionary:dict];
            self.changePhone = [self objectOrNilForKey:kUserDetailChangePhone fromDictionary:dict];
            self.birthday = [self objectOrNilForKey:kUserDetailBirthday fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kUserDetailUpdatedAt fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kUserDetailFirstName fromDictionary:dict];
            self.role = [self objectOrNilForKey:kUserDetailRole fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:kUserDetailLastName fromDictionary:dict];
            self.isAdmin = [self objectOrNilForKey:kUserDetailIsAdmin fromDictionary:dict];
            self.email = [self objectOrNilForKey:kUserDetailEmail fromDictionary:dict];
            self.emergencyMessage = [self objectOrNilForKey:kUserDetailEmergencyMessage fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userDetailId forKey:kUserDetailId];
    [mutableDict setValue:self.nickname forKey:kUserDetailNickname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.checkPolice] forKey:kUserDetailCheckPolice];
    [mutableDict setValue:self.phone forKey:kUserDetailPhone];
    [mutableDict setValue:[self.image dictionaryRepresentation] forKey:kUserDetailImage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kUserDetailStatus];
    [mutableDict setValue:self.createdAt forKey:kUserDetailCreatedAt];
    [mutableDict setValue:self.imageId forKey:kUserDetailImageId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isVerifyingOtp] forKey:kUserDetailIsVerifyingOtp];
    [mutableDict setValue:self.location forKey:kUserDetailLocation];
    [mutableDict setValue:self.changePhone forKey:kUserDetailChangePhone];
    [mutableDict setValue:self.birthday forKey:kUserDetailBirthday];
    [mutableDict setValue:self.updatedAt forKey:kUserDetailUpdatedAt];
    [mutableDict setValue:self.firstName forKey:kUserDetailFirstName];
    [mutableDict setValue:self.role forKey:kUserDetailRole];
    [mutableDict setValue:self.lastName forKey:kUserDetailLastName];
    [mutableDict setValue:self.isAdmin forKey:kUserDetailIsAdmin];
    [mutableDict setValue:self.email forKey:kUserDetailEmail];
    [mutableDict setValue:self.emergencyMessage forKey:kUserDetailEmergencyMessage];

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

    self.userDetailId = [aDecoder decodeObjectForKey:kUserDetailId];
    self.nickname = [aDecoder decodeObjectForKey:kUserDetailNickname];
    self.checkPolice = [aDecoder decodeDoubleForKey:kUserDetailCheckPolice];
    self.phone = [aDecoder decodeObjectForKey:kUserDetailPhone];
    self.image = [aDecoder decodeObjectForKey:kUserDetailImage];
    self.status = [aDecoder decodeDoubleForKey:kUserDetailStatus];
    self.createdAt = [aDecoder decodeObjectForKey:kUserDetailCreatedAt];
    self.imageId = [aDecoder decodeObjectForKey:kUserDetailImageId];
    self.isVerifyingOtp = [aDecoder decodeDoubleForKey:kUserDetailIsVerifyingOtp];
    self.location = [aDecoder decodeObjectForKey:kUserDetailLocation];
    self.changePhone = [aDecoder decodeObjectForKey:kUserDetailChangePhone];
    self.birthday = [aDecoder decodeObjectForKey:kUserDetailBirthday];
    self.updatedAt = [aDecoder decodeObjectForKey:kUserDetailUpdatedAt];
    self.firstName = [aDecoder decodeObjectForKey:kUserDetailFirstName];
    self.role = [aDecoder decodeObjectForKey:kUserDetailRole];
    self.lastName = [aDecoder decodeObjectForKey:kUserDetailLastName];
    self.isAdmin = [aDecoder decodeObjectForKey:kUserDetailIsAdmin];
    self.email = [aDecoder decodeObjectForKey:kUserDetailEmail];
    self.emergencyMessage = [aDecoder decodeObjectForKey:kUserDetailEmergencyMessage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userDetailId forKey:kUserDetailId];
    [aCoder encodeObject:_nickname forKey:kUserDetailNickname];
    [aCoder encodeDouble:_checkPolice forKey:kUserDetailCheckPolice];
    [aCoder encodeObject:_phone forKey:kUserDetailPhone];
    [aCoder encodeObject:_image forKey:kUserDetailImage];
    [aCoder encodeDouble:_status forKey:kUserDetailStatus];
    [aCoder encodeObject:_createdAt forKey:kUserDetailCreatedAt];
    [aCoder encodeObject:_imageId forKey:kUserDetailImageId];
    [aCoder encodeDouble:_isVerifyingOtp forKey:kUserDetailIsVerifyingOtp];
    [aCoder encodeObject:_location forKey:kUserDetailLocation];
    [aCoder encodeObject:_changePhone forKey:kUserDetailChangePhone];
    [aCoder encodeObject:_birthday forKey:kUserDetailBirthday];
    [aCoder encodeObject:_updatedAt forKey:kUserDetailUpdatedAt];
    [aCoder encodeObject:_firstName forKey:kUserDetailFirstName];
    [aCoder encodeObject:_role forKey:kUserDetailRole];
    [aCoder encodeObject:_lastName forKey:kUserDetailLastName];
    [aCoder encodeObject:_isAdmin forKey:kUserDetailIsAdmin];
    [aCoder encodeObject:_email forKey:kUserDetailEmail];
    [aCoder encodeObject:_emergencyMessage forKey:kUserDetailEmergencyMessage];
}

- (id)copyWithZone:(NSZone *)zone {
    UserDetail *copy = [[UserDetail alloc] init];
    
    
    
    if (copy) {

        copy.userDetailId = self.userDetailId;
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.checkPolice = self.checkPolice;
        copy.phone = [self.phone copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
        copy.status = self.status;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.imageId = self.imageId;
        copy.isVerifyingOtp = self.isVerifyingOtp;
        copy.location = [self.location copyWithZone:zone];
        copy.changePhone = [self.changePhone copyWithZone:zone];
        copy.birthday = [self.birthday copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.role = [self.role copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.isAdmin = [self.isAdmin copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.emergencyMessage = [self.emergencyMessage copyWithZone:zone];
    }
    
    return copy;
}


@end
