//
//  RegistrationDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/10/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationDataModel : NSObject


@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *nickname;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSNumber *maritalStatus;
@property (nonatomic) NSString *birthDay;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *confirmPassword;

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
