//
//  ConfigService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 12/31/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigService : SYServiceAPI

- (void)getConfigsWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
