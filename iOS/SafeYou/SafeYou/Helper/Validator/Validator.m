//
//  Validator.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//


#import "Validator.h"
#import "Constants.h"
#import "Utilities.h"


@interface Validator()

@property (nonatomic, assign) ValidatorType validatorType;

@end


@implementation Validator


#pragma mark - Private Methods

- (NSError *)validateEmail:(NSString *)email
{
    NSError *error = nil;
    
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : LOC(@"please_enter_valid_email_message_key")};
        error = [[NSError alloc] initWithDomain:VALIDATION_DOMAIN code:0 userInfo:errorDictionary];
    }
    
    return error;
}

- (NSError *)validPhoneNumber:(NSString *)phoneNumber
{
    NSError *error = nil;
    if (phoneNumber.length < 5) {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : LOC(@"please_enter_valid_number_message_key")};
        error = [[NSError alloc] initWithDomain:VALIDATION_DOMAIN code:0 userInfo:errorDictionary];
    }
    return error;
}

- (NSError *)validatePassword:(NSString *)password
{
    BOOL isValidePassword = NO;
    if(password.length >= kPasswordLenght) {
        NSString *trimmed = [password stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSCharacterSet *lowerCaseSet = [NSCharacterSet lowercaseLetterCharacterSet];
        NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
        NSCharacterSet *decimalDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
        
        if ([password length] - [trimmed length] == 0 && [trimmed rangeOfCharacterFromSet:decimalDigitCharacterSet].location != NSNotFound && [trimmed rangeOfCharacterFromSet:lowerCaseSet].location != NSNotFound && [trimmed rangeOfCharacterFromSet:upperCaseSet].location != NSNotFound) {
            isValidePassword = YES;
        }
    }
    
    
    NSError *error = nil;
    
    if (!isValidePassword) {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : LOC(@"please_enter_valid_password_message_key")};
        error = [[NSError alloc] initWithDomain:VALIDATION_DOMAIN code:0 userInfo:errorDictionary];
    }
    
    return error;
}

- (NSError *)validateSMSCode:(NSString *)smsCode
{
    NSError *error = nil;
    
    return error;
}

- (NSError *)validatePin:(NSString *)pin
{
    NSError *error = nil;
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([pin length] < kPINLenght) {
        
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : LOC(@"pin_code_credentials_info_key")};
        error = [[NSError alloc] initWithDomain:VALIDATION_DOMAIN code:0 userInfo:errorDictionary];
    }
    else if ([pin rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : LOC(@"pin_code_only_digits_message_key")};
        error = [[NSError alloc] initWithDomain:VALIDATION_DOMAIN code:0 userInfo:errorDictionary];
    }
    
    return error;
}


#pragma mark - Class Methods
+ (instancetype)validatorWithType:(ValidatorType)type
{
    Validator *validator = [Validator new];
    validator.validatorType = type;
    
    return validator;
}


#pragma mark - Instance Methods
- (NSError *)validateValue:(NSString *)value
{
    NSError *error = nil;
    
    switch (self.validatorType) {
        case kEmailValidator:
        {
            error = [self validateEmail:value];
        }
            break;
        case kPhoneNumberValidator:
        {
            error = [self validPhoneNumber:value];
        }
            break;
        case kPasswordValidator:
        {
            error = [self validatePassword:value];
        }
            break;
        case kSMSCodeValidator:
        {
            error = [self validateSMSCode:value];
        }
            break;
        case kPinValidator:
        {
            error = [self validatePin:value];
        }
            break;
        default:
            break;
    }
    
    return error;
}

@end
