//
//  NotificationDashboardMessage.h
//  SafeYou
//
//  Created by Edgar on 27.02.24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#ifndef NotificationDashboardMessage_h
#define NotificationDashboardMessage_h

@interface NotificationDashboardMessage : NSObject

@property (nonatomic, strong) NSString * message;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

#endif /* NotificationDashboardMessage_h */
