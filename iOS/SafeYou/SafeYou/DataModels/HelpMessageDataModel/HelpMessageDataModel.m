//
//  HelpMessageDataModel.m
//
//  Created by   on 5/15/20
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "HelpMessageDataModel.h"
#import "HelpMessageTranslationDataModel.h"


NSString *const kBaseClassMessageId = @"messageId";
NSString *const kBaseClassStatus = @"status";
NSString *const kBaseClassCreatedAt = @"created_at";
NSString *const kBaseClassMessage = @"message";
NSString *const kBaseClassUpdatedAt = @"updated_at";
NSString *const kBaseClassTranslations = @"translations";
NSString *const kBaseClassTranslation = @"translation";


@interface HelpMessageDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HelpMessageDataModel

@synthesize messageId = _messageId;
@synthesize status = _status;
@synthesize createdAt = _createdAt;
@synthesize message = _message;
@synthesize updatedAt = _updatedAt;
@synthesize translations = _translations;
@synthesize translation = _translation;


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.messageId = [[self objectOrNilForKey:kBaseClassMessageId fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kBaseClassStatus fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kBaseClassCreatedAt fromDictionary:dict];
            self.message = [self objectOrNilForKey:kBaseClassMessage fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kBaseClassUpdatedAt fromDictionary:dict];
    NSObject *receivedTranslations = [dict objectForKey:kBaseClassTranslations];
    NSMutableArray *parsedTranslations = [NSMutableArray array];
    
    if ([receivedTranslations isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedTranslations) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedTranslations addObject:[HelpMessageTranslationDataModel modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedTranslations isKindOfClass:[NSDictionary class]]) {
       [parsedTranslations addObject:[HelpMessageTranslationDataModel modelObjectWithDictionary:(NSDictionary *)receivedTranslations]];
    }

    self.translations = [NSArray arrayWithArray:parsedTranslations];
            self.translation = [self objectOrNilForKey:kBaseClassTranslation fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.messageId] forKey:kBaseClassMessageId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kBaseClassStatus];
    [mutableDict setValue:self.createdAt forKey:kBaseClassCreatedAt];
    [mutableDict setValue:self.message forKey:kBaseClassMessage];
    [mutableDict setValue:self.updatedAt forKey:kBaseClassUpdatedAt];
    NSMutableArray *tempArrayForTranslations = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.translations) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTranslations addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTranslations addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTranslations] forKey:kBaseClassTranslations];
    [mutableDict setValue:self.translation forKey:kBaseClassTranslation];

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

    self.messageId = [aDecoder decodeDoubleForKey:kBaseClassMessageId];
    self.status = [aDecoder decodeDoubleForKey:kBaseClassStatus];
    self.createdAt = [aDecoder decodeObjectForKey:kBaseClassCreatedAt];
    self.message = [aDecoder decodeObjectForKey:kBaseClassMessage];
    self.updatedAt = [aDecoder decodeObjectForKey:kBaseClassUpdatedAt];
    self.translations = [aDecoder decodeObjectForKey:kBaseClassTranslations];
    self.translation = [aDecoder decodeObjectForKey:kBaseClassTranslation];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_messageId forKey:kBaseClassMessageId];
    [aCoder encodeDouble:_status forKey:kBaseClassStatus];
    [aCoder encodeObject:_createdAt forKey:kBaseClassCreatedAt];
    [aCoder encodeObject:_message forKey:kBaseClassMessage];
    [aCoder encodeObject:_updatedAt forKey:kBaseClassUpdatedAt];
    [aCoder encodeObject:_translations forKey:kBaseClassTranslations];
    [aCoder encodeObject:_translation forKey:kBaseClassTranslation];
}

- (id)copyWithZone:(NSZone *)zone {
    HelpMessageDataModel *copy = [[HelpMessageDataModel alloc] init];
    
    
    
    if (copy) {

        copy.messageId = self.messageId;
        copy.status = self.status;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.message = [self.message copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.translations = [self.translations copyWithZone:zone];
        copy.translation = [self.translation copyWithZone:zone];
    }
    
    return copy;
}

#pragma mark - Additional functionality

- (NSString *)messageForLanguage:(NSString *)languageCode
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language.code=%@", languageCode];
    NSArray *filteredTranslationsArray = [self.translations filteredArrayUsingPredicate:predicate];
    HelpMessageTranslationDataModel *selectedTranslation = filteredTranslationsArray.firstObject;
    NSString *message;
    if (selectedTranslation) {
        message =selectedTranslation.translation;
    } else {
        message = self.message;
    }
    return message;
}


@end
