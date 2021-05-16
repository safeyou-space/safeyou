//
//  ProfessionTranslationDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/30/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionTranslationDataModel : BaseDataModel

/**
 "created_at" = "2021-02-24 12:53:15";
 id = 25;
 "language_id" = 1;
 "profession_consultant_service_category_id" = 13;
 translation = Expert;
 "updated_at" = "2021-02-24 12:53:15";
 */

@property (nonatomic) NSNumber *translationId;
@property (nonatomic) NSNumber *languageId;
@property (nonatomic) NSString *createdDateString;
@property (nonatomic) NSString *updatedDateString;
@property (nonatomic) NSNumber *professionId;
@property (nonatomic) NSString *translatedName;

@end

NS_ASSUME_NONNULL_END
