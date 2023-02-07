#import <UIKit/UIKit.h>

@interface NotificationMessageUser : NSObject

@property (nonatomic, strong) NSString * userCreatedAt;
@property (nonatomic, strong) NSString * userEmail;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userImage;
@property (nonatomic, strong) NSString * userNgoName;
@property (nonatomic, strong) NSString * userProfession;
@property (nonatomic, assign) NSInteger userRole;
@property (nonatomic, strong) NSString * userRoleLabel;
@property (nonatomic, strong) NSString * userRoomKey;
@property (nonatomic, assign) NSInteger userStatus;
@property (nonatomic, strong) NSString * userUpdatedAt;
@property (nonatomic, strong) NSString * userUsername;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end