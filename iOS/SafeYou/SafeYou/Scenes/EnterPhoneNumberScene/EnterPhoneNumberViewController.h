//
//  EnterPhoneNumberViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/24/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

typedef NS_ENUM(NSUInteger, PhoneNumberViewMode) {
    PhoneNumberViewModeLogIn,
    PhoneNumberViewModeRegistration,
    PhoneNumberViewModeForgotPassword
};

NS_ASSUME_NONNULL_BEGIN

@interface EnterPhoneNumberViewController : SYViewController

@property (nonatomic) PhoneNumberViewMode phoneNumberMode;

@end

NS_ASSUME_NONNULL_END
