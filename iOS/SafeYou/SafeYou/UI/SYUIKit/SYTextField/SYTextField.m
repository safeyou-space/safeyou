//
//  SYTextField.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYTextField.h"
#import "Validator.h"

@interface SYTextField()

@property (nonatomic, strong) Validator *validator;

@end

@implementation SYTextField

#pragma mark - Properties
- (void)setFieldType:(SYTextFieldType)fieldtype {
    
    _fieldType = fieldtype;
    
    switch (_fieldType) {
        case LTFT_EmailType:
        {
            _validator = [Validator validatorWithType:kEmailValidator];
            self.keyboardType = UIKeyboardTypeEmailAddress;
        }
            break;
        case LTFT_PhoneNumberType:
        {
            _validator = [Validator validatorWithType:kPhoneNumberValidator];
            self.keyboardType = UIKeyboardTypePhonePad;
            
        }
            break;
        case LTFT_PasswordType:
        {
            _validator = [Validator validatorWithType:kPasswordValidator];
            self.keyboardType = UIKeyboardTypeDefault;
            self.secureTextEntry = YES;
        }
            break;
        case LTFT_SMSCodeType:
        {
            _validator = [Validator validatorWithType:kSMSCodeValidator];
            self.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case LTFT_PinType:
        {
            _validator = [Validator validatorWithType:kPinValidator];
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.secureTextEntry = YES;
        }
            break;
        case LTFT_NumberType:
        {
            _validator = [Validator validatorWithType:kDefaultValidator];
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.secureTextEntry = NO;
        }
            break;
        default:
        {
            _validator = [Validator validatorWithType:kDefaultValidator];
            self.keyboardType = UIKeyboardTypeDefault;
        }
            break;
    }
}

#pragma mark - Instance Methods
- (NSError *)validateValue {
    
    NSError *error = nil;
    if (_validator) {
        error = [_validator validateValue:self.text];
    }
    
    return error;
}

- (BOOL)hasInput {
    
    return self.text.length > 0;
}

@end
