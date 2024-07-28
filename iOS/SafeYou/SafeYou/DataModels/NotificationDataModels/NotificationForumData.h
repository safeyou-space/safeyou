//
//  NotificationForumData.h
//  SafeYou
//
//  Created by Edgar on 22.02.24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef NotificationForumData_h
#define NotificationForumData_h

@interface NotificationForumData : NSObject

@property (nonatomic, assign) NSNumber *forumId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, strong) NSString * createdAt;

@property (nonatomic) NSString *formattedCreatedDate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

#endif /* NotificationForumData_h */
