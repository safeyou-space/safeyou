//
//  SYAuthenticationService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/10/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYAuthenticationService.h"
#import "MaritalStatusDataModel.h"

@implementation SYAuthenticationService

/*
 POST
 Registration
 
 endpoint: /registration
 
 @params: {
 "first_name":"Jane",
 "last_name":"Doe",
 "nickname":"jane",
 "email":"user@example.com",
 "phone":"+10000000000",
 "birthday":"05/01/1988",
 "password":"********",
 "confirm_password":"********"
 }
 */

- (void)registerUserWithData:(NSDictionary *)userDataDict withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager POST:@"registration" parameters:userDataDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Login
 endpoint: /login
 @params: {
 "phone":"+10000000000",
 "password":"********"
 }
 */
- (void)loginUserWithPhoneNumber:(NSString *)phoneNumber andPassword:(NSString *)password withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"phone":phoneNumber, @"password":password};
    [self.networkManager POST:@"login" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            [self updateUserAuthToken:responseObject[@"access_token"] refreshToken:responseObject[@"refresh_token"]];
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Verification Phone Number
 endpoint: profile/verify_phone
 @params: {
 "phone":"+10000000000",
 "code":"********"
 }
 */

- (void)verifyPhoneNumber:(NSString *)phoneNumber withCode:(NSString *)verificationCode withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"phone":phoneNumber, @"code":verificationCode};
    [self.networkManager POST:@"verify_phone" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Resend Registration verify code
 endpoint: /resend_verify_code
 @params: {
 "phone":"+10000000000"
 }
 */

- (void)resendVerifyCodeToPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"phone":phoneNumber};
    [self.networkManager POST:@"resend_verify_code" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Forgot Password
 endpoint: /forgot_password
 @params: {
 "phone":"+10000000000"
 }
 */

- (void)sendForgotPasswordWithPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"phone":phoneNumber};
    [self.networkManager POST:@"forgot_password" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/*
 POST
 Forgot Password Verify Code
 endpoint: /forgot_password_verify_code
 @params: {
 "phone":"+10000000000",
 "code":"********"
 }
 */

- (void)verifyForgotPasswordPhoneNumber:(NSString *)phoneNumber withCode:(NSString *)verificationCode withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"phone":phoneNumber, @"code":verificationCode};
    [self.networkManager POST:@"forgot_password_verify_code" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/*
 POST
 Create New Password
 endpoint: /create_password
 @params: {
 "password":"********",
 "confirm_password":"********",
 "token":"********",
 "phone":"+10000000000"
 }
 */

- (void)createNewpassowrd:(NSString *)password confirm:(NSString *)confirmPassowrd token:(NSString *)token andPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"password":password,
                             @"confirm_password":confirmPassowrd,
                             @"token":token,
                             @"phone":phoneNumber};
    [self.networkManager POST:@"create_password" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/*
 POST
 Refresh Token
 endpoint: /refresh
 @params:{
 "refresh_token":"********"
 }
 */

- (void)refreshToken:(NSString *)token withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"refresh_token":token};
    weakify(self);
    [self.networkManager POST:@"refresh" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            strongify(self);
            [self updateUserAuthToken:responseObject[@"access_token"] refreshToken:responseObject[@"refresh_token"]];
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Change Password
 endpoint: /change_password
 @params: {
 "old_password":"********",
 "password":"********",
 "confirm_password":"********"
 }
 */

- (void)changePassowrd:(NSString *)oldPassword withNewPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"old_password":oldPassword,
                             @"password":newPassword,
                             @"confirm_password":confirmPassword};
    [self.networkManager POST:@"profile/change_password" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 endpoint: /logout
 Logout
 */

- (void)logoutUserWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager POST:@"logout" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 GET
 endpoint: marital_status/list
 Get marital statuses
 
 */

- (void)getMaritalStatusesWithComplition:(void(^)(NSArray <MaritalStatusDataModel *> * response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:@"marital_statuses" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *maritalDataArray = [[NSMutableArray alloc] init];
        NSAssert([responseObject isKindOfClass:[NSArray class]], @"MARITAL STATUS LIST MUST BE ARRAY TYPE!!!");
        for (NSDictionary *maritalStatusDict in responseObject) {
            MaritalStatusDataModel *maritalStatusData = [MaritalStatusDataModel modelObjectWithDictionary:maritalStatusDict];
            [maritalDataArray addObject:maritalStatusData];
        }
        if (complition) {
            complition(maritalDataArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma  mark - Private

- (void)updateUserAuthToken:(NSString *)userAuthToken refreshToken:(NSString *)refreshToken
{
    [Settings sharedInstance].userAuthToken = userAuthToken;
    [Settings sharedInstance].userRefreshToken = refreshToken;
}

@end
