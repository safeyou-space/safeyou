//
//  ChatUserDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/20/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatUserDataModel : BaseDataModel

typedef NS_ENUM(NSUInteger, ChatUserRole) {
    ChatUserRoleSuperAdmin = 0,
    ChatUserRoleAdmin = 1,
    ChatUserRoleModerator = 2,
    ChatUserRoleEmergency = 3,
    ChatUserRoleConsultant = 4,
    ChatUserRoleUser = 5

};

/**
 {
"user_created_at" = "2021-11-24T21:33:04.000Z";
"user_email" = "<null>";
"user_id" = 456;
"user_image" = "http://136.244.117.119:88/upload/images/users/profiles/users/default_profile.png";
"user_is_owner" = 1;
"user_ngo_name" = "<null>";
"user_online" = 1;
"user_profession" = "<null>";
"user_role" = 5;
"user_role_label" = User;
"user_room_key" = "#ROOM_456_USER";
"user_status" = 1;
"user_updated_at" = "2021-11-24T21:33:04.000Z";
"user_username" = simgg;
}
 */

@property (nonatomic) NSString *createdAtString; //"user_created_at" = "2021-11-24T21:33:04.000Z";
@property (nonatomic) NSString *userEmail; //"user_email" = "<null>";
@property (nonatomic) NSNumber *userId; //"user_id" = 456;
@property (nonatomic) NSURL *avatarUrl; //"user_image" = "http://136.244.117.119:88/upload/images/users/profiles/users/default_profile.png";
//"user_is_owner" = 1;
@property (nonatomic) NSString *ngoName;
@property (nonatomic) NSString *profession;
@property (nonatomic) ChatUserRole role;
@property (nonatomic) NSString *roleLabel;
@property (nonatomic) NSString *roomKey;
@property (nonatomic) BOOL statusActive;
@property (nonatomic) NSString *updateDateString;
@property (nonatomic) NSString *userName;

// room user data
@property (nonatomic) BOOL isRoomOwner;
@property (nonatomic) BOOL isUserOnline;

@end

NS_ASSUME_NONNULL_END
