//
//  NotificationDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/27/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationDataModel : BaseDataModel


@property (nonatomic, strong) NSString *forumId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *notificationId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *isReaded;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *formattedDateString;

@end

NS_ASSUME_NONNULL_END
