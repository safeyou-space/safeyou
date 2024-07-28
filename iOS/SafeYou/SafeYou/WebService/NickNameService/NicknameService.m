//
//  NicknameService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/26/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "NicknameService.h"

@implementation NicknameService

- (void)checkNickname:(NSString *)nickname
                 success:(void(^)(id response))successBlock
                 failure:(void(^)(NSError *error))failure
{
    /**
     check_nickname - endpoint
     "nickname": "nickname" - data
    */
    NSDictionary *params = @{@"nickname": nickname};
    [self.networkManager POST:@"check_nickname" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
