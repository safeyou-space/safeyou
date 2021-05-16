//
//  EmergencyServiceDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "EmergencyServiceDataModel.h"
#import "ImageDataModel.h"


NSString *const  kEmergnecyServiceDescription = @"description";
NSString *const  kEmergnecyServiceLatitude = @"latitude";
NSString *const  kEmergnecyServiceLongitude = @"longitude";
NSString *const  kEmergnecyServiceType = @"type";
NSString *const  kEmergnecyServiceWebAddress = @"web_address";

NSString *const  kEmergnecyServicePhone = @"phone";
NSString *const  kEmergnecyServicePhoneImage = @"phone";
NSString *const  kEmergnecyServiceId = @"id";
NSString *const  kEmergnecyServiceImageId = @"image_id";
NSString *const  kEmergnecyServiceLocation = @"location";
NSString *const  kEmergnecyServiceTitle = @"title";
NSString *const  kEmergnecyServiceUserDetails = @"user_detail";
NSString *const  kEmergnecyServiceUserId = @"user_id";

NSString *const  kEmergnecyServiceEmail = @"email";
NSString *const  kEmergnecyServiceEmailImage = @"email";
NSString *const  kEmergnecyServiceImage = @"image";

NSString *const  kEmergnecyServiceAddress = @"address";
NSString *const  kEmergnecyServiceAddressImageUrl = @"address";

NSString *const  kEmergnecyServiceFacebookIcon = @"facebook";
NSString *const  kEmergnecyServiceFacebookPage = @"facebook_link";
NSString *const  kEmergnecyServiceFacebookPageTitle = @"facebook_title";

NSString *const  kEmergnecyServiceInstagramIcon = @"instagram";
NSString *const  kEmergnecyServiceInstagramPage = @"instagram_link";
NSString *const  kEmergnecyServiceInstagramPageTitle = @"instagram_title";
NSString *const  kEmergnecyServiceWebAddressIcon = @"web_address";

NSString *const kEmegensyServiceUserServiceId = @"user_emergency_service_id";
NSString *const kEmergencyServiceCategoryid = @"emergency_service_category_id";
NSString *const kEmergencyServiceCategoryName = @"category_translation";
NSString *const kEmergencyServiceIsSendSMS = @"is_send_sms";



@implementation EmergencyServiceDataModel

@synthesize webAddress = _webAddress;
@synthesize longitude = _longitude;
@synthesize serviceId = _serviceId;
@synthesize latitude = _latitude;
@synthesize serviceDescription = _serviceDescription;
@synthesize image = _image;
@synthesize userEmergencyServiceId = _userEmergencyServiceId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.userId = [self objectOrNilForKey: kEmergnecyServiceUserId fromDictionary:dict];
        self.userDetails = [UserDetail modelObjectWithDictionary:[dict objectForKey: kEmergnecyServiceUserDetails]];
        self.webAddress = [self objectOrNilForKey: kEmergnecyServiceWebAddress fromDictionary:dict];
        self.longitude = [self objectOrNilForKey: kEmergnecyServiceLongitude fromDictionary:dict];
        self.serviceId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey: kEmergnecyServiceId fromDictionary:dict]];
        self.serviceType = [self objectOrNilForKey: kEmergnecyServiceType fromDictionary:dict];
        self.latitude = [self objectOrNilForKey: kEmergnecyServiceLatitude fromDictionary:dict];
        self.serviceDescription = [self objectOrNilForKey: kEmergnecyServiceDescription fromDictionary:dict];
        self.image = [ImageDataModel modelObjectWithDictionary:[dict objectForKey: kEmergnecyServiceImage]];
        self.isAvailableForEmergency = [[self objectOrNilForKey:kEmergencyServiceIsSendSMS fromDictionary:dict] boolValue];
        
        NSDictionary *iconsDict = [self objectOrNilForKey:@"icons" fromDictionary:dict];
        
        self.serviceAddress = [self objectOrNilForKey:kEmergnecyServiceAddress fromDictionary:dict];
        self.serviceAddressImageURL = [self objectOrNilForKey:kEmergnecyServiceAddressImageUrl fromDictionary:iconsDict];
        
        self.emailIconURL = [self objectOrNilForKey:kEmergnecyServiceEmailImage fromDictionary:iconsDict];
        
        self.webAddressIconUrl = [self objectOrNilForKey:kEmergnecyServiceWebAddressIcon fromDictionary:iconsDict];
        self.phoneIconURL = [self objectOrNilForKey:kEmergnecyServicePhoneImage fromDictionary:iconsDict];
        
        NSNumber *categoryId = [self objectOrNilForKey:kEmergencyServiceCategoryid fromDictionary:dict];
        self.categoryId = [NSString stringWithFormat:@"%@", categoryId];
        self.localizedCategoryName = [self objectOrNilForKey:kEmergencyServiceCategoryName fromDictionary:dict];
        _userEmergencyServiceId = [self objectOrNilForKey:kEmegensyServiceUserServiceId fromDictionary:dict];
        
        NSArray *socialLinksArray = [self objectOrNilForKey:@"social_links" fromDictionary:dict];
        if (socialLinksArray) {
            NSDictionary *facebookDataDict = [self dictionaryFromArray:socialLinksArray forKeyPath:@"facebook"];
            if (facebookDataDict) {
                self.serviceFacebookIconURL = [self objectOrNilForKey:kEmergnecyServiceFacebookIcon fromDictionary:iconsDict];
                self.serviceFacebookPageURL = [self objectOrNilForKey:@"url" fromDictionary:facebookDataDict];
                self.serviceFacebookPageTitle = [self objectOrNilForKey:@"title" fromDictionary:facebookDataDict];
            }
            
            NSDictionary *instagramDataDict = [self dictionaryFromArray:socialLinksArray forKeyPath:@"instagram"];
            if (instagramDataDict) {
                self.serviceInstagramIconURL = [self objectOrNilForKey:kEmergnecyServiceInstagramIcon fromDictionary:iconsDict];
                self.serviceInstagramPageURL = [self objectOrNilForKey:@"url" fromDictionary:instagramDataDict];
                self.serviceFacebookPageTitle = [self objectOrNilForKey:@"title" fromDictionary:instagramDataDict];
            }    
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryFromArray:(NSArray *)dictsArray forKeyPath:(NSString *)keyPath
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", keyPath];
    NSArray *filteredArray = [dictsArray filteredArrayUsingPredicate:predicate];
    
    return filteredArray.firstObject;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.webAddress forKey: kEmergnecyServiceWebAddress];
    [mutableDict setValue:self.longitude forKey: kEmergnecyServiceLongitude];
    [mutableDict setValue:self.serviceId forKey: kEmergnecyServiceId];
    [mutableDict setValue:self.latitude forKey: kEmergnecyServiceLatitude];
    [mutableDict setValue:self.serviceDescription forKey: kEmergnecyServiceDescription];
    [mutableDict setValue:[self.image dictionaryRepresentation] forKey: kEmergnecyServiceImage];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.webAddress = [aDecoder decodeObjectForKey: kEmergnecyServiceWebAddress];
    self.longitude = [aDecoder decodeObjectForKey: kEmergnecyServiceLongitude];
    self.serviceId = [aDecoder decodeObjectForKey: kEmergnecyServiceId];
    self.latitude = [aDecoder decodeObjectForKey: kEmergnecyServiceLatitude];
    self.serviceDescription = [aDecoder decodeObjectForKey: kEmergnecyServiceDescription];
    self.image = [aDecoder decodeObjectForKey: kEmergnecyServiceImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_webAddress forKey: kEmergnecyServiceWebAddress];
    [aCoder encodeObject:_longitude forKey: kEmergnecyServiceLongitude];
    [aCoder encodeObject:_serviceId forKey: kEmergnecyServiceId];
    [aCoder encodeObject:_latitude forKey: kEmergnecyServiceLatitude];
    [aCoder encodeObject:_serviceDescription forKey: kEmergnecyServiceDescription];
    [aCoder encodeObject:_image forKey: kEmergnecyServiceImage];
}

- (id)copyWithZone:(NSZone *)zone {
    EmergencyServiceDataModel *copy = [[EmergencyServiceDataModel alloc] init];
    
    if (copy) {
        copy.webAddress = [self.webAddress copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.serviceId = self.serviceId;
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.serviceDescription = [self.serviceDescription copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
    }
    return copy;
}


@end
