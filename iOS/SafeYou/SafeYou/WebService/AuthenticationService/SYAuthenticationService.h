//
//  SYAuthenticationService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/10/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

@class MaritalStatusDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYAuthenticationService : SYServiceAPI

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

- (void)registerUserWithData:(NSDictionary *)userDataDict withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 POST
 Login
 endpoint: /login
 @params: {
 "phone":"+10000000000",
 "password":"********"
 }
 */
- (void)loginUserWithPhoneNumber:(NSString *)phoneNumber andPassword:(NSString *)password withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 POST
 Verification Phone Number
 endpoint: /verify_phone
 @params: {
 "phone":"+10000000000",
 "code":"********"
 }
 */

- (void)verifyPhoneNumber:(NSString *)phoneNumber withCode:(NSString *)verificationCode withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 POST
 Resend Registration verify code
 endpoint: /resend_verify_code
 @params: {
 "phone":"+10000000000"
 }
 */

- (void)resendVerifyCodeToPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 POST
 Forgot Password
 endpoint: /forgot_password
 @params: {
 "phone":"+10000000000"
 }
 */

- (void)sendForgotPasswordWithPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;


/*
 POST
 Forgot Password Verify Code
 endpoint: /forgot_password_verify_code
 @params: {
 "phone":"+10000000000",
 "code":"********"
 }
 */

- (void)verifyForgotPasswordPhoneNumber:(NSString *)phoneNumber withCode:(NSString *)verificationCode withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;


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

- (void)createNewpassowrd:(NSString *)password confirm:(NSString *)confirmPassowrd token:(NSString *)token andPhoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;


/*
 POST
 Refresh Token
 endpoint: /refresh
 @params:{
 "refresh_token":"********"
 }
 */

- (void)refreshToken:(NSString *)token withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

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

- (void)changePassowrd:(NSString *)oldPassword withNewPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 POST
 endpoint: /logout
 Logout
 */

- (void)logoutUserWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 GET
 endpoint: marital_status/list
 Get marital statuses
 
 */

- (void)getMaritalStatusesWithComplition:(void(^)(NSArray <MaritalStatusDataModel *> * response))complition failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
