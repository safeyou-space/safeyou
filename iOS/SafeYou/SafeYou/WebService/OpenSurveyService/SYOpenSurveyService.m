//
//  SYOpenSurveyService.m
//  SafeYou
//
//  Created by armen sahakian on 23.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "SYHTTPSessionManager.h"
#import "SYOpenSurveyService.h"
#import "OpenSurveysDataModel.h"
#import "OpenSurveyAnswersDataModel.h"


static NSString *const kthenByConfigurationsValue = @"[]";

@interface SYOpenSurveyService ()

@end

@implementation SYOpenSurveyService

- (NSString *)endpointForSurveys
{
    return @"surveys/published";
}

- (NSString *)endpointForSurveyanswer
{
    return @"survey/user/answer";
}

- (NSString *)endpointForSurvey
{
    return @"survey";
}

- (NSString *)endpointForSurveyById:(NSNumber *)surveyId
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", [self endpointForSurvey], surveyId];
    return endpoint;
}

/*
 GET
 Get Open Surveys With Id
 endpoint: surveys/published
 */

- (void)getOpenSurveysWithComplition:(NSNumber*)pageIndex :(void(^)( OpenSurveysDataModel *))complition failure:(void(^)(NSError *error))failure
{
    NSLog(@"Getting surveys for page %@", pageIndex);
    NSDictionary *params = @{@"page":pageIndex};
    [self.networkManager GET:[self endpointForSurveys] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        OpenSurveysDataModel *surveysData = [[OpenSurveysDataModel alloc] createWithData:responseObject];
        NSLog(@"Surveys are successfully received");
        if (complition) {
            complition(surveysData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error on getting surveys %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

/*
 GET
 Get Open Survey By Id
 endpoint: survey/{id}
 */

- (void)getOpenSurveyItemById:(NSNumber*)surveyId withComplition:(void(^)(OpenSurveyItemDataModel *))complition failure:(void(^)(NSError *error))failure
{
    NSLog(@"Getting survey for id %@", surveyId);
    [self.networkManager GET:[self endpointForSurveyById:surveyId] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        OpenSurveyItemDataModel *surveyData = [[OpenSurveyItemDataModel alloc] createWithData:responseObject];
        NSLog(@"Survey is successfully received");
        if (complition) {
            complition(surveyData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error on getting survey %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Create Survey Answer
 endpoint: survey/user/answer
 */

- (void)sendSurveyAnswersWithComplition:(OpenSurveyAnswersDataModel *)answers withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [answers dictionaryRepresentation: answers];
    NSLog(@"Params %@", params);
    [self.networkManager POST:[self endpointForSurveyanswer] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Surveys are successfully saved");
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error on saving surveys %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
