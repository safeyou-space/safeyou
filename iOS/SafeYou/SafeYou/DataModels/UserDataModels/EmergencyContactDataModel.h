//
//  EmergencyContactDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@interface EmergencyContactDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *emergencyContactId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *createdAt;



@end
