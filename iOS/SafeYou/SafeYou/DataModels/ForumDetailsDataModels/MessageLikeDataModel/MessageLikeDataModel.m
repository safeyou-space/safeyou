//
//  MessageLikeDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/20/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "MessageLikeDataModel.h"

@implementation MessageLikeDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        objectOrNilForKey(self.createdDateString, dict, @"like_created_at");
        objectOrNilForKey(self.likeId, dict, @"like_id");
        objectOrNilForKey(self.likedMessageId, dict, @"like_message_id");
        objectOrNilForKey(self.likeMessageRoomId, dict, @"like_room_id");
        integerObjectOrNilForKey(self.likeType, dict, @"like_type");
        objectOrNilForKey(self.updatedDateString, dict, @"")
        objectOrNilForKey(self.userId, dict, @"like_user_id");
        self.user = [ChatUserDataModel modelObjectWithDictionary:dict];
    }
    
    return self;
}

@end
