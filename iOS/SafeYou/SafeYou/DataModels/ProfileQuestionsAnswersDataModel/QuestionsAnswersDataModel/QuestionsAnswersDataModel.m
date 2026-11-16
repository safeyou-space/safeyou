//
//  QuestionsAnswersDataModel.m
//  SafeYou
//
//  Created by armen sahakian on 31.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "QuestionsAnswersDataModel.h"

NSString *const kAnswerId = @"answer_id";
NSString *const kAnswer = @"answer";
NSString *const kQuestionId = @"question_id";
NSString *const kQuestionOptionId = @"question_option_id";
NSString *const kquestionType = @"question_type";

@interface QuestionsAnswersDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation QuestionsAnswersDataModel

@synthesize answerId = _answerId;
@synthesize answer = _answer;
@synthesize questionId = _questionId;
@synthesize questionOptionId = _questionOptionId;
@synthesize questionType = _questionType;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.answerId = [self objectOrNilForKey:kAnswerId fromDictionary:dict];
        self.answer = [self objectOrNilForKey:kAnswer fromDictionary:dict];
        self.questionId = [self objectOrNilForKey:kQuestionId fromDictionary:dict];
        self.questionOptionId = [self objectOrNilForKey:kQuestionOptionId fromDictionary:dict];
        self.questionType = [self objectOrNilForKey:kquestionType fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.answerId forKey:kAnswerId];
    [mutableDict setValue:self.answer forKey:kAnswer];
    [mutableDict setValue:self.questionId forKey:kQuestionId];
    [mutableDict setValue:self.questionOptionId forKey:kQuestionOptionId];
    [mutableDict setValue:self.questionType forKey:kquestionType];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.answerId = [aDecoder decodeObjectForKey:kAnswerId];
    self.answer = [aDecoder decodeObjectForKey:kAnswer];
    self.questionId = [aDecoder decodeObjectForKey:kQuestionId];
    self.questionOptionId = [aDecoder decodeObjectForKey:kQuestionOptionId];
    self.questionType = [aDecoder decodeObjectForKey:kquestionType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_answerId forKey:kAnswerId];
    [aCoder encodeObject:_answer forKey:kAnswer];
    [aCoder encodeObject:_questionId forKey:kQuestionId];
    [aCoder encodeObject:_questionOptionId forKey:kQuestionOptionId];
    [aCoder encodeObject:_questionType forKey:kquestionType];
}

- (id)copyWithZone:(NSZone *)zone {
    QuestionsAnswersDataModel *copy = [[QuestionsAnswersDataModel alloc] init];
 
    if (copy) {

        copy.answerId = self.answerId;
        copy.answer = self.answer;
        copy.questionId = self.questionId;
        copy.questionOptionId = self.questionOptionId;
        copy.questionType = self.questionType;
    }
    
    return copy;
}


@end

