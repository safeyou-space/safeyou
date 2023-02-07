//
//  MessageLikeDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/20/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
#import "ChatUserDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageLikeDataModel : BaseDataModel

/**
 {
"like_created_at" = "2021-11-13T19:39:44.000Z";
"like_id" = 38;
"like_message_id" = 826;
"like_room_id" = 23;
"like_type" = 1;
"like_updated_at" = "2021-11-13T19:39:44.000Z";
"like_user_id" = 5;
"user_created_at" = "2020-05-15T13:44:49.000Z";
"user_email" = "hshs@gmail.com";
"user_id" = 5;
"user_image" = "http://136.244.117.119:88/upload/images/users/profiles/users/default_profile.png";
"user_ngo_name" = "<null>";
"user_profession" = "<null>";
"user_role" = 5;
"user_role_label" = User;
"user_room_key" = "#ROOM_5_USER";
"user_status" = 1;
"user_updated_at" = "2021-11-06T13:30:54.000Z";
"user_username" = zara;
}
 */

@property (nonatomic) NSString *createdDateString;
@property (nonatomic) NSNumber *likeId;
@property (nonatomic) NSNumber *likedMessageId;
@property (nonatomic) NSNumber *likeMessageRoomId;
@property (nonatomic) NSInteger likeType;
@property (nonatomic) NSString *updatedDateString;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) ChatUserDataModel *user;



@end

NS_ASSUME_NONNULL_END
