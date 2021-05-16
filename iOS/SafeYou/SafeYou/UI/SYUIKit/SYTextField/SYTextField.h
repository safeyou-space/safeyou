//
//  SYTextField.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableTextField.h"

typedef NS_ENUM(NSInteger, SYTextFieldType) {
    LTFT_DefaultType,
    LTFT_EmailType,
    LTFT_PhoneNumberType,
    LTFT_LoginType,
    LTFT_PasswordType,
    LTFT_SMSCodeType,
    LTFT_PinType,
    LTFT_NumberType
};

IB_DESIGNABLE

@interface SYTextField : SYDesignableTextField
@property (nonatomic, assign) SYTextFieldType fieldType;

#pragma mark - Instance Methods
- (NSError *)validateValue;
- (BOOL)hasInput;

@end
