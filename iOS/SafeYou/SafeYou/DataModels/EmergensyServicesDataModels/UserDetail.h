//
//  UserDetail.h
//
//  Created by   on 10/15/19
//  Copyright (c) 2019 __MyCompanyName__. All rights reserved.
//

#import "BaseDataModel.h"

@class ImageDataModel;
@class ProfileQuestionsAnswersDataModel;

@interface UserDetail : BaseDataModel

@property (nonatomic, assign) NSNumber *userDetailId;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) BOOL checkPolice;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) ImageDataModel *image;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *imageId;
@property (nonatomic, assign) BOOL isVerifyingOtp;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *changePhone;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *isAdmin;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *emergencyMessage;
@property (nonatomic, strong) ProfileQuestionsAnswersDataModel *profileQuestionsAnswers;

@end
