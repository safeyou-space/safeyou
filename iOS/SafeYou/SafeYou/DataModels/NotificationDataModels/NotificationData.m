//
//	NotificationData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NotificationData.h"

NSString *const kNotificationDataNotificationMessage = @"notify_body";
NSString *const kNotificationDataNotificationBody = @"body";
NSString *const kNotificationDataNotifyCreatedAt = @"notify_created_at";
NSString *const kNotificationDataNotifyId = @"notify_id";
NSString *const kNotificationDataNotifyRead = @"notify_read";
NSString *const kNotificationDataNotifyStatus = @"notify_status";
NSString *const kNotificationDataNotifyTitle = @"notify_title";
NSString *const kNotificationDataNotifyType = @"notify_type";
NSString *const kNotificationDataNotifyUpdatedAt = @"notify_updated_at";
NSString *const kNotificationDataNotifyUserId = @"notify_user_id";

@interface NotificationData ()

@end

@implementation NotificationData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    NSDictionary *messageDict = nilOrJSONObjectForKey(dictionary, kNotificationDataNotificationMessage);
    NSDictionary *bodyDict = nilOrJSONObjectForKey(dictionary, kNotificationDataNotificationBody);
    if (messageDict) {
        self.notificationMessage = [[NotificationMessage alloc] initWithDictionary:messageDict];
    } else if (bodyDict) {
        self.notificationMessage = [[NotificationMessage alloc] initWithDictionary:bodyDict];
    }

	if(![dictionary[kNotificationDataNotifyCreatedAt] isKindOfClass:[NSNull class]]){
		self.notifyCreatedAt = dictionary[kNotificationDataNotifyCreatedAt];
	}	
	if(![dictionary[kNotificationDataNotifyId] isKindOfClass:[NSNull class]]){
		self.notifyId = [dictionary[kNotificationDataNotifyId] integerValue];
	}

	if(![dictionary[kNotificationDataNotifyRead] isKindOfClass:[NSNull class]]){
		self.notifyRead = [dictionary[kNotificationDataNotifyRead] integerValue];
	}

	if(![dictionary[kNotificationDataNotifyStatus] isKindOfClass:[NSNull class]]){
		self.notifyStatus = [dictionary[kNotificationDataNotifyStatus] integerValue];
	}

	if(![dictionary[kNotificationDataNotifyTitle] isKindOfClass:[NSNull class]]){
		self.notifyTitle = dictionary[kNotificationDataNotifyTitle];
	}	
	if(![dictionary[kNotificationDataNotifyType] isKindOfClass:[NSNull class]]){
		self.notifyType = [dictionary[kNotificationDataNotifyType] integerValue];
	}

	if(![dictionary[kNotificationDataNotifyUpdatedAt] isKindOfClass:[NSNull class]]){
		self.notifyUpdatedAt = dictionary[kNotificationDataNotifyUpdatedAt];
	}	
	if(![dictionary[kNotificationDataNotifyUserId] isKindOfClass:[NSNull class]]){
		self.notifyUserId = [dictionary[kNotificationDataNotifyUserId] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.notificationMessage != nil){
		dictionary[kNotificationDataNotificationMessage] = [self.notificationMessage toDictionary];
	}
	if(self.notifyCreatedAt != nil){
		dictionary[kNotificationDataNotifyCreatedAt] = self.notifyCreatedAt;
	}
	dictionary[kNotificationDataNotifyId] = @(self.notifyId);
	dictionary[kNotificationDataNotifyRead] = @(self.notifyRead);
	dictionary[kNotificationDataNotifyStatus] = @(self.notifyStatus);
	if(self.notifyTitle != nil){
		dictionary[kNotificationDataNotifyTitle] = self.notifyTitle;
	}
	dictionary[kNotificationDataNotifyType] = @(self.notifyType);
	if(self.notifyUpdatedAt != nil){
		dictionary[kNotificationDataNotifyUpdatedAt] = self.notifyUpdatedAt;
	}
	dictionary[kNotificationDataNotifyUserId] = @(self.notifyUserId);
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.notificationMessage != nil){
		[aCoder encodeObject:self.notificationMessage forKey:kNotificationDataNotificationMessage];
	}
	if(self.notifyCreatedAt != nil){
		[aCoder encodeObject:self.notifyCreatedAt forKey:kNotificationDataNotifyCreatedAt];
	}
	[aCoder encodeObject:@(self.notifyId) forKey:kNotificationDataNotifyId];	[aCoder encodeObject:@(self.notifyRead) forKey:kNotificationDataNotifyRead];	[aCoder encodeObject:@(self.notifyStatus) forKey:kNotificationDataNotifyStatus];	if(self.notifyTitle != nil){
		[aCoder encodeObject:self.notifyTitle forKey:kNotificationDataNotifyTitle];
	}
	[aCoder encodeObject:@(self.notifyType) forKey:kNotificationDataNotifyType];	if(self.notifyUpdatedAt != nil){
		[aCoder encodeObject:self.notifyUpdatedAt forKey:kNotificationDataNotifyUpdatedAt];
	}
	[aCoder encodeObject:@(self.notifyUserId) forKey:kNotificationDataNotifyUserId];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.notificationMessage = [aDecoder decodeObjectForKey:kNotificationDataNotificationMessage];
	self.notifyCreatedAt = [aDecoder decodeObjectForKey:kNotificationDataNotifyCreatedAt];
	self.notifyId = [[aDecoder decodeObjectForKey:kNotificationDataNotifyId] integerValue];
	self.notifyRead = [[aDecoder decodeObjectForKey:kNotificationDataNotifyRead] integerValue];
	self.notifyStatus = [[aDecoder decodeObjectForKey:kNotificationDataNotifyStatus] integerValue];
	self.notifyTitle = [aDecoder decodeObjectForKey:kNotificationDataNotifyTitle];
	self.notifyType = [[aDecoder decodeObjectForKey:kNotificationDataNotifyType] integerValue];
	self.notifyUpdatedAt = [aDecoder decodeObjectForKey:kNotificationDataNotifyUpdatedAt];
	self.notifyUserId = [[aDecoder decodeObjectForKey:kNotificationDataNotifyUserId] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NotificationData *copy = [NotificationData new];

	copy.notificationMessage = [self.notificationMessage copy];
	copy.notifyCreatedAt = [self.notifyCreatedAt copy];
	copy.notifyId = self.notifyId;
	copy.notifyRead = self.notifyRead;
	copy.notifyStatus = self.notifyStatus;
	copy.notifyTitle = [self.notifyTitle copy];
	copy.notifyType = self.notifyType;
	copy.notifyUpdatedAt = [self.notifyUpdatedAt copy];
	copy.notifyUserId = self.notifyUserId;

	return copy;
}
@end
