//
//  Validator.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//


#import <Foundation/Foundation.h>


#define VALIDATION_DOMAIN   @"com.idram.validator"
#define kPasswordLenght     8
#define kPINLenght     6

#define kInvalidPasswordCode     0
#define kInvalidPhoneNumberCode     1


typedef NS_ENUM(NSInteger, ValidatorType) {
    kDefaultValidator,
    kEmailValidator,
    kPhoneNumberValidator,
    kPasswordValidator,
    kSMSCodeValidator,
    kPinValidator
};


@interface Validator : NSObject

#pragma mark - Class Methods
+ (instancetype)validatorWithType:(ValidatorType)type;

#pragma mark - Instance Methods
- (NSError *)validateValue:(NSString *)value;

@end
