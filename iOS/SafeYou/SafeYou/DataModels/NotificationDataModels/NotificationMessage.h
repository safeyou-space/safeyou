#import <UIKit/UIKit.h>
#import "NotificationMessageUser.h"

@interface NotificationMessage : NSObject

@property (nonatomic, strong) NSString * messageContent;
@property (nonatomic, strong) NSString * messageCreatedAt;
@property (nonatomic, strong) NSString * messageEditBy;
@property (nonatomic, strong) NSArray * messageFiles;
@property (nonatomic, assign) NSNumber *messageForumId;
@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger messageIsOwner;
@property (nonatomic, strong) NSArray * messageLikes;
@property (nonatomic, strong) NSString * messageMentionOptions;
@property (nonatomic, assign) NSInteger messageParentId;
@property (nonatomic, strong) NSArray * messageReceivers;
@property (nonatomic, assign) NSInteger messageRepliedMessageId;
@property (nonatomic, strong) NSArray * messageReplies;
@property (nonatomic, assign) NSInteger messageRoomId;
@property (nonatomic, strong) NSString * messageRoomKey;
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, strong) NSString * messageUpdatedAt;
@property (nonatomic, strong) NotificationMessageUser * user;

// ViewModel

@property (nonatomic) NSString *formattedCreatedDate;
@property (nonatomic) NSString *formattedUpdatedDate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
