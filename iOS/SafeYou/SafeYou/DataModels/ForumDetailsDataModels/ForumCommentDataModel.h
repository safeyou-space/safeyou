//
//  ForumCommentDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@interface ForumCommentDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *replyId;

// new reply functionality
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, strong) NSString *replyInfo;

// additions to comment data

@property (nonatomic) NSString *consultantId;
@property (nonatomic) NSNumber *groupId;
@property (nonatomic) NSNumber *level;
@property (nonatomic) NSString *serviceId;
@property (nonatomic) NSNumber *userTypeId;

// view model

@property (nonatomic) NSString *formattedCreatedDate;

@end
