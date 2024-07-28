//
//  EmergencyServicesApi.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/13/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "EmergencyServicesApi.h"
#import "ServiceSearchResult.h"
#import "EmergencyServiceDataModel.h"
#import "ServiceCategoryDataModel.h"
#import "EmergencyServicesListDataModel.h"

@interface EmergencyServicesApi ()

@property (nonatomic) BOOL onlyForEmergency;

@end

@implementation EmergencyServicesApi

- (instancetype)initWithEmergency:(BOOL)forEmergency
{
    self = [super init];
    if (self) {
        self.onlyForEmergency = forEmergency;
    }
    return self;
    
}

- (NSString *)endpoint
{
    return @"services";
}

- (NSString *)endpointByCategoryId:(NSString *)categoryId
{
    return [NSString stringWithFormat:@"services_by_category/%@", categoryId];
}

- (NSString *)endpointForServiceId:(NSString *)serviceId
{
    return [NSString stringWithFormat:@"service/%@", serviceId];
}

- (NSString *)endpointForReview
{
    return @"rate/service";
}

- (void)getEmergencyServicesWithComplition:(void(^_Nonnull)(EmergencyServicesListDataModel * _Nullable emergencySerivcesList))complition failure:(void(^_Nonnull)(NSError * _Nonnull error))failure
{
    NSDictionary *params;
    if (self.onlyForEmergency) {
        params = @{@"is_send_sms":@"true"};
    }
    [self.networkManager GET:[self endpoint] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        EmergencyServicesListDataModel *servicesList = [EmergencyServicesListDataModel modelObjectWithDictionary:responseObject];
        if (complition) {
            complition(servicesList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getEmergencyServicesById:(NSString *)serviceId type:(NSString *)type complition:(void(^)(EmergencyServiceDataModel *serviceData))complition failure:(void(^)(NSError *error))failure
{

    [self.networkManager GET:[self endpointForServiceId:serviceId] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *receivedDataDict = ((NSArray *)responseObject).firstObject;
        EmergencyServiceDataModel *serviceData = [EmergencyServiceDataModel modelObjectWithDictionary:responseObject];
        if (complition) {
            complition(serviceData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

- (void)getEmergencyServicesWithSearchString:(NSString *_Nonnull)searchString categoryId:(NSString *_Nonnull)categoryId complition:(void(^_Nonnull)(NSArray <ServiceSearchResult *> * _Nullable searchResult))complition failure:(void(^_Nonnull)(NSError * _Nullable error))failure
{
    NSDictionary *params = @{@"search_string": searchString};
    if (self.onlyForEmergency) {
        params = @{@"search_string": searchString,
                   @"is_send_sms":@"true"};
    }
    
    //services?search_string=Char
    //services_by_category/2?search_string=Char

    NSString *endpoint = [self endpoint];
    if (![categoryId isEqualToString:@""]) {
        endpoint = [self endpointByCategoryId:categoryId];
    }
    
    [self.networkManager GET:endpoint parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *responseArray = [[NSMutableArray alloc] init];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                ServiceSearchResult *searchResult = [ServiceSearchResult modelObjectWithDictionary:dict];
                [responseArray addObject:searchResult];
            }
        }
        if (complition) {
            complition(responseArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getEmergencyServicesCategoriesWithComplition:(void(^)(NSArray <ServiceCategoryDataModel*> *emergencySerivcesCategoryList))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params;
    if (self.onlyForEmergency) {
        params = @{@"is_send_sms":@"true"};
    }
    
    [self.networkManager GET:@"service_categories" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSArray *idsArray = [responseObject allKeys];
        for (NSString *categoryId in idsArray) {
            
            NSString *categoryName = nilOrJSONObjectForKey(responseObject, categoryId);
            ServiceCategoryDataModel *categoryData = [[ServiceCategoryDataModel alloc] initWithId:categoryId name:categoryName];
            [tempArray addObject:categoryData];
        }
        if (complition) {
            complition([tempArray copy]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)addReview:(NSDictionary *)params success:(void(^)(NSString *message))success failure:(void(^)(NSError *error))failure
{
    NSString *endpoint = [self endpointForReview];
    [self.networkManager POST:endpoint parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *message = [dict objectForKey:@"message"];
        success(message);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
