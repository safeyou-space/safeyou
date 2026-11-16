//
//	NotificationMessage.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NotificationMessage.h"
#import "SafeYou-Swift.h"

NSString *const kNotificationMessageMessageContent = @"message_content";
NSString *const kNotificationMessageMessageCreatedAt = @"message_created_at";
NSString *const kNotificationMessageMessageEditBy = @"message_edit_by";
NSString *const kNotificationMessageMessageFiles = @"message_files";
NSString *const kNotificationMessageMessageForumId = @"message_forum_id";
NSString *const kNotificationMessageMessageId = @"message_id";
NSString *const kNotificationMessageMessageIsOwner = @"message_is_owner";
NSString *const kNotificationMessageMessageLikes = @"message_likes";
NSString *const kNotificationMessageMessageMentionOptions = @"message_mention_options";
NSString *const kNotificationMessageMessageParentId = @"message_parent_id";
NSString *const kNotificationMessageMessageReceivers = @"message_receivers";
NSString *const kNotificationMessageMessageRepliedMessageId = @"message_replied_message_id";
NSString *const kNotificationMessageMessageReplies = @"message_replies";
NSString *const kNotificationMessageMessageRoomId = @"message_room_id";
NSString *const kNotificationMessageMessageRoomKey = @"message_room_key";
NSString *const kNotificationMessageMessageType = @"message_type";
NSString *const kNotificationMessageMessageUpdatedAt = @"message_updated_at";
NSString *const kNotificationMessageNotificationMessageUser = @"message_send_by";

@interface NotificationMessage ()
@end
@implementation NotificationMessage




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    NSDictionary *userDict = nilOrJSONObjectForKey(dictionary, kNotificationMessageNotificationMessageUser);
    if (userDict) {
        self.user = [[NotificationMessageUser alloc] initWithDictionary:userDict];
    } else {
        return nil;
    }
	if(![dictionary[kNotificationMessageMessageContent] isKindOfClass:[NSNull class]]){
		self.messageContent = dictionary[kNotificationMessageMessageContent];
	}	
	if(![dictionary[kNotificationMessageMessageCreatedAt] isKindOfClass:[NSNull class]]){
		self.messageCreatedAt = dictionary[kNotificationMessageMessageCreatedAt];
	}	
	if(![dictionary[kNotificationMessageMessageEditBy] isKindOfClass:[NSNull class]]){
		self.messageEditBy = dictionary[kNotificationMessageMessageEditBy];
	}	
	if(![dictionary[kNotificationMessageMessageFiles] isKindOfClass:[NSNull class]]){
		self.messageFiles = dictionary[kNotificationMessageMessageFiles];
	}	
	if(![dictionary[kNotificationMessageMessageForumId] isKindOfClass:[NSNull class]]){
		self.messageForumId = dictionary[kNotificationMessageMessageForumId];
	}

	if(![dictionary[kNotificationMessageMessageId] isKindOfClass:[NSNull class]]){
		self.messageId = [dictionary[kNotificationMessageMessageId] integerValue];
	}

	if(![dictionary[kNotificationMessageMessageIsOwner] isKindOfClass:[NSNull class]]){
		self.messageIsOwner = [dictionary[kNotificationMessageMessageIsOwner] integerValue];
	}

	if(![dictionary[kNotificationMessageMessageLikes] isKindOfClass:[NSNull class]]){
		self.messageLikes = dictionary[kNotificationMessageMessageLikes];
	}	
	if(![dictionary[kNotificationMessageMessageMentionOptions] isKindOfClass:[NSNull class]]){
		self.messageMentionOptions = dictionary[kNotificationMessageMessageMentionOptions];
	}	
	if(![dictionary[kNotificationMessageMessageParentId] isKindOfClass:[NSNull class]]){
		self.messageParentId = [dictionary[kNotificationMessageMessageParentId] integerValue];
	}

	if(![dictionary[kNotificationMessageMessageReceivers] isKindOfClass:[NSNull class]]){
		self.messageReceivers = dictionary[kNotificationMessageMessageReceivers];
	}	
	if(![dictionary[kNotificationMessageMessageRepliedMessageId] isKindOfClass:[NSNull class]]){
		self.messageRepliedMessageId = [dictionary[kNotificationMessageMessageRepliedMessageId] integerValue];
	}

	if(![dictionary[kNotificationMessageMessageReplies] isKindOfClass:[NSNull class]]){
		self.messageReplies = dictionary[kNotificationMessageMessageReplies];
	}	
	if(![dictionary[kNotificationMessageMessageRoomId] isKindOfClass:[NSNull class]]){
		self.messageRoomId = [dictionary[kNotificationMessageMessageRoomId] integerValue];
	}

	if(![dictionary[kNotificationMessageMessageRoomKey] isKindOfClass:[NSNull class]]){
		self.messageRoomKey = dictionary[kNotificationMessageMessageRoomKey];
	}	
	if(![dictionary[kNotificationMessageMessageType] isKindOfClass:[NSNull class]]){
		self.messageType = [dictionary[kNotificationMessageMessageType] integerValue];
	}

	if(![dictionary[kNotificationMessageMessageUpdatedAt] isKindOfClass:[NSNull class]]){
		self.messageUpdatedAt = dictionary[kNotificationMessageMessageUpdatedAt];
	}
    
    self.formattedCreatedDate = [Helper formatDateToShowWithInitialDateString:self.messageCreatedAt];
    self.formattedUpdatedDate = [Helper formatDateToShowWithInitialDateString:self.messageUpdatedAt];

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.messageContent != nil){
		dictionary[kNotificationMessageMessageContent] = self.messageContent;
	}
	if(self.messageCreatedAt != nil){
		dictionary[kNotificationMessageMessageCreatedAt] = self.messageCreatedAt;
	}
	if(self.messageEditBy != nil){
		dictionary[kNotificationMessageMessageEditBy] = self.messageEditBy;
	}
	if(self.messageFiles != nil){
		dictionary[kNotificationMessageMessageFiles] = self.messageFiles;
	}
	dictionary[kNotificationMessageMessageForumId] = self.messageForumId;
	dictionary[kNotificationMessageMessageId] = @(self.messageId);
	dictionary[kNotificationMessageMessageIsOwner] = @(self.messageIsOwner);
	if(self.messageLikes != nil){
		dictionary[kNotificationMessageMessageLikes] = self.messageLikes;
	}
	if(self.messageMentionOptions != nil){
		dictionary[kNotificationMessageMessageMentionOptions] = self.messageMentionOptions;
	}
	dictionary[kNotificationMessageMessageParentId] = @(self.messageParentId);
	if(self.messageReceivers != nil){
		dictionary[kNotificationMessageMessageReceivers] = self.messageReceivers;
	}
	dictionary[kNotificationMessageMessageRepliedMessageId] = @(self.messageRepliedMessageId);
	if(self.messageReplies != nil){
		dictionary[kNotificationMessageMessageReplies] = self.messageReplies;
	}
	dictionary[kNotificationMessageMessageRoomId] = @(self.messageRoomId);
	if(self.messageRoomKey != nil){
		dictionary[kNotificationMessageMessageRoomKey] = self.messageRoomKey;
	}
	dictionary[kNotificationMessageMessageType] = @(self.messageType);
	if(self.messageUpdatedAt != nil){
		dictionary[kNotificationMessageMessageUpdatedAt] = self.messageUpdatedAt;
	}
	if(self.user != nil){
		dictionary[kNotificationMessageNotificationMessageUser] = [self.user toDictionary];
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
	if(self.messageContent != nil){
		[aCoder encodeObject:self.messageContent forKey:kNotificationMessageMessageContent];
	}
	if(self.messageCreatedAt != nil){
		[aCoder encodeObject:self.messageCreatedAt forKey:kNotificationMessageMessageCreatedAt];
	}
	if(self.messageEditBy != nil){
		[aCoder encodeObject:self.messageEditBy forKey:kNotificationMessageMessageEditBy];
	}
	if(self.messageFiles != nil){
		[aCoder encodeObject:self.messageFiles forKey:kNotificationMessageMessageFiles];
	}
	[aCoder encodeObject:self.messageForumId forKey:kNotificationMessageMessageForumId];	[aCoder encodeObject:@(self.messageId) forKey:kNotificationMessageMessageId];	[aCoder encodeObject:@(self.messageIsOwner) forKey:kNotificationMessageMessageIsOwner];	if(self.messageLikes != nil){
		[aCoder encodeObject:self.messageLikes forKey:kNotificationMessageMessageLikes];
	}
	if(self.messageMentionOptions != nil){
		[aCoder encodeObject:self.messageMentionOptions forKey:kNotificationMessageMessageMentionOptions];
	}
	[aCoder encodeObject:@(self.messageParentId) forKey:kNotificationMessageMessageParentId];	if(self.messageReceivers != nil){
		[aCoder encodeObject:self.messageReceivers forKey:kNotificationMessageMessageReceivers];
	}
	[aCoder encodeObject:@(self.messageRepliedMessageId) forKey:kNotificationMessageMessageRepliedMessageId];	if(self.messageReplies != nil){
		[aCoder encodeObject:self.messageReplies forKey:kNotificationMessageMessageReplies];
	}
	[aCoder encodeObject:@(self.messageRoomId) forKey:kNotificationMessageMessageRoomId];	if(self.messageRoomKey != nil){
		[aCoder encodeObject:self.messageRoomKey forKey:kNotificationMessageMessageRoomKey];
	}
	[aCoder encodeObject:@(self.messageType) forKey:kNotificationMessageMessageType];	if(self.messageUpdatedAt != nil){
		[aCoder encodeObject:self.messageUpdatedAt forKey:kNotificationMessageMessageUpdatedAt];
	}
	if(self.user != nil){
		[aCoder encodeObject:self.user forKey:kNotificationMessageNotificationMessageUser];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.messageContent = [aDecoder decodeObjectForKey:kNotificationMessageMessageContent];
	self.messageCreatedAt = [aDecoder decodeObjectForKey:kNotificationMessageMessageCreatedAt];
	self.messageEditBy = [aDecoder decodeObjectForKey:kNotificationMessageMessageEditBy];
	self.messageFiles = [aDecoder decodeObjectForKey:kNotificationMessageMessageFiles];
	self.messageForumId = [aDecoder decodeObjectForKey:kNotificationMessageMessageForumId];
	self.messageId = [[aDecoder decodeObjectForKey:kNotificationMessageMessageId] integerValue];
	self.messageIsOwner = [[aDecoder decodeObjectForKey:kNotificationMessageMessageIsOwner] integerValue];
	self.messageLikes = [aDecoder decodeObjectForKey:kNotificationMessageMessageLikes];
	self.messageMentionOptions = [aDecoder decodeObjectForKey:kNotificationMessageMessageMentionOptions];
	self.messageParentId = [[aDecoder decodeObjectForKey:kNotificationMessageMessageParentId] integerValue];
	self.messageReceivers = [aDecoder decodeObjectForKey:kNotificationMessageMessageReceivers];
	self.messageRepliedMessageId = [[aDecoder decodeObjectForKey:kNotificationMessageMessageRepliedMessageId] integerValue];
	self.messageReplies = [aDecoder decodeObjectForKey:kNotificationMessageMessageReplies];
	self.messageRoomId = [[aDecoder decodeObjectForKey:kNotificationMessageMessageRoomId] integerValue];
	self.messageRoomKey = [aDecoder decodeObjectForKey:kNotificationMessageMessageRoomKey];
	self.messageType = [[aDecoder decodeObjectForKey:kNotificationMessageMessageType] integerValue];
	self.messageUpdatedAt = [aDecoder decodeObjectForKey:kNotificationMessageMessageUpdatedAt];
	self.user = [aDecoder decodeObjectForKey:kNotificationMessageNotificationMessageUser];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NotificationMessage *copy = [NotificationMessage new];

	copy.messageContent = [self.messageContent copy];
	copy.messageCreatedAt = [self.messageCreatedAt copy];
	copy.messageEditBy = [self.messageEditBy copy];
	copy.messageFiles = [self.messageFiles copy];
	copy.messageForumId = self.messageForumId;
	copy.messageId = self.messageId;
	copy.messageIsOwner = self.messageIsOwner;
	copy.messageLikes = [self.messageLikes copy];
	copy.messageMentionOptions = [self.messageMentionOptions copy];
	copy.messageParentId = self.messageParentId;
	copy.messageReceivers = [self.messageReceivers copy];
	copy.messageRepliedMessageId = self.messageRepliedMessageId;
	copy.messageReplies = [self.messageReplies copy];
	copy.messageRoomId = self.messageRoomId;
	copy.messageRoomKey = [self.messageRoomKey copy];
	copy.messageType = self.messageType;
	copy.messageUpdatedAt = [self.messageUpdatedAt copy];
	copy.user = [self.user copy];

	return copy;
}

@end
