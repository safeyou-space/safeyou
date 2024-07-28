//
//  ChatMessageDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ChatMessageDataModel.h"
#import "UserDataModel.h"
#import "SafeYou-Swift.h"

@implementation ChatMessageDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];    
    objectOrNilForKey(self.messageContent, dict, @"message_content");
    objectOrNilForKey(self.createdDateString, dict, @"message_created_at");
    objectOrNilForKey(self.editedBy, dict, @"message_edit_by");
    objectOrNilForKey(self.messageFiles, dict, @"message_files");
    objectOrNilForKey(self.messageId, dict, @"message_id");
    objectOrNilForKey(self.roomKey, dict, @"message_room_key");
    boolObjectOrNilForKey(self.isOwner, dict, @"message_is_owner");
    NSDictionary *likesDict = nilOrJSONObjectForKey(dict, @"message_likes");
    self.likes = [self messageLikesFromDict:likesDict];
    self.likesCount = self.likes.count;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userId==%@", [Settings sharedInstance].onlineUser.userId];
    NSArray *filteredArray = [self.likes filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        self.isLiked = YES;
    }
    
    objectOrNilForKey(self.mentionOptions, dict, @"message_mention_options");
    objectOrNilForKey(self.receivers, dict, @"message_receivers");
    objectOrNilForKey(self.roomId, dict, @"message_room_id");
    integerObjectOrNilForKey(self.messageType, dict, @"message_type");
    objectOrNilForKey(self.parentMessageId, dict, @"message_parent_id");
    NSDictionary *messageUserDict = nilOrJSONObjectForKey(dict, @"message_send_by");
    self.sender = [ChatUserDataModel modelObjectWithDictionary:messageUserDict];
    
    integerObjectOrNilForKey(self.messageLevel, dict, @"message_level");
    if (self.messageLevel == 0) {
        NSDictionary *repliesDict = nilOrJSONObjectForKey(dict, @"message_replies");
        self.replies = [self messageRepliesFromDict:repliesDict];
    }
    
    return self;
}

- (BOOL)isMine
{
    return self.sender.userId == [Settings sharedInstance].onlineUser.userId;
}

- (NSArray <MessageLikeDataModel *> *)messageLikesFromDict:(NSDictionary *)messageLikesDict
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *likeObj in messageLikesDict) {
        MessageLikeDataModel *likeData = [MessageLikeDataModel modelObjectWithDictionary:likeObj];
        if (likeData.likeType == 1) {
            [tempArray addObject:likeData];
        }
    }
    return [tempArray copy];
}

- (NSArray <ChatMessageDataModel *> *)messageRepliesFromDict:(NSDictionary *)messageLikesDict
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *messageObj in messageLikesDict) {
        ChatMessageDataModel *messageData = [ChatMessageDataModel modelObjectWithDictionary:messageObj];
        [tempArray addObject:messageData];
    }
    return [tempArray copy];;
}



- (BOOL)isEqual:(ChatMessageDataModel *)other
{
    if (![other isKindOfClass:[ChatMessageDataModel class]]) {
        return NO;
    }
    if (other == self) {
        return YES;
    }
    
    return self.messageId == other.messageId;
}


#pragma mark - Helpter

- (void)setCreatedDateString:(NSString *)createdDateString
{
    _createdDateString = createdDateString;
    self.formattedCreatedDate = [Helper formatDateToShowWithInitialDateString:_createdDateString];
}

- (void)addReplyMessage:(ChatMessageDataModel *)replyMessage
{
    if ([self.replies containsObject:replyMessage]) {
        return;
    }
    NSMutableArray *mReplies = [self.replies mutableCopy];
    [mReplies addObject:replyMessage];
    self.replies = [mReplies copy];
}


@end
