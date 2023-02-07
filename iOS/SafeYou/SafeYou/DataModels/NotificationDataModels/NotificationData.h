#import <UIKit/UIKit.h>
#import "NotificationMessage.h"

@interface NotificationData : NSObject

@property (nonatomic, strong) NotificationMessage * notificationMessage;
@property (nonatomic, strong) NSString * notifyCreatedAt;
@property (nonatomic, assign) NSInteger notifyId;
@property (nonatomic, assign) NSInteger notifyRead;
@property (nonatomic, assign) NSInteger notifyStatus;
@property (nonatomic, strong) NSString * notifyTitle;
@property (nonatomic, assign) NSInteger notifyType;
@property (nonatomic, strong) NSString * notifyUpdatedAt;
@property (nonatomic, assign) NSInteger notifyUserId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end