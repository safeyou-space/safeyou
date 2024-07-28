//
//  ProfileQuestionsAnswersDataModel.h
//  SafeYou
//
//  Created by armen sahakian on 31.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//
#import "BaseDataModel.h"
#import "QuestionsAnswersDataModel.h"

@class QuestionsAnswersDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileQuestionsAnswersDataModel : BaseDataModel
@property (nonatomic) NSMutableDictionary <NSString*, QuestionsAnswersDataModel*> *answers;

@end

NS_ASSUME_NONNULL_END
