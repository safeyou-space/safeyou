//
//  HelpService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpService : SYServiceAPI

- (void)sendEmergencyMessgaeComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
