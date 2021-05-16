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
    weakify(self);
    [self.networkManager GET:endPoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        strongify(self);
        NSLog(@"Response is: %@", responseObject);
        NSArray *categoriesList = [self consultantCatgoriesFromDictionary:responseObject];
        if (complition) {
            complition(categoriesList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error %@", endPoint);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestForBecomingConsultantWithParams:(NSDictionary *)params complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSString *endPoint = @"profile/consultant_request";
    
    [self.networkManager POST:endPoint parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [self.networkManager PUT:endPoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [self.networkManager DELETE:endPoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Helper

- (NSArray <ConsultantExpertiseFieldDataModel *> *)consultantCatgoriesFromDictionary:(NSDictionary *)categoriesDict
{
    NSArray *allKeys = [categoriesDict allKeys];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *key in allKeys) {
        ConsultantExpertiseFieldDataModel *categoryData = [[ConsultantExpertiseFieldDataModel alloc] initWithId:key name:categoriesDict[key]];
        [tempArray addObject:categoryData];
    }
    
    return [tempArray copy];
}

@end
