//
//  QuestionsAnswersDataModel.h
//  SafeYou
//
//  Created by armen sahakian on 31.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionsAnswersDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *answerId;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSNumber *questionId;
@property (nonatomic, strong) NSNumber *questionOptionId;
@property (nonatomic, strong) NSString *questionType;

@end

NS_ASSUME_NONNULL_END
