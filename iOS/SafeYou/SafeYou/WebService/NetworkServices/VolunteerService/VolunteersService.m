//
//  VolunteersService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "VolunteersService.h"

@implementation VolunteersService

- (NSString *)endpoint
{
    return @"volunteers";
}

/*
 endpoint: volunteers
 */

- (void)getVolunteersWithComplition:(void(^)(UserDataModel *userData))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:[self endpoint] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
