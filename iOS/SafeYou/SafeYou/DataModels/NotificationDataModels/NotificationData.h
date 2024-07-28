#import <UIKit/UIKit.h>
#import "NotificationMessage.h"
#import "NotificationForumData.h"
#import "NotificationDashboardMessage.h"

@interface NotificationData : NSObject

@property (nonatomic, strong) NotificationMessage * notificationMessage;
@property (nonatomic, strong) NSString * notifyCreatedAt;
@property (nonatomic, assign) NSNumber *notifyId;
@property (nonatomic, assign) NSInteger notifyRead;
@property (nonatomic, assign) NSInteger notifyStatus;
@property (nonatomic, strong) NSString * notifyTitle;
@property (nonatomic, assign) NSInteger notifyType;
@property (nonatomic, strong) NSString * notifyUpdatedAt;
@property (nonatomic, assign) NSInteger notifyUserId;
@property (nonatomic, strong) NotificationForumData * forumData;
@property (nonatomic, strong) NotificationDashboardMessage * notificationDashboardMessage;

@property (nonatomic) NSString *formattedCreatedDate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
