//
//  NotificationDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/27/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "NotificationDataModel.h"

NSString *const kNotificationDataForumId = @"forum_id";
NSString *const kNotificationDataImagePath = @"image_path";
NSString *const kNotificationDataId = @"id";
NSString *const kNotificationDataCreatedAt = @"created_at";
NSString *const kNotificationDataReplyId = @"reply_id";
NSString *const kNotificationDataUserType = @"user_type";
NSString *const kNotificationDataIsReaded = @"isReaded";
NSString *const kNotificationDataUserId = @"user_id";
NSString *const kNotificationDataKey = @"key";
NSString *const kNotificationDataName = @"name";

@implementation NotificationDataModel

@synthesize forumId = _forumId;
@synthesize imagePath = _imagePath;
@synthesize notificationId = _notificationId;
@synthesize createdAt = _createdAt;
@synthesize replyId = _replyId;
@synthesize userType = _userType;
@synthesize isReaded = _isReaded;
@synthesize userId = _userId;
@synthesize key = _key;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.forumId = [self objectOrNilForKey:kNotificationDataForumId fromDictionary:dict];
        self.imagePath = [self objectOrNilForKey:kNotificationDataImagePath fromDictionary:dict];
        self.notificationId = [self objectOrNilForKey:kNotificationDataId fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kNotificationDataCreatedAt fromDictionary:dict];
        self.formattedDateString = [self formatDateToShow:self.createdAt];
        self.replyId = [self objectOrNilForKey:kNotificationDataReplyId fromDictionary:dict];
        self.userType = [self objectOrNilForKey:kNotificationDataUserType fromDictionary:dict];
        self.isReaded = [self objectOrNilForKey:kNotificationDataIsReaded fromDictionary:dict];
        self.userId = [self objectOrNilForKey:kNotificationDataUserId fromDictionary:dict];
        self.key = [self objectOrNilForKey:kNotificationDataKey fromDictionary:dict];
        self.name = [self objectOrNilForKey:kNotificationDataName fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.forumId forKey:kNotificationDataForumId];
    [mutableDict setValue:self.imagePath forKey:kNotificationDataImagePath];
    [mutableDict setValue:self.notificationId forKey:kNotificationDataId];
    [mutableDict setValue:self.createdAt forKey:kNotificationDataCreatedAt];
    [mutableDict setValue:self.replyId forKey:kNotificationDataReplyId];
    [mutableDict setValue:self.userType forKey:kNotificationDataUserType];
    [mutableDict setValue:self.isReaded forKey:kNotificationDataIsReaded];
    [mutableDict setValue:self.userId forKey:kNotificationDataUserId];
    [mutableDict setValue:self.key forKey:kNotificationDataKey];
    [mutableDict setValue:self.name forKey:kNotificationDataName];
    
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
    
    self.forumId = [aDecoder decodeObjectForKey:kNotificationDataForumId];
    self.imagePath = [aDecoder decodeObjectForKey:kNotificationDataImagePath];
    self.notificationId = [aDecoder decodeObjectForKey:kNotificationDataId];
    self.createdAt = [aDecoder decodeObjectForKey:kNotificationDataCreatedAt];
    self.replyId = [aDecoder decodeObjectForKey:kNotificationDataReplyId];
    self.userType = [aDecoder decodeObjectForKey:kNotificationDataUserType];
    self.isReaded = [aDecoder decodeObjectForKey:kNotificationDataIsReaded];
    self.userId = [aDecoder decodeObjectForKey:kNotificationDataUserId];
    self.key = [aDecoder decodeObjectForKey:kNotificationDataKey];
    self.name = [aDecoder decodeObjectForKey:kNotificationDataName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_forumId forKey:kNotificationDataForumId];
    [aCoder encodeObject:_imagePath forKey:kNotificationDataImagePath];
    [aCoder encodeObject:_notificationId forKey:kNotificationDataId];
    [aCoder encodeObject:_createdAt forKey:kNotificationDataCreatedAt];
    [aCoder encodeObject:_replyId forKey:kNotificationDataReplyId];
    [aCoder encodeObject:_userType forKey:kNotificationDataUserType];
    [aCoder encodeObject:_isReaded forKey:kNotificationDataIsReaded];
    [aCoder encodeObject:_userId forKey:kNotificationDataUserId];
    [aCoder encodeObject:_key forKey:kNotificationDataKey];
    [aCoder encodeObject:_name forKey:kNotificationDataName];
}

- (id)copyWithZone:(NSZone *)zone {
    NotificationDataModel *copy = [[NotificationDataModel alloc] init];
    if (copy) {
        copy.forumId = [self.forumId copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.notificationId = [self.notificationId copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.replyId = [self.replyId copyWithZone:zone];
        copy.userType = [self.userType copyWithZone:zone];
        copy.isReaded = [self.isReaded copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.key = [self.key copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

#pragma mark - Format Date

// @TODO: Dublicate code need refactor

- (NSString *)formatDateToShow:(NSString *)initialDateString
{
    //2020-05-28T15:12:40.000Z
    //2020-05-28T14:59:05.189Z
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd'T'HH:mm:ssZ
    //yyyy-MM-dd'T'HH:mm:ssZZZZ
//    [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss.sssZ"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.locale = [NSLocale currentLocale];
    NSDate *receivedDate = [dateFormatter dateFromString:initialDateString];
    
    // Nov 4, 18:03
    dateFormatter.dateFormat = @"MMM d, HH:mm";
    NSString *formatedDateString = [dateFormatter stringFromDate:receivedDate];
    
    return formatedDateString;
}

- (BOOL)isEqual:(NotificationDataModel *)other
{
    if (other == self) {
        return YES;
    } else {
        NSString *comparingIdOne = [NSString stringWithFormat:@"%@", self.notificationId];
        NSString *comparingIdTwo = [NSString stringWithFormat:@"%@", other.notificationId];
        return [comparingIdOne isEqualToString:comparingIdTwo];
    }
}

- (NSUInteger)hash
{
    return self.hash;
}




@end
