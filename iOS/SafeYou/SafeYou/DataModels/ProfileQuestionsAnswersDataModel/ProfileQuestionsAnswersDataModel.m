//
//  ProfileQuestionsAnswersDataModel.m
//  SafeYou
//
//  Created by armen sahakian on 31.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "ProfileQuestionsAnswersDataModel.h"

NSString *const kAnswerRegion = @"region";
NSString *const kAnswerCityVillage = @"city_village";
NSString *const kAnswerDoYouHaveChildren = @"do_you_have_children";
NSString *const kAnswerCurrentOccupation = @"current_occupation";
NSString *const kAnswerSpecifySettlementType = @"specify_settlement_type";

@interface ProfileQuestionsAnswersDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ProfileQuestionsAnswersDataModel

@synthesize answers = _answers;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.answers = [[NSMutableDictionary alloc] init];
        
        for(id key in dict) {
            [self.answers setObject:[QuestionsAnswersDataModel modelObjectWithDictionary:[self objectOrNilForKey:key fromDictionary:dict]] forKey:key];
        }
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.answers forKey:kAnswerRegion];

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

    self.answers = [aDecoder decodeDataObject];

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ProfileQuestionsAnswersDataModel *copy = [[ProfileQuestionsAnswersDataModel alloc] init];
    
    return copy;
}


@end
