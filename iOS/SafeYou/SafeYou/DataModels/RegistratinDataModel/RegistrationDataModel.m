//
//  RegistrationDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/10/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RegistrationDataModel.h"

NSString *const kRegistrationFirstName = @"first_name";
NSString *const kRegistrationLastName = @"last_name";
NSString *const kRegistrationNickName = @"nickname";
NSString *const kRegistrationPhoneNumber = @"phone";
NSString *const kRegistrationMaritalStatus = @"marital_status";
NSString *const kRegistrationBirthDay = @"birthday";
NSString *const kRegistrationPassword = @"password";
NSString *const kRegistrationConfirmPassword = @"confirm_password";

@implementation RegistrationDataModel

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    
    if (self.firstName.length >0) {
        [mDict setObject:self.firstName forKey:kRegistrationFirstName];
    }
    if (self.lastName.length >0) {
        [mDict setObject:self.lastName forKey:kRegistrationLastName];
    }
    if (self.nickname.length >0) {
        [mDict setObject:self.nickname forKey:kRegistrationNickName];
    }
    if (self.birthDay.length >0) {
        [mDict setObject:self.birthDay forKey:kRegistrationBirthDay];
    }
    if (self.phoneNumber.length >0) {
        [mDict setObject:self.phoneNumber forKey:kRegistrationPhoneNumber];
    }
    
    if (self.maritalStatus != nil) {
        [mDict setObject:@([self.maritalStatus integerValue]) forKey:kRegistrationMaritalStatus];
    }
    
    if (self.password.length >0) {
        [mDict setObject:self.password forKey:kRegistrationPassword];
    }
    if (self.confirmPassword.length >0) {
        [mDict setObject:self.confirmPassword forKey:kRegistrationConfirmPassword];
    }
    
    return  [NSDictionary dictionaryWithDictionary:mDict];
    
}

@end
