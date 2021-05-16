//
//  UserConsultantRequestDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/30/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "UserConsultantRequestDataModel.h"
#import "ConsultantProfessionDataModel.h"

@implementation UserConsultantRequestDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
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

    
    self = [super init];
    if (self) {
        objectOrNilForKey(self.requestId, dict, @"id") ;
        objectOrNilForKey(self.email, dict, @"email");
        objectOrNilForKey(self.createdDateString, dict, @"created_at");
        objectOrNilForKey(self.message, dict, @"message");
        objectOrNilForKey(self.professionCategoryId, dict, @"profession_consultant_service_category_id");
        integerObjectOrNilForKey(self.requestStatus,dict, @"status");
        objectOrNilForKey(self.userSuggestedCategory, dict, @"suggested_category");
        objectOrNilForKey(self.updatedDateString, dict, @"updated_at");
        objectOrNilForKey(self.userId, dict, @"user_id");
        self.professionData = [[ConsultantProfessionDataModel alloc] initWithDictionary:nilOrJSONObjectForKey(dict, @"category")];
        
        
    }
    
    return self;
}

@end
