//
//  RemoteNotification.h
//  SafeYou
//
//  Created by Edgar on 09.03.24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#ifndef RemoteNotification_h
#define RemoteNotification_h

@interface RemoteNotification : NSObject

@property (nonatomic, assign) NSNumber *forumId;
@property (nonatomic, assign) NSNumber *notifyId;
@property (nonatomic, assign) NSInteger notifyType;
@property (nonatomic, assign) NSInteger messageParentId;
@property (nonatomic, assign) NSNumber *messageForumId;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

#endif /* RemoteNotification_h */
