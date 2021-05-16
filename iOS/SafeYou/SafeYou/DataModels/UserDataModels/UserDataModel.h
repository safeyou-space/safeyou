//
//  UserDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
#import "HelpMessageDataModel.h"

@class ImageDataModel, RecordDataModel, EmergencyContactDataModel, EmergencyServiceDataModel, UserConsultantRequestDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface UserDataModel : BaseDataModel

@property (nonatomic, assign) BOOL isVerifyingOtp;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) ImageDataModel *image;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *imageId;
@property (nonatomic, assign) BOOL checkPolice;
@property (nonatomic, strong) NSString *emergencyMessage;
@property (nonatomic, strong) RecordDataModel *records;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *maritalStatus;

@property (nonatomic) HelpMessageDataModel *helpMessagData;

// Emergency Contacts and Services

@property (nonatomic, strong) NSArray <EmergencyContactDataModel *>*emergencyContacts;
@property (nonatomic, strong) NSArray <EmergencyServiceDataModel *>*emergencyServices;

@property (nonatomic) BOOL isConsultant;
@property (nonatomic) UserConsultantRequestDataModel * _Nullable currentConsultantRequest;

- (BOOL)containsService:(NSString *)serviceId;
- (EmergencyServiceDataModel *)userServiceForServiceId:(NSString *)serviceId;

@end

NS_ASSUME_NONNULL_END
