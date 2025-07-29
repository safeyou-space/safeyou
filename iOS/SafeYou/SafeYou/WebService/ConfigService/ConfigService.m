//
//  ConfigService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 12/31/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ConfigService.h"

@implementation RemoteConfigData

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (dict[@"iOS"] && dict[@"iOS"][@"version"] && dict[@"iOS"][@"version"][@"production"]) {
        self.requiredVersion = dict[@"iOS"][@"version"][@"production"];
    }
    return self;
}

@end

@implementation ConfigService

- (void)getConfigsWithComplition:(void(^)(RemoteConfigData *response))complition failure:(void(^)(NSError *error))failure
{
    [[self networkManagerWithUrl:[Settings sharedInstance].baseResourceURL] GET:@"config.json" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Response is %@", responseObject);
        RemoteConfigData *configData = [[RemoteConfigData alloc] initWithDictionary:responseObject];
        if (complition) {
            complition(configData);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error is %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
