//
//  ForumCommentDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumCommentDataModel.h"

NSString *const kCommentsId = @"id";
NSString *const kCommentsImagePath = @"image_path";
NSString *const kCommentsCreatedAt = @"created_at";
NSString *const kCommentsCreatedDate = @"created_date";
NSString *const kCommentsUserType = @"user_type";
NSString *const kCommentsMessage = @"message";
NSString *const kCommentsUserId = @"user_id";
NSString *const kCommentsMy = @"my";
NSString *const kCommentsName = @"name";
NSString *const kCommentsReplyId = @"reply_id";

NSString *const kCommentsConsultantId = @"consultant_id";
NSString *const kCommentsGroupId = @"group_id";
NSString *const kCommentsLevel = @"level";
NSString *const kCommentsServiceId = @"service_id";
NSString *const kCommentsUserTypeId = @"user_type_id";
NSString *const kCommentsReplyCount = @"reply_count";

@interface ForumCommentDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ForumCommentDataModel

@synthesize imagePath = _imagePath;
@synthesize createdAt = _createdAt;
@synthesize userType = _userType;
@synthesize message = _message;
@synthesize userId = _userId;
@synthesize isMine = _isMine;
@synthesize name = _name;
@synthesize consultantId = _consultantId;
@synthesize groupId = _groupId;
@synthesize level = _level;
@synthesize serviceId = _serviceId;
@synthesize userTypeId = _userTypeId;



+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.commentId = [self objectOrNilForKey:kCommentsId fromDictionary:dict];
        if ([self objectOrNilForKey:kCommentsReplyId fromDictionary:dict]) {
            self.replyId = [self objectOrNilForKey:kCommentsReplyId fromDictionary:dict];
            self.isReply = YES;
        }
        self.imagePath = [self objectOrNilForKey:kCommentsImagePath fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kCommentsCreatedAt fromDictionary:dict];
        self.userType = [self objectOrNilForKey:kCommentsUserType fromDictionary:dict];
        self.message = [self objectOrNilForKey:kCommentsMessage fromDictionary:dict];
        self.userId = [self objectOrNilForKey:kCommentsUserId fromDictionary:dict];
        self.isMine = [[self objectOrNilForKey:kCommentsMy fromDictionary:dict] boolValue];
        self.name = [self objectOrNilForKey:kCommentsName fromDictionary:dict];
        
        self.consultantId = [self objectOrNilForKey:kCommentsConsultantId fromDictionary:dict];
        self.groupId = [self objectOrNilForKey:kCommentsGroupId fromDictionary:dict];
        self.level = [self objectOrNilForKey:kCommentsLevel fromDictionary:dict];
        if (self.level.integerValue > 0) {
            self.isReply = YES;
        }
        self.serviceId = [self objectOrNilForKey:kCommentsServiceId fromDictionary:dict];
        self.userTypeId = [self objectOrNilForKey:kCommentsUserTypeId fromDictionary:dict];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.imagePath forKey:kCommentsImagePath];
    [mutableDict setValue:self.createdAt forKey:kCommentsCreatedAt];
    [mutableDict setValue:self.userType forKey:kCommentsUserType];
    [mutableDict setValue:self.message forKey:kCommentsMessage];
    [mutableDict setValue:self.userId forKey:kCommentsUserId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isMine] forKey:kCommentsMy];
    [mutableDict setValue:self.name forKey:kCommentsName];
    
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
    
    self.imagePath = [aDecoder decodeObjectForKey:kCommentsImagePath];
    self.createdAt = [aDecoder decodeObjectForKey:kCommentsCreatedAt];
    self.userType = [aDecoder decodeObjectForKey:kCommentsUserType];
    self.message = [aDecoder decodeObjectForKey:kCommentsMessage];
    self.userId = [aDecoder decodeObjectForKey:kCommentsUserId];
    self.isMine = [aDecoder decodeBoolForKey:kCommentsMy];
    self.name = [aDecoder decodeObjectForKey:kCommentsName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_imagePath forKey:kCommentsImagePath];
    [aCoder encodeObject:_createdAt forKey:kCommentsCreatedAt];
    [aCoder encodeObject:_userType forKey:kCommentsUserType];
    [aCoder encodeObject:_message forKey:kCommentsMessage];
    [aCoder encodeObject:_userId forKey:kCommentsUserId];
    [aCoder encodeBool:_isMine forKey:kCommentsMy];
    [aCoder encodeObject:_name forKey:kCommentsName];
}

- (id)copyWithZone:(NSZone *)zone {
    ForumCommentDataModel *copy = [[ForumCommentDataModel alloc] init];
    
    
    
    if (copy) {
        
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.userType = [self.userType copyWithZone:zone];
        copy.message = [self.message copyWithZone:zone];
        copy.userId = self.userId;
        copy.isMine = self.isMine;
        copy.name = [self.name copyWithZone:zone];
        copy.replyId = [self.replyId copyWithZone:zone];
    }
    
    return copy;
}

- (BOOL)isEqual:(ForumCommentDataModel *)other
{
    if (![other isKindOfClass:[ForumCommentDataModel class]]) {
        return NO;
    }
    if (other == self) {
        return YES;
    }
    
    return self.commentId == other.commentId;   
}

- (NSUInteger)hash
{
    return self.hash;
}

#pragma mark - Helpter

- (void)setCreatedAt:(NSString *)createdAt
{
    _createdAt = createdAt;
    self.formattedCreatedDate = [self formatDateToShow:_createdAt];
    
}

- (NSString *)formatDateToShow:(NSString *)initialDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd'T'HH:mm:ssZ
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.ssssZ"];
    dateFormatter.locale = [NSLocale currentLocale];
    NSDate *receivedDate = [dateFormatter dateFromString:initialDateString];
    
    // Nov 4, 18:03
    dateFormatter.dateFormat = @"MMM d, HH:mm";
    NSString *formatedDateString = [dateFormatter stringFromDate:receivedDate];
    
    return formatedDateString;
}


@end
