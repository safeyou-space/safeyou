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
 "first_name":"Anna",
 "last_name":"Argutyan",
 "nickname":"ANN",
 "email":"argutyan.fambox@gmail.com",
 "phone":"+37493925600",
 "birthday":"05/01/1988",
 "password":"12345678",
 "confirm_password":"12345678"
 }
 */

- (void)registerUserWithData:(NSDictionary *)userDataDict withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}

/*
 POST
 Login
 endpoint: /login
 @params: {
 "phone":"+37496293029",
 "password":"12345678"
 }
 */
- (void)loginUserWithPhoneNumber:(NSString *)phoneNumber andPassword:(NSString *)password withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self updateUserAuthToken:@"" refreshToken:@""];
    complition(nil);
}

/*
 POST
 Verification Phone Number
 endpoint: profile/verify_phone
 @params: {
 "phone":"+37496293029",
 "code":"313367"
 }
 */

- (void)verifyPhoneNumber:(NSString *)phoneNumber withCode:(NSString *)verificationCode withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}

/*
 POST
 Resend Registration verify code
 endpoint: /resend_verify_code
 @params: {
 "phone":"+37496293029"
 }
 */

- (void)resendVerifyCodeToPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}

/*
 POST
 Forgot Password
 endpoint: /forgot_password
 @params: {
 "phone":"+37496293029"
 }
 */

- (void)sendForgotPasswordWithPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}


/*
 POST
 Forgot Password Verify Code
 endpoint: /forgot_password_verify_code
 @params: {
 "phone":"+37496293029",
 "code":"253066"
 }
 */

- (void)verifyForgotPasswordPhoneNumber:(NSString *)phoneNumber withCode:(NSString *)verificationCode withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}


/*
 POST
 Create New Password
 endpoint: /create_password
 @params: {
 "password":"12345678",
 "confirm_password":"12345678",
 "token":"0f28a224159c8641dc2e5f48e3a64680b0927129c4e8186acdea14a053a3be23",
 "phone":"+37496293029"
 }
 */

- (void)createNewpassowrd:(NSString *)password confirm:(NSString *)confirmPassowrd token:(NSString *)token andPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}


/*
 POST
 Refresh Token
 endpoint: /refresh
 @params:{
 "refresh_token":"{token}"
 }
 */

- (void)refreshToken:(NSString *)token withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self updateUserAuthToken:@"" refreshToken:@""];
    complition(nil);
}

/*
 POST
 Change Password
 endpoint: /change_password
 @params: {
 "old_password":"client12345",
 "password":"123456789",
 "confirm_password":"123456789"
 }
 */

- (void)changePassowrd:(NSString *)oldPassword withNewPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}

/*
 POST
 endpoint: /logout
 Logout
 */

- (void)logoutUserWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    complition(nil);
}

/*
 GET
 endpoint: marital_status/list
 Get marital statuses
 
 */

- (void)getMaritalStatusesWithComplition:(void(^)(NSArray <MaritalStatusDataModel *> * response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:@"marital_statuses" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [Settings sharedInstance].userAuthToken = @"";
    [Settings sharedInstance].userRefreshToken = @"";
}

@end
