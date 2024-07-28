//
//  OpenSurveyAnswersDataModel.h
//  SafeYou
//
//  Created by armen sahakian on 02.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//
#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenSurveyAnswersDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *surveyID;
@property (nonatomic, strong) NSDictionary *questions;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation:(OpenSurveyAnswersDataModel *)answers;

@end

NS_ASSUME_NONNULL_END
