//
//  UserDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UserDataModel.h"

#import "EmergencyContactDataModel.h"
#import "ImageDataModel.h"
#import "RecordDataModel.h"
#import "EmergencyServiceDataModel.h"
#import "UserConsultantRequestDataModel.h"
#import "ProfileQuestionsAnswersDataModel.h"

NSString *const kUserClassIsVerifyingOtp = @"is_verifying_otp";
NSString *const kUserClassEmergencyContacts = @"emergency_contacts";
NSString *const kUserClassBirthday = @"birthday";
NSString *const kUserClassStatus = @"status";
NSString *const kUserClassEmergencyServices = @"emergency_services";
NSString *const kUserClassImage = @"image";
NSString *const kUserClassUpdatedAt = @"updated_at";
NSString *const kUserClassNickname = @"nickname";
NSString *const kUserClassNgos = @"ngos";
NSString *const kUserClassLastName = @"last_name";
NSString *const kUserClassImageId = @"image_id";
NSString *const kUserClassCheckPolice = @"check_police";
NSString *const kUserClassEmergencyMessage = @"emergency_message";
NSString *const kUserClassRecords = @"records";
NSString *const kUserClassEmail = @"email";
NSString *const kUserClassIsAdmin = @"is_admin";
NSString *const kUserClassPhone = @"phone";
NSString *const kUserClassRole = @"role";
NSString *const kUserClassUId = @"uid";
NSString *const kUserClassLocation = @"location";
NSString *const kUserClassCreatedAt = @"created_at";
NSString *const kUserClassFirstName = @"first_name";
NSString *const kUserClassUserId = @"id";
NSString *const kUserClassMaritalStatus = @"marital_status";
NSString *const kUserClassHelpMessage = @"help_message";
NSString *const kUserClassIsConsultant = @"is_consultant";
NSString *const kUserClassConsultantRequest = @"consultant_request";
NSString *const kUserProfileQuestions = @"profile_questions_answers";
NSString *const kUserClassFilledPercent = @"filled_percent";

@interface UserDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserDataModel

@synthesize isVerifyingOtp = _isVerifyingOtp;
@synthesize emergencyContacts = _emergencyContacts;
@synthesize emergencyServices = _emergencyServices;
@synthesize birthday = _birthday;
@synthesize status = _status;
@synthesize image = _image;
@synthesize updatedAt = _updatedAt;
@synthesize nickname = _nickname;
@synthesize lastName = _lastName;
@synthesize imageId = _imageId;
@synthesize checkPolice = _checkPolice;
@synthesize emergencyMessage = _emergencyMessage;
@synthesize records = _records;
@synthesize email = _email;
@synthesize isAdmin = _isAdmin;
@synthesize phone = _phone;
@synthesize role = _role;
@synthesize uId = _uId;
@synthesize location = _location;
@synthesize createdAt = _createdAt;
@synthesize firstName = _firstName;
@synthesize userId = _userId;
@synthesize profileQuestionsAnswers = _profileQuestionsAnswers;
@synthesize filledPercent = _filledPercent;

#pragma mark - Functionality

- (BOOL)containsService:(NSString *)serviceId
{
    NSArray *serviceIdsArray = [self.userEmergencyServices valueForKeyPath:@"serviceId"];
    if ([serviceIdsArray containsObject:serviceId]) {
        NSLog(@"Contains");
        return YES;
    } else {
        NSLog(@"Does not contain");
        return NO;
    }
}

- (EmergencyServiceDataModel *)userServiceForServiceId:(NSString *)serviceId
{
    NSArray *serviceIds = [self.userEmergencyServices valueForKeyPath:@"serviceId"];
    NSInteger serviceIndex = [serviceIds indexOfObject:serviceId];
    EmergencyServiceDataModel *selectedService = [self.userEmergencyServices objectAtIndex:serviceIndex];
    return selectedService;
}

#pragma mark - Getter

- (NSArray *)userEmergencyServices
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:self.emergencyServices];
    
    return [tempArray copy];
}

- (void)updateValue:(NSString *)value forKey:(NSString *)key
{
    if ([key isEqualToString:kUserClassFirstName]) {
        self.firstName = value;
    }
    
    if ([key isEqualToString:kUserClassLastName]) {
        self.lastName = value;
    }
    
    if ([key isEqualToString:kUserClassPhone]) {
        self.phone = value;
    }
}

#pragma mark - Main Interface

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.isVerifyingOtp = [[self objectOrNilForKey:kUserClassIsVerifyingOtp fromDictionary:dict] boolValue];
        NSObject *receivedEmergencyContacts = [dict objectForKey:kUserClassEmergencyContacts];
        NSMutableArray *parsedEmergencyContacts = [NSMutableArray array];
        
        if ([receivedEmergencyContacts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedEmergencyContacts) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedEmergencyContacts addObject:[EmergencyContactDataModel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedEmergencyContacts isKindOfClass:[NSDictionary class]]) {
            [parsedEmergencyContacts addObject:[EmergencyContactDataModel modelObjectWithDictionary:(NSDictionary *)receivedEmergencyContacts]];
        }
        
        self.emergencyContacts = [NSArray arrayWithArray:parsedEmergencyContacts];
        self.birthday = [self objectOrNilForKey:kUserClassBirthday fromDictionary:dict];
        self.status = [[self objectOrNilForKey:kUserClassStatus fromDictionary:dict] doubleValue];
        
        NSObject *emergencyServicesDict = [dict objectForKey:kUserClassEmergencyServices];
        NSMutableArray *parsedEmergencyServices = [NSMutableArray array];
        if ([emergencyServicesDict isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemDict in (NSArray *)emergencyServicesDict) {
                if ([itemDict isKindOfClass:[NSDictionary class]]) {
                    [parsedEmergencyServices addObject:[EmergencyServiceDataModel modelObjectWithDictionary:itemDict]];
                }
            }
        } else if ([emergencyServicesDict isKindOfClass:[NSDictionary class]]) {
            [parsedEmergencyServices addObject:[EmergencyServiceDataModel modelObjectWithDictionary:(NSDictionary *)emergencyServicesDict]];
        }
        self.emergencyServices = [NSArray arrayWithArray:parsedEmergencyServices];
        
        self.image = [ImageDataModel modelObjectWithDictionary:[dict objectForKey:kUserClassImage]];
        self.updatedAt = [self objectOrNilForKey:kUserClassUpdatedAt fromDictionary:dict];
        self.nickname = [self objectOrNilForKey:kUserClassNickname fromDictionary:dict];
        self.maritalStatus = nilOrJSONObjectForKey(dict, kUserClassMaritalStatus);
        self.lastName = [self objectOrNilForKey:kUserClassLastName fromDictionary:dict];
        self.imageId = [self objectOrNilForKey:kUserClassImageId fromDictionary:dict];
        self.checkPolice = [[self objectOrNilForKey:kUserClassCheckPolice fromDictionary:dict] boolValue];
        self.emergencyMessage = [self objectOrNilForKey:kUserClassEmergencyMessage fromDictionary:dict];
        self.email = [self objectOrNilForKey:kUserClassEmail fromDictionary:dict];
        self.isAdmin = [[self objectOrNilForKey:kUserClassIsAdmin fromDictionary:dict] boolValue];
        self.phone = [self objectOrNilForKey:kUserClassPhone fromDictionary:dict];
        self.role = [self objectOrNilForKey:kUserClassRole fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kUserClassCreatedAt fromDictionary:dict];
        self.firstName = [self objectOrNilForKey:kUserClassFirstName fromDictionary:dict];
        self.userId = [self objectOrNilForKey:kUserClassUserId fromDictionary:dict];
        self.uId = [self objectOrNilForKey:kUserClassUId fromDictionary:dict];
        self.location = [self objectOrNilForKey:kUserClassLocation fromDictionary:dict];
        self.helpMessagData = [HelpMessageDataModel modelObjectWithDictionary:[self objectOrNilForKey:kUserClassHelpMessage fromDictionary:dict]];
        self.profileQuestionsAnswers = [ProfileQuestionsAnswersDataModel modelObjectWithDictionary:[self objectOrNilForKey:kUserProfileQuestions fromDictionary:dict]];
        self.filledPercent = [self objectOrNilForKey:kUserClassFilledPercent fromDictionary:dict];
//        self.profileQuestionsAnswers = [ProfileQuestionsAnswersDataModel alloc];
//        self.profileQuestionsAnswers.answers = [self objectOrNilForKey:kUserProfileQuestions fromDictionary:dict];
        
        self.isConsultant = NO;
        boolObjectOrNilForKey(self.isConsultant, dict, kUserClassIsConsultant)
        
        NSArray *consultantRequestsData = dict[kUserClassConsultantRequest];
        NSDictionary *consultantRequestDict = consultantRequestsData.firstObject;
        if (consultantRequestDict) {
            self.currentConsultantRequest = [[UserConsultantRequestDataModel alloc] initWithDictionary:consultantRequestDict];
        } else {
            self.currentConsultantRequest = nil;
        }
        
        NSArray *recordsData = dict[kUserClassRecords];
        NSDictionary *recorssDict = recordsData.firstObject;
        self.records = [RecordDataModel modelObjectWithDictionary:recorssDict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.isVerifyingOtp] forKey:kUserClassIsVerifyingOtp];
    NSMutableArray *tempArrayForEmergencyContacts = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.emergencyContacts) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEmergencyContacts addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEmergencyContacts addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEmergencyContacts] forKey:kUserClassEmergencyContacts];
    [mutableDict setValue:self.birthday forKey:kUserClassBirthday];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kUserClassStatus];
    NSMutableArray *tempArrayForEmergencyServices = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.emergencyServices) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEmergencyServices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEmergencyServices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEmergencyServices] forKey:kUserClassEmergencyServices];
    [mutableDict setValue:[self.image dictionaryRepresentation] forKey:kUserClassImage];
    [mutableDict setValue:self.updatedAt forKey:kUserClassUpdatedAt];
    [mutableDict setValue:self.nickname forKey:kUserClassNickname];
    [mutableDict setValue:self.lastName forKey:kUserClassLastName];
    [mutableDict setValue:self.imageId forKey:kUserClassImageId];
    [mutableDict setValue:[NSNumber numberWithBool:self.checkPolice] forKey:kUserClassCheckPolice];
    [mutableDict setValue:self.emergencyMessage forKey:kUserClassEmergencyMessage];
    [mutableDict setValue:[self.records dictionaryRepresentation] forKey:kUserClassRecords];
    [mutableDict setValue:self.email forKey:kUserClassEmail];
    [mutableDict setValue:[NSNumber numberWithBool:self.isAdmin] forKey:kUserClassIsAdmin];
    [mutableDict setValue:self.phone forKey:kUserClassPhone];
    [mutableDict setValue:self.role forKey:kUserClassRole];
    [mutableDict setValue:self.uId forKey:kUserClassUId];
    [mutableDict setValue:self.location forKey:kUserClassLocation];
    [mutableDict setValue:self.createdAt forKey:kUserClassCreatedAt];
    [mutableDict setValue:self.firstName forKey:kUserClassFirstName];
    [mutableDict setValue:self.userId forKey:kUserClassUserId];
    [mutableDict setValue:self.filledPercent forKey:kUserClassFilledPercent];
    [mutableDict setValue:self.profileQuestionsAnswers forKey:kUserProfileQuestions];
    
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
    
    self.isVerifyingOtp = [aDecoder decodeBoolForKey:kUserClassIsVerifyingOtp];
    self.emergencyContacts = [aDecoder decodeObjectForKey:kUserClassEmergencyContacts];
    self.birthday = [aDecoder decodeObjectForKey:kUserClassBirthday];
    self.status = [aDecoder decodeDoubleForKey:kUserClassStatus];
    self.emergencyServices = [aDecoder decodeObjectForKey:kUserClassEmergencyServices];
    self.image = [aDecoder decodeObjectForKey:kUserClassImage];
    self.updatedAt = [aDecoder decodeObjectForKey:kUserClassUpdatedAt];
    self.nickname = [aDecoder decodeObjectForKey:kUserClassNickname];
    self.lastName = [aDecoder decodeObjectForKey:kUserClassLastName];
    self.imageId = [aDecoder decodeObjectForKey:kUserClassImageId];
    self.checkPolice = [aDecoder decodeBoolForKey:kUserClassCheckPolice];
    self.emergencyMessage = [aDecoder decodeObjectForKey:kUserClassEmergencyMessage];
    self.records = [aDecoder decodeObjectForKey:kUserClassRecords];
    self.email = [aDecoder decodeObjectForKey:kUserClassEmail];
    self.isAdmin = [aDecoder decodeBoolForKey:kUserClassIsAdmin];
    self.phone = [aDecoder decodeObjectForKey:kUserClassPhone];
    self.role = [aDecoder decodeObjectForKey:kUserClassRole];
    self.uId = [aDecoder decodeObjectForKey:kUserClassUId];
    self.location = [aDecoder decodeObjectForKey:kUserClassLocation];
    self.createdAt = [aDecoder decodeObjectForKey:kUserClassCreatedAt];
    self.firstName = [aDecoder decodeObjectForKey:kUserClassFirstName];
    self.userId = [aDecoder decodeObjectForKey:kUserClassUserId];
    self.filledPercent = [aDecoder decodeObjectForKey:kUserClassFilledPercent];
    self.profileQuestionsAnswers = [aDecoder decodeObjectForKey:kUserProfileQuestions];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeBool:_isVerifyingOtp forKey:kUserClassIsVerifyingOtp];
    [aCoder encodeObject:_emergencyContacts forKey:kUserClassEmergencyContacts];
    [aCoder encodeObject:_birthday forKey:kUserClassBirthday];
    [aCoder encodeDouble:_status forKey:kUserClassStatus];
    [aCoder encodeObject:_emergencyServices forKey:kUserClassEmergencyServices];
    [aCoder encodeObject:_image forKey:kUserClassImage];
    [aCoder encodeObject:_updatedAt forKey:kUserClassUpdatedAt];
    [aCoder encodeObject:_nickname forKey:kUserClassNickname];
    [aCoder encodeObject:_lastName forKey:kUserClassLastName];
    [aCoder encodeObject:_imageId forKey:kUserClassImageId];
    [aCoder encodeBool:_checkPolice forKey:kUserClassCheckPolice];
    [aCoder encodeObject:_emergencyMessage forKey:kUserClassEmergencyMessage];
    [aCoder encodeObject:_records forKey:kUserClassRecords];
    [aCoder encodeObject:_email forKey:kUserClassEmail];
    [aCoder encodeBool:_isAdmin forKey:kUserClassIsAdmin];
    [aCoder encodeObject:_phone forKey:kUserClassPhone];
    [aCoder encodeObject:_role forKey:kUserClassRole];
    [aCoder encodeObject:_uId forKey:kUserClassUId];
    [aCoder encodeObject:_location forKey:kUserClassLocation];
    [aCoder encodeObject:_createdAt forKey:kUserClassCreatedAt];
    [aCoder encodeObject:_firstName forKey:kUserClassFirstName];
    [aCoder encodeObject:_userId forKey:kUserClassUserId];
    [aCoder encodeObject:_filledPercent forKey:kUserClassFilledPercent];
    [aCoder encodeObject:_profileQuestionsAnswers forKey:kUserProfileQuestions];
}

- (id)copyWithZone:(NSZone *)zone {
    UserDataModel *copy = [[UserDataModel alloc] init];
    
    
    
    if (copy) {
        
        copy.isVerifyingOtp = self.isVerifyingOtp;
        copy.emergencyContacts = [self.emergencyContacts copyWithZone:zone];
        copy.birthday = [self.birthday copyWithZone:zone];
        copy.status = self.status;
        copy.emergencyServices = [self.emergencyServices copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.imageId = self.imageId;
        copy.checkPolice = self.checkPolice;
        copy.emergencyMessage = [self.emergencyMessage copyWithZone:zone];
        copy.records = [self.records copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.isAdmin = self.isAdmin;
        copy.phone = [self.phone copyWithZone:zone];
        copy.role = [self.role copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.filledPercent = [self.filledPercent copyWithZone:zone];
        copy.userId = self.userId;
        copy.profileQuestionsAnswers = [self.profileQuestionsAnswers copyWithZone:zone];
    }
    
    return copy;
}


@end

