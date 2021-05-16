//
//  SYConsultantService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

@class ConsultantExpertiseFieldDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYConsultantService : SYServiceAPI

/*
 GET
Registration

 endpoint: /consultant_categories

 */

- (void)getConsultantCategoriesWithComplition:(void(^)(NSArray <ConsultantExpertiseFieldDataModel *> *))complition failure:(void(^)(NSError *error))failure;


/**
 POST
 endpoinst: /profile/consultant_request
 params: {"category_id":1,
        "message":"please approve my change status from user to consultant"}
 */

- (void)requestForBecomingConsultantWithParams:(NSDictionary *)params complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/**
 PUT
 endpoinst: /profile/consultant_request
 Description: Deactivate Consultant

 */

- (void)deactivateConsultantWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/**
 DELETE
 endpoinst: /profile/consultant_request
 Description: Cancel Consultant Request
 */

- (void)cancelConsultantRequestWithComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
