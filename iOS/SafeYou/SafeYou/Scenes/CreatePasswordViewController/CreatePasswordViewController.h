//
//  CreatePasswordViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/26/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class RegistrationDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface CreatePasswordViewController : SYViewController

@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *recoveryToken;
@property (nonatomic) BOOL isRecoverFlow;

@end

NS_ASSUME_NONNULL_END
