//
//  RoomDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/17/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
#import "ChatUserDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomDataModel : BaseDataModel

/**
 "room_created_at" = "2021-11-08T19:00:07.000Z";
 "room_id" = 73;
 "room_image" = "http://136.244.117.119:88/upload/images/forums/26a96adb742656c6f0258ac11bb50718.png";
 "room_is_owner" = 0;
 "room_joined_users" =         (
 );
 "room_key" = "PUBLIC_GROUP_29";
 "room_last_message" = "<null>";
 "room_members" =         (
 );
 "room_name" = "FORUM_29";
 "room_target_data" =         {
 };
 "room_type" = 3;
 "room_updated_at" = "2021-11-08T19:00:07.000Z";
 */
@property (nonatomic) NSString *creationDateString;
@property (nonatomic) NSNumber *roomId;
@property (nonatomic) NSString *roomImageUrl;
@property (nonatomic) BOOL roomIsOwner;
@property (nonatomic) NSArray *roomJoinedUsers;
@property (nonatomic) NSString *roomKey;
@property (nonatomic) NSString *roomLastMessage;
@property (nonatomic) NSArray <ChatUserDataModel *> *roomMembers;
@property (nonatomic) NSString *roomName;
@property (nonatomic) id roomTargetData;
@property (nonatomic) RoomType roomType;
@property (nonatomic) NSString *roomUpdatedDate;

- (ChatUserDataModel *)getOtherMember;

//viewmodel

@property (nonatomic) NSString *formattedUpdatedDate;
@property (nonatomic) NSString *formattedCreatedDate;

@end

NS_ASSUME_NONNULL_END
