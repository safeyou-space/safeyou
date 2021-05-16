//
//  ProfessionTranslationDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/30/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ProfessionTranslationDataModel.h"

@implementation ProfessionTranslationDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        /**
         "created_at" = "2021-02-24 12:53:15";
         id = 25;
         "language_id" = 1;
         "profession_consultant_service_category_id" = 13;
         translation = Expert;
         "updated_at" = "2021-02-24 12:53:15";
         */

        objectOrNilForKey(self.translationId, dict, @"id");
        objectOrNilForKey(self.createdDateString, dict, @"created_at");
        objectOrNilForKey(self.updatedDateString, dict, @"updated_at") ;
        objectOrNilForKey(self.professionId, dict, @"profession_consultant_service_category_id");
        objectOrNilForKey(self.translatedName, dict, @"translation");
        objectOrNilForKey(self.languageId, dict, @"language_id");
    }
    return self;
}

@end
