//
//  SYConsultantService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYConsultantService.h"
#import "ConsultantExpertiseFieldDataModel.h"

@implementation SYConsultantService

- (void)getConsultantCategoriesWithComplition:(void(^)(NSArray <ConsultantExpertiseFieldDataModel *> *))complition failure:(void(^)(NSError *error))failure
{
    NSString *endPoint = @"consultant_categories";
    [self.networkManager GET:endPoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *categoriesList = [ConsultantExpertiseFieldDataModel catgoriesFromDictionary:responseObject];
        if (complition) {
            complition(categoriesList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestForBecomingConsultantWithParams:(NSDictionary *)params complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSString *endPoint = @"profile/consultant_request";
    
    [self.networkManager POST:endPoint parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)deactivateConsultantWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSString *endPoint = @"profile/consultant_request";
    [self.networkManager PUT:endPoint parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)cancelConsultantRequestWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSString *endPoint = @"profile/consultant_request";
    [self.networkManager DELETE:endPoint parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
