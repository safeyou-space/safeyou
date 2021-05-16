//
//  UserConsultantRequestDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/30/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class ConsultantProfessionDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface UserConsultantRequestDataModel : BaseDataModel

/**
 "consultant_request" =     (
             {
         category =             {
             "created_at" = "2021-02-24 12:53:15";
             id = 13;
             profession = Expert;
             status = 1;
             translation = Expert;
             translations =                 (
                                     {
                     "created_at" = "2021-02-24 12:53:15";
                     id = 25;
                     "language_id" = 1;
                     "profession_consultant_service_category_id" = 13;
                     translation = Expert;
                     "updated_at" = "2021-02-24 12:53:15";
                 },
                                     {
                     "created_at" = "2021-02-24 12:53:15";
                     id = 26;
                     "language_id" = 2;
                     "profession_consultant_service_category_id" = 13;
                     translation = "\U0537\U0584\U057d\U057a\U0565\U0580\U057f";
                     "updated_at" = "2021-02-24 12:53:15";
                 }
             );
             "updated_at" = "2021-02-24 12:53:15";
         };
         "created_at" = "2021-03-28 20:01:08";
         email = "asd@asd.as";
         id = 77;
         message = "Hello, please add me as a consultant";
         "profession_consultant_service_category_id" = 13;
         status = 0;
         "suggested_category" = "<null>";
         "updated_at" = "03/28/2021";
         "user_id" = 24;
     }
 )
 */

@property (nonatomic) NSNumber *requestId;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *createdDateString;
@property (nonatomic) NSString *message;
@property (nonatomic) NSNumber *professionCategoryId;
@property (nonatomic) ConsultantRequestStatus requestStatus;
@property (nonatomic) NSString *userSuggestedCategory;
@property (nonatomic) NSString *updatedDateString;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) ConsultantProfessionDataModel *professionData;

@end

NS_ASSUME_NONNULL_END
