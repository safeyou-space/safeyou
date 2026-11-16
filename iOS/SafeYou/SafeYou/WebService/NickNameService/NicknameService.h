//
//  NicknameService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/26/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface NicknameService : SYServiceAPI

- (void)checkNickname:(NSString *)nickname
                 success:(void(^)(id response))successBlock
                 failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
