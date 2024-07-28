//
//  OpenSurveyItemDataModel.m
//  SafeYou
//
//  Created by Edgar on 29.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "OpenSurveyItemDataModel.h"

NSString *const kAutoTrans = @"auto_trans";
NSString *const kAutoTransLangIds = @"auto_trans_lang_ids";
NSString *const kContent18Plus = @"content_18_plus";
NSString *const kCorrectAnswered = @"correct_answered";
NSString *const kCreatedAt = @"created_at";
NSString *const kCreatedBy = @"created_by";
NSString *const kId = @"id";
NSString *const kIsAnswered = @"is_answered";
NSString *const kQuiz = @"quiz";
NSString *const kTranslation = @"translation";
NSString *const kTitle = @"title";
NSString *const kUserAnswer = @"user_answer";
NSString *const kSurveyId = @"survey_id";
NSString *const kUserId = @"user_id";
NSString *const kDetails = @"details";
NSString *const kCreatedByUser = @"created_by_user";
NSString *const kIsSuperAdmin = @"is_super_admin";
NSString *const kRole = @"role";
NSString *const kQuestions = @"questions";
NSString *const kReferralMap = @"refferalMap";
NSString *const kreferralQuestions = @"referral_questions";
NSString *const kType = @"type";
NSString *const kRequired = @"required";

// Options
NSString *const kOptions = @"options";
NSString *const kCorrectAnswer = @"correct_answer";
NSString *const kOptionQuestionId = @"question_id";
NSString *const kReferralQuestionId = @"referral_question_id";
NSString *const kReferralType = @"referral_type";
NSString *const kLongAnswer = @"long_answer";

@implementation OpenSurveyItemDataModel

- (instancetype)initWithId:(NSNumber *)currentPage {
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (OpenSurveyItemDataModel *)createWithData:(NSDictionary *)dataDict {
    
    OpenSurveyItemDataModel *dataObject = [[OpenSurveyItemDataModel alloc] init];
    
    // Parse the "SurveysData" dictionary
    dataObject.autoTrans = dataDict[kAutoTrans];
    dataObject.autoTransLangIds = dataDict[kAutoTransLangIds];
    dataObject.content18Plus = dataDict[kContent18Plus];
    dataObject.correctAnswered = dataDict[kCorrectAnswered];
    dataObject.createdAt = dataDict[kCreatedAt];
    dataObject.createdBy = dataDict[kCreatedBy];
    dataObject.id = dataDict[kId];
    dataObject.isAnswered = dataDict[kIsAnswered];
    dataObject.isQuiz = dataDict[kQuiz];
    
    // Parse the "translation" dictionary
    NSDictionary *translationDict = dataDict[kTranslation];
    Translation *translations = [[Translation alloc] init];
    translations.title = translationDict[kTitle];
    dataObject.translation = translations;
    
    // Parse the "userAnswer" dictionary
    NSDictionary *userAnswerDict = dataDict[kUserAnswer];
    UserAnswer *userAnswer = [[UserAnswer alloc] init];
    if (userAnswerDict != (id)[NSNull null] ) {
        userAnswer.id = userAnswerDict[kId];
        userAnswer.surveyId = userAnswerDict[kSurveyId];
        userAnswer.userId = userAnswerDict[kUserId];
        
        NSArray *userAnswerDetailsArray = userAnswerDict[kDetails];
        
        if (userAnswerDetailsArray && ![userAnswerDetailsArray isKindOfClass:[NSNull class]]) {
            NSMutableArray<UserAnswerDetails *> *userAnswerDetailsObj = [NSMutableArray array];
            
            for (NSDictionary *dataDict in userAnswerDetailsArray) {
                UserAnswerDetails *dataObject = [[UserAnswerDetails alloc] initWithDictionary:dataDict];
                [userAnswerDetailsObj addObject:dataObject];
            }
            
            userAnswer.userAnswerDetails = userAnswerDetailsObj;
            dataObject.userAnswer = userAnswer;
        }}

    // Parse the "created_by_user" dictionary
    NSDictionary *createdByUserDict = dataDict[kCreatedByUser];
    CreatedByUser *createdByUser = [[CreatedByUser alloc] init];
    createdByUser.isSuperAdmin = createdByUserDict[kIsSuperAdmin];
    createdByUser.role = createdByUserDict[kRole];
    dataObject.createdByUser = createdByUser;
    
    // Parse the "questions" array
    NSArray *questionsArray = dataDict[kQuestions];
    NSMutableArray<Question *> *questions = [NSMutableArray array];
    
    for (NSDictionary *questionDict in questionsArray) {
        Question *question = [[Question alloc] initWithDictionary:questionDict];
        [questions addObject:question];
    }
    dataObject.questions = questions;

    NSDictionary *referalMap = dataDict[kReferralMap];
    if (referalMap) {
        NSArray *referralQuestionsArray = referalMap[kreferralQuestions];
        NSMutableArray<Question *> *mReferralQuestions = [NSMutableArray array];

        for (NSDictionary *questionDict in referralQuestionsArray) {
            Question *question = [[Question alloc] initWithDictionary:questionDict];
            [mReferralQuestions addObject:question];
        }

        dataObject.referralQuestions = mReferralQuestions;

        NSArray *referralMapQuestionsArray = referalMap[kQuestions];
        NSMutableArray<Question *> *mRegularQuestions = [NSMutableArray array];

        for (NSDictionary *questionDict in referralMapQuestionsArray) {
            Question *question = [[Question alloc] initWithDictionary:questionDict];
            [mRegularQuestions addObject:question];
        }

        dataObject.regularQuestions = mRegularQuestions;
    }

    return dataObject;
}

- (nonnull Question *)questionWithId:(nonnull NSNumber *)questionId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionID=%@", questionId];
    NSArray *filteredArray = [self.questions filteredArrayUsingPredicate:predicate];
    return  filteredArray.firstObject;
}

- (NSInteger)numberOfQuestions
{
    if (self.regularQuestions) {
        NSInteger numberOfQuestions = self.regularQuestions.count;
        if (self.referralQuestions.count) {
            numberOfQuestions += 1;
        }

        return numberOfQuestions;
    }
    return self.questions.count;
}

@end

@implementation CreatedByUser

@end

@implementation Translation

@end

@implementation Option

@end

@implementation Question

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.questionID = dictionary[kId];
        self.createdAt = dictionary[kCreatedAt];
        self.type = dictionary[kType];
        self.isRequired = dictionary[kRequired];
        self.isLongAnswer = dictionary[kLongAnswer];

        NSDictionary *translationDict = dictionary[kTranslation];
        Translation *translation = [[Translation alloc] init];
        translation.title = translationDict[kTitle];

        self.translation = translation;

        // Parse the "options" array
        NSArray *optionsArray = dictionary[kOptions];
        NSMutableArray<Option *> *options = [NSMutableArray array];

        for (NSDictionary *optionDict in optionsArray) {
            Option *option = [[Option alloc] init];
            option.correctAnswer = optionDict[kCorrectAnswer];
            option.questionId = nilOrJSONObjectForKey(optionDict, kOptionQuestionId);
            option.referralQuestionId = nilOrJSONObjectForKey(optionDict, kReferralQuestionId);
            option.referralType = optionDict[kReferralType];
            option.id = optionDict[kId];

            // Parse the "translation" dictionary
            NSDictionary *translationDict = optionDict[kTranslation];
            Translation *translation = [[Translation alloc] init];
            translation.title = translationDict[kTitle];

            option.translation = translation;

            [options addObject:option];
        }
        self.options = options;

    }
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else {
        Question *otherQuestion = (Question *)other;
        return self.questionID == otherQuestion.questionID;
    }
}

- (NSUInteger)hash
{
    return self.questionID.hash;
}

@end

@implementation UserAnswer

@end

@implementation UserAnswerDetails

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _id = dictionary[@"id"];
        _questionId = dictionary[@"question_id"];
        _optionId = dictionary[@"option_id"];
        _optionValue = dictionary[@"option_value"];
        _surveyUserAnswerId = dictionary[@"survey_user_answer_id"];
    }
    return self;
}

@end
