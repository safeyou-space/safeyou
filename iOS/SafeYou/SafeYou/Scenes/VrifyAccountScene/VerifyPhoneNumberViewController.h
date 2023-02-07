//
//  VerifyPhoneNumberViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VerifyPhoneNumberViewController : SYViewController

@property (nonatomic) BOOL isFromForgotPasswordView;
@property (nonatomic) BOOL isFromEditPhoneNumber;

@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *password;

@end

NS_ASSUME_NONNULL_END
