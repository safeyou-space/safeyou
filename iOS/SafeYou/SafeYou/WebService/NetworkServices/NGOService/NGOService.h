//
//  NGOService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface NGOService : SYServiceAPI


/*
 endpoint: ngos
 */

- (void)getNGOWithComplition:(void(^)(UserDataModel *userData))complition failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
