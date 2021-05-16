//
//  EmergencyServicesListDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class EmergencyServiceDataModel;

@interface EmergencyServiceTypes : BaseDataModel

@property (nonatomic) NSString *ngo;
@property (nonatomic) NSString *volunteer;
@property (nonatomic) NSString *legalService;

@end

@class EmergencyServiceDataModel;

@interface EmergencyServicesListDataModel : BaseDataModel

- (NSArray  <EmergencyServiceDataModel *> *)servicesForcategoryId:(NSString *)categoryId;

@property (nonatomic, strong) NSArray  <EmergencyServiceDataModel *>*emergnecyServices;

+ (EmergencyServiceTypes *)serviceType;



@end
