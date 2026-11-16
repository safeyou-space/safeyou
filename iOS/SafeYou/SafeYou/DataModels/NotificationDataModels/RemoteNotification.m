//
//  RemoteNotification.m
//  SafeYou
//
//  Created by Edgar on 09.03.24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "RemoteNotification.h"

NSString *const kNotificationId = @"forum_id";
NSString *const kNotificationType = @"notify_type";
NSString *const kNotificationNotifyId = @"notify_id";
NSString *const kNotificationMessageParrentId = @"message_parent_id";
NSString *const kNotificationMessageForumId = @"message_forum_id";


@interface RemoteNotification ()

@end

@implementation RemoteNotification

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if(![dictionary[kNotificationId] isKindOfClass:[NSNull class]]){
        self.forumId = dictionary[kNotificationId];
    }
    if(![dictionary[kNotificationType] isKindOfClass:[NSNull class]]){
        self.notifyType = [dictionary[kNotificationType] integerValue];
    }
    if(![dictionary[kNotificationNotifyId] isKindOfClass:[NSNull class]]){
        self.notifyId = dictionary[kNotificationNotifyId];
    }
    if(![dictionary[kNotificationMessageParrentId] isKindOfClass:[NSNull class]]){
        self.messageParentId = [dictionary[kNotificationMessageParrentId] integerValue];
    }
    if(![dictionary[kNotificationMessageForumId] isKindOfClass:[NSNull class]]){
        self.messageForumId = dictionary[kNotificationMessageForumId];
    }

    return self;
}

@end

