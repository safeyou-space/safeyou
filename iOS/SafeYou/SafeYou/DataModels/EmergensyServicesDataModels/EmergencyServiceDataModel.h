//
//  EmergencyServiceDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
#import "UserDetail.h"
@class ImageDataModel, UserDetail;

@interface EmergencyServiceDataModel : BaseDataModel

@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *serviceDescription;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *webAddress;
@property (nonatomic, strong) NSString *webAddressIconUrl;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *serviceAddress;
@property (nonatomic, strong) NSString *serviceAddressImageURL;

@property (nonatomic, strong) NSString *serviceFacebookIconURL;
@property (nonatomic, strong) NSString *serviceFacebookPageURL;
@property (nonatomic, strong) NSString *serviceFacebookPageTitle;

@property (nonatomic, strong) NSString *serviceInstagramIconURL;
@property (nonatomic, strong) NSString *serviceInstagramPageURL;
@property (nonatomic, strong) NSString *serviceInstagramPageTitle;

@property (nonatomic, strong) NSString *emailIconURL;
@property (nonatomic, strong) NSString *phoneIconURL;

@property (nonatomic, strong) NSString *userEmergencyServiceId;
@property (nonatomic, strong) UserDetail *userDetails;

@property (nonatomic, assign) BOOL isAvailableForEmergency;

@property (nonatomic, strong) ImageDataModel *image;


// category

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *localizedCategoryName;




@end
