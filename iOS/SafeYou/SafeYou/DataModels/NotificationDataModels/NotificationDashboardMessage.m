//
//  NotificationDashboardMessage.m
//  SafeYou
//
//  Created by Edgar on 27.02.24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "NotificationDashboardMessage.h"

NSString *const kNotificationDashboardMessageContent = @"message_content";


@interface NotificationDashboardMessage ()

@end

@implementation NotificationDashboardMessage

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(![dictionary[kNotificationDashboardMessageContent] isKindOfClass:[NSNull class]]){
        self.message = dictionary[kNotificationDashboardMessageContent];
    }
    
    return self;
}

@end
