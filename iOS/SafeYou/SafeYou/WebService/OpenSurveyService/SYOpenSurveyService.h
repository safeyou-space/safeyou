//
//  SYOpenSurveyService.h
//  SafeYou
//
//  Created by armen sahakian on 23.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
#import "OpenSurveysDataModel.h"
#import "OpenSurveyAnswersDataModel.h"

@interface SYOpenSurveyService : SYServiceAPI

/*
 GET
 Get Open Surveys With Id
 endpoint: surveys
 */
- (void)getOpenSurveysWithComplition:(NSNumber*)pageIndex :(void(^)(OpenSurveysDataModel *))complition failure:(void(^)(NSError *error))failure;

/*
 GET
 Get Open Survey By Id
 endpoint: survey/{id}
 */
- (void)getOpenSurveyItemById:(NSNumber*)surveyId withComplition:(void(^)(OpenSurveyItemDataModel *))complition failure:(void(^)(NSError *error))failure;

/*
 POST
 Create Survey Answer
 endpoint: survey/user/answer
 */
- (void)sendSurveyAnswersWithComplition:(OpenSurveyAnswersDataModel *)answers withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

@end
