//
//  ConfigService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 12/31/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteConfigData : BaseDataModel

@property (nonatomic) NSString *requiredVersion;

@end

@interface ConfigService : SYServiceAPI

- (void)getConfigsWithComplition:(void(^)(RemoteConfigData *response))complition failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
