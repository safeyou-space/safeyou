//
//  NotificationForumData.m
//  SafeYou
//
//  Created by Edgar on 22.02.24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "NotificationForumData.h"
#import "SafeYou-Swift.h"

NSString *const kNotificationForumId = @"id";
NSString *const kNotificationForumTitle = @"title";
NSString *const kNotificationForumImage = @"image";
NSString *const kNotificationForumImageUrl = @"url";
NSString *const kNotificationForumCreatedAt = @"created_at";


@interface NotificationForumData ()

@end

@implementation NotificationForumData

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    NSDictionary *imageDict = nilOrJSONObjectForKey(dictionary, kNotificationForumImage);
    
    if(![imageDict[kNotificationForumImageUrl] isKindOfClass:[NSNull class]]){
        self.imageUrl =  [NSString stringWithFormat:@"%@/%@", [Settings sharedInstance].baseResourceURL, imageDict[kNotificationForumImageUrl]];
    }
    if(![dictionary[kNotificationForumTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kNotificationForumTitle];
    }
    if(![dictionary[kNotificationForumCreatedAt] isKindOfClass:[NSNull class]]){
        self.createdAt = dictionary[kNotificationForumCreatedAt];
    }
    if(![dictionary[kNotificationForumId] isKindOfClass:[NSNull class]]){
        self.forumId = dictionary[kNotificationForumId];
    }
    
    self.formattedCreatedDate = [Helper formatDateToShowWithInitialDateString:self.createdAt];

    return self;
}

@end
