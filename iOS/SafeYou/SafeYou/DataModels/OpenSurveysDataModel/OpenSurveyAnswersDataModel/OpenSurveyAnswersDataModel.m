//
//  OpenSurveyAnswersDataModel.m
//  SafeYou
//
//  Created by armen sahakian on 02.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "OpenSurveyAnswersDataModel.h"

@implementation OpenSurveyAnswersDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary) {
            _surveyID = dictionary[@"survey_id"];
            _questions = dictionary[@"questions"];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation:(OpenSurveyAnswersDataModel *)answers {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.surveyID) {
        dictionary[@"survey_id"] = answers.surveyID;
    }
    
    if (self.questions) {
        dictionary[@"questions"] = answers.questions;
    }
    
    return [dictionary copy];
}

@end

