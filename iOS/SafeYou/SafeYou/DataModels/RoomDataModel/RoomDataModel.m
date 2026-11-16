//
//  RoomDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/17/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "RoomDataModel.h"
#import "ChatUserDataModel.h"
#import "UserDataModel.h"
#import "SafeYou-Swift.h"

@implementation RoomDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        objectOrNilForKey(self.creationDateString, dict,@"room_created_at" );
        objectOrNilForKey(self.roomId, dict, @"room_id");
        objectOrNilForKey(self.roomImageUrl, dict, @"room_image");
        boolObjectOrNilForKey(self.roomIsOwner, dict, @"room_is_owner");
        objectOrNilForKey(self.roomJoinedUsers, dict, @"room_joined_users");
        objectOrNilForKey(self.roomKey, dict, @"room_key");
        objectOrNilForKey(self.roomLastMessage, dict, @"room_last_message");
        NSDictionary *membersDict = nilOrJSONObjectForKey(dict, @"room_members");
        self.roomMembers = [self roomMembersFromDict:membersDict];
        objectOrNilForKey(self.roomName, dict, @"room_name");
        objectOrNilForKey(self.roomTargetData, dict, @"room_target_data");
        integerObjectOrNilForKey(self.roomType, dict, @"room_type");
        objectOrNilForKey(self.roomUpdatedDate, dict, @"room_updated_at");

        NSDictionary *lastMessageDict = nilOrJSONObjectForKey(dict, @"room_last_message");
        objectOrNilForKey(self.roomUpdatedDate, lastMessageDict, @"message_updated_at");
    }
    return self;
}

- (void)setRoomUpdatedDate:(NSString *)roomUpdatedDate
{
    _roomUpdatedDate = roomUpdatedDate;
    self.formattedUpdatedDate = [Helper formatDateToShowWithInitialDateString:_roomUpdatedDate];
}

#pragma mark - Helper

- (NSArray <ChatUserDataModel *> *)roomMembersFromDict:(NSDictionary *)membersDict
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *memberObj in membersDict) {
        ChatUserDataModel *userData = [ChatUserDataModel modelObjectWithDictionary:memberObj];
        [tempArray addObject:userData];
    }
    return [tempArray copy];;
}

- (ChatUserDataModel *)getOtherMember
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId != %@", [Settings sharedInstance].onlineUser.userId];
    NSArray *filteredArray = [self.roomMembers filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}





@end
