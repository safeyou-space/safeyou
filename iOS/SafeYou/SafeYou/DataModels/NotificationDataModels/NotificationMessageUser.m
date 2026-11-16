//
//	NotificationMessageUser.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NotificationMessageUser.h"

NSString *const kNotificationMessageUserUserCreatedAt = @"user_created_at";
NSString *const kNotificationMessageUserUserEmail = @"user_email";
NSString *const kNotificationMessageUserUserId = @"user_id";
NSString *const kNotificationMessageUserUserImage = @"user_image";
NSString *const kNotificationMessageUserUserNgoName = @"user_ngo_name";
NSString *const kNotificationMessageUserUserProfession = @"user_profession";
NSString *const kNotificationMessageUserUserRole = @"user_role";
NSString *const kNotificationMessageUserUserRoleLabel = @"user_role_label";
NSString *const kNotificationMessageUserUserRoomKey = @"user_room_key";
NSString *const kNotificationMessageUserUserStatus = @"user_status";
NSString *const kNotificationMessageUserUserUpdatedAt = @"user_updated_at";
NSString *const kNotificationMessageUserUserUsername = @"user_username";

@interface NotificationMessageUser ()
@end
@implementation NotificationMessageUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNotificationMessageUserUserCreatedAt] isKindOfClass:[NSNull class]]){
		self.userCreatedAt = dictionary[kNotificationMessageUserUserCreatedAt];
	}	
	if(![dictionary[kNotificationMessageUserUserEmail] isKindOfClass:[NSNull class]]){
		self.userEmail = dictionary[kNotificationMessageUserUserEmail];
	}	
	if(![dictionary[kNotificationMessageUserUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kNotificationMessageUserUserId] integerValue];
	}

	if(![dictionary[kNotificationMessageUserUserImage] isKindOfClass:[NSNull class]]){
		self.userImage = dictionary[kNotificationMessageUserUserImage];
	}	
	if(![dictionary[kNotificationMessageUserUserNgoName] isKindOfClass:[NSNull class]]){
		self.userNgoName = dictionary[kNotificationMessageUserUserNgoName];
	}	
	if(![dictionary[kNotificationMessageUserUserProfession] isKindOfClass:[NSNull class]]){
		self.userProfession = dictionary[kNotificationMessageUserUserProfession];
	}	
	if(![dictionary[kNotificationMessageUserUserRole] isKindOfClass:[NSNull class]]){
		self.userRole = [dictionary[kNotificationMessageUserUserRole] integerValue];
	}

	if(![dictionary[kNotificationMessageUserUserRoleLabel] isKindOfClass:[NSNull class]]){
		self.userRoleLabel = dictionary[kNotificationMessageUserUserRoleLabel];
	}	
	if(![dictionary[kNotificationMessageUserUserRoomKey] isKindOfClass:[NSNull class]]){
		self.userRoomKey = dictionary[kNotificationMessageUserUserRoomKey];
	}	
	if(![dictionary[kNotificationMessageUserUserStatus] isKindOfClass:[NSNull class]]){
		self.userStatus = [dictionary[kNotificationMessageUserUserStatus] integerValue];
	}

	if(![dictionary[kNotificationMessageUserUserUpdatedAt] isKindOfClass:[NSNull class]]){
		self.userUpdatedAt = dictionary[kNotificationMessageUserUserUpdatedAt];
	}	
	if(![dictionary[kNotificationMessageUserUserUsername] isKindOfClass:[NSNull class]]){
		self.userUsername = dictionary[kNotificationMessageUserUserUsername];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.userCreatedAt != nil){
		dictionary[kNotificationMessageUserUserCreatedAt] = self.userCreatedAt;
	}
	if(self.userEmail != nil){
		dictionary[kNotificationMessageUserUserEmail] = self.userEmail;
	}
	dictionary[kNotificationMessageUserUserId] = @(self.userId);
	if(self.userImage != nil){
		dictionary[kNotificationMessageUserUserImage] = self.userImage;
	}
	if(self.userNgoName != nil){
		dictionary[kNotificationMessageUserUserNgoName] = self.userNgoName;
	}
	if(self.userProfession != nil){
		dictionary[kNotificationMessageUserUserProfession] = self.userProfession;
	}
	dictionary[kNotificationMessageUserUserRole] = @(self.userRole);
	if(self.userRoleLabel != nil){
		dictionary[kNotificationMessageUserUserRoleLabel] = self.userRoleLabel;
	}
	if(self.userRoomKey != nil){
		dictionary[kNotificationMessageUserUserRoomKey] = self.userRoomKey;
	}
	dictionary[kNotificationMessageUserUserStatus] = @(self.userStatus);
	if(self.userUpdatedAt != nil){
		dictionary[kNotificationMessageUserUserUpdatedAt] = self.userUpdatedAt;
	}
	if(self.userUsername != nil){
		dictionary[kNotificationMessageUserUserUsername] = self.userUsername;
	}
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
	if(self.userCreatedAt != nil){
		[aCoder encodeObject:self.userCreatedAt forKey:kNotificationMessageUserUserCreatedAt];
	}
	if(self.userEmail != nil){
		[aCoder encodeObject:self.userEmail forKey:kNotificationMessageUserUserEmail];
	}
	[aCoder encodeObject:@(self.userId) forKey:kNotificationMessageUserUserId];	if(self.userImage != nil){
		[aCoder encodeObject:self.userImage forKey:kNotificationMessageUserUserImage];
	}
	if(self.userNgoName != nil){
		[aCoder encodeObject:self.userNgoName forKey:kNotificationMessageUserUserNgoName];
	}
	if(self.userProfession != nil){
		[aCoder encodeObject:self.userProfession forKey:kNotificationMessageUserUserProfession];
	}
	[aCoder encodeObject:@(self.userRole) forKey:kNotificationMessageUserUserRole];	if(self.userRoleLabel != nil){
		[aCoder encodeObject:self.userRoleLabel forKey:kNotificationMessageUserUserRoleLabel];
	}
	if(self.userRoomKey != nil){
		[aCoder encodeObject:self.userRoomKey forKey:kNotificationMessageUserUserRoomKey];
	}
	[aCoder encodeObject:@(self.userStatus) forKey:kNotificationMessageUserUserStatus];	if(self.userUpdatedAt != nil){
		[aCoder encodeObject:self.userUpdatedAt forKey:kNotificationMessageUserUserUpdatedAt];
	}
	if(self.userUsername != nil){
		[aCoder encodeObject:self.userUsername forKey:kNotificationMessageUserUserUsername];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.userCreatedAt = [aDecoder decodeObjectForKey:kNotificationMessageUserUserCreatedAt];
	self.userEmail = [aDecoder decodeObjectForKey:kNotificationMessageUserUserEmail];
	self.userId = [[aDecoder decodeObjectForKey:kNotificationMessageUserUserId] integerValue];
	self.userImage = [aDecoder decodeObjectForKey:kNotificationMessageUserUserImage];
	self.userNgoName = [aDecoder decodeObjectForKey:kNotificationMessageUserUserNgoName];
	self.userProfession = [aDecoder decodeObjectForKey:kNotificationMessageUserUserProfession];
	self.userRole = [[aDecoder decodeObjectForKey:kNotificationMessageUserUserRole] integerValue];
	self.userRoleLabel = [aDecoder decodeObjectForKey:kNotificationMessageUserUserRoleLabel];
	self.userRoomKey = [aDecoder decodeObjectForKey:kNotificationMessageUserUserRoomKey];
	self.userStatus = [[aDecoder decodeObjectForKey:kNotificationMessageUserUserStatus] integerValue];
	self.userUpdatedAt = [aDecoder decodeObjectForKey:kNotificationMessageUserUserUpdatedAt];
	self.userUsername = [aDecoder decodeObjectForKey:kNotificationMessageUserUserUsername];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NotificationMessageUser *copy = [NotificationMessageUser new];

	copy.userCreatedAt = [self.userCreatedAt copy];
	copy.userEmail = [self.userEmail copy];
	copy.userId = self.userId;
	copy.userImage = [self.userImage copy];
	copy.userNgoName = [self.userNgoName copy];
	copy.userProfession = [self.userProfession copy];
	copy.userRole = self.userRole;
	copy.userRoleLabel = [self.userRoleLabel copy];
	copy.userRoomKey = [self.userRoomKey copy];
	copy.userStatus = self.userStatus;
	copy.userUpdatedAt = [self.userUpdatedAt copy];
	copy.userUsername = [self.userUsername copy];

	return copy;
}
@end