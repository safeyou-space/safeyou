//
//  PhoneNumberService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/24/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "PhoneNumberService.h"

@implementation PhoneNumberService


- (void)checkPhoneNumber:(NSString *)phoneNumber
                 success:(void(^)(id response))successBlock
                 failure:(void(^)(NSError *error))failure
{
    /**
     check_phone - endpoint
     "phone": "+374111111" - data
    */
    NSDictionary *params = @{@"phone": phoneNumber};
    [self.networkManager POST:@"check_phone" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
