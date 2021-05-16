//
//  ConsultantProfessionDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/30/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class ProfessionTranslationDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ConsultantProfessionDataModel : BaseDataModel

/**
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
 }
 */

@property (nonatomic) NSNumber *categoryId;
@property (nonatomic) NSString *createdDateString;
@property (nonatomic) NSArray <ProfessionTranslationDataModel *> *translationsData;
@property (nonatomic) NSString *updatedDateString;
@property (nonatomic) NSNumber *status;


@end

NS_ASSUME_NONNULL_END
