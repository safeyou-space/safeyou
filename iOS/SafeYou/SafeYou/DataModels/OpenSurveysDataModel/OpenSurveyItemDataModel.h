//
//  OpenSurveyItemDataModel.h
//  SafeYou
//
//  Created by Edgar on 29.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreatedByUser : NSObject

@property (nonatomic, strong) NSNumber *isSuperAdmin;
@property (nonatomic, strong) NSString *role;

@end
@interface Translation : NSObject

@property (nonatomic, strong) NSString *title;

@end

@interface Option : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *correctAnswer;
@property (nonatomic, strong) NSNumber *questionId;
@property (nonatomic, strong) NSNumber *referralQuestionId;
@property (nonatomic, strong) NSString *referralType;
@property (nonatomic, strong) Translation *translation;

@end

@interface Question : BaseDataModel

@property (nonatomic, strong) NSNumber *questionID;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSArray<Option *> *options;
@property (nonatomic, strong) NSNumber *isRequired;
@property (nonatomic, strong) Translation *translation;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *isLongAnswer;

@end

@interface UserAnswerDetails : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *questionId;
@property (nonatomic, strong) NSNumber *optionId;
@property (nonatomic, strong) NSNumber *optionValue;
@property (nonatomic, strong) NSNumber *surveyUserAnswerId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface UserAnswer : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *surveyId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSArray<UserAnswerDetails *> *userAnswerDetails;

@end

@interface OpenSurveyItemDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *autoTrans;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) id autoTransLangIds;
@property (nonatomic, strong) NSNumber *content18Plus;
@property (nonatomic, strong) NSArray<NSNumber *> *correctAnswered;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *createdBy;
@property (nonatomic, strong) CreatedByUser *createdByUser;
@property (nonatomic, strong) NSNumber *isAnswered;
@property (nonatomic, strong) NSArray<Question *> *questions;
@property (nonatomic, strong) NSArray<Question *> *regularQuestions;
@property (nonatomic, strong) NSArray<Question *> *referralQuestions;
@property (nonatomic, strong) Translation *translation;
@property (nonatomic, strong) NSNumber *isQuiz;
@property (nonatomic, strong) UserAnswer *userAnswer;

- (OpenSurveyItemDataModel *)createWithData:(NSDictionary *)data;
- (Question *)questionWithId:(NSNumber *)questionId;
- (NSInteger)numberOfQuestions;

@end

NS_ASSUME_NONNULL_END
