//
//  ChatUserDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/20/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ChatUserDataModel.h"

@implementation ChatUserDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
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
        objectOrNilForKey(self.createdAtString, dict, @"user_created_at");
        objectOrNilForKey(self.userEmail, dict, @"user_email");
        objectOrNilForKey(self.userId, dict, @"user_id");
        NSString *avatarUrlString = nilOrJSONObjectForKey(dict, @"user_image");
        self.avatarUrl = [NSURL URLWithString:avatarUrlString];
        objectOrNilForKey(self.ngoName, dict, @"user_ngo_name");
        objectOrNilForKey(self.profession, dict, @"user_profession");
        integerObjectOrNilForKey(self.role, dict, @"user_role");
        objectOrNilForKey(self.roleLabel, dict, @"user_role_label");
        objectOrNilForKey(self.roomKey, dict, @"user_room_key");
        boolObjectOrNilForKey(self.statusActive, dict, @"user_status");
        objectOrNilForKey(self.updateDateString, dict, @"user_updated_at");
        objectOrNilForKey(self.userName, dict, @"user_username");
        
        boolObjectOrNilForKey(self.isRoomOwner, dict, @"user_is_owner");
        boolObjectOrNilForKey(self.isUserOnline, dict, @"user_online");
    }
    
    return self;
}

@end
