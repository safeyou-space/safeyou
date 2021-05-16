//
//  HelpMessageTranslationDataModel.m
//
//  Created by   on 5/15/20
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "HelpMessageTranslationDataModel.h"
#import "HelpMessageLanguageDataModel.h"


NSString *const kTranslationsHelpMessageId = @"help_message_id";
NSString *const kTranslationsId = @"id";
NSString *const kTranslationsCreatedAt = @"created_at";
NSString *const kTranslationsLanguageId = @"language_id";
NSString *const kTranslationsLanguage = @"language";
NSString *const kTranslationsUpdatedAt = @"updated_at";
NSString *const kTranslationsTranslation = @"translation";


@interface HelpMessageTranslationDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HelpMessageTranslationDataModel

@synthesize helpMessageId = _helpMessageId;
@synthesize translationsIdentifier = _translationsIdentifier;
@synthesize createdAt = _createdAt;
@synthesize languageId = _languageId;
@synthesize language = _language;
@synthesize updatedAt = _updatedAt;
@synthesize translation = _translation;


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.helpMessageId = [[self objectOrNilForKey:kTranslationsHelpMessageId fromDictionary:dict] doubleValue];
            self.translationsIdentifier = [[self objectOrNilForKey:kTranslationsId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kTranslationsCreatedAt fromDictionary:dict];
            self.languageId = [self objectOrNilForKey:kTranslationsLanguageId fromDictionary:dict];
            self.language = [HelpMessageLanguageDataModel modelObjectWithDictionary:[dict objectForKey:kTranslationsLanguage]];
            self.updatedAt = [self objectOrNilForKey:kTranslationsUpdatedAt fromDictionary:dict];
            self.translation = [self objectOrNilForKey:kTranslationsTranslation fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.helpMessageId] forKey:kTranslationsHelpMessageId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.translationsIdentifier] forKey:kTranslationsId];
    [mutableDict setValue:self.createdAt forKey:kTranslationsCreatedAt];
    [mutableDict setValue:self.languageId forKey:kTranslationsLanguageId];
    [mutableDict setValue:[self.language dictionaryRepresentation] forKey:kTranslationsLanguage];
    [mutableDict setValue:self.updatedAt forKey:kTranslationsUpdatedAt];
    [mutableDict setValue:self.translation forKey:kTranslationsTranslation];

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

    self.helpMessageId = [aDecoder decodeDoubleForKey:kTranslationsHelpMessageId];
    self.translationsIdentifier = [aDecoder decodeDoubleForKey:kTranslationsId];
    self.createdAt = [aDecoder decodeObjectForKey:kTranslationsCreatedAt];
    self.languageId = [aDecoder decodeObjectForKey:kTranslationsLanguageId];
    self.language = [aDecoder decodeObjectForKey:kTranslationsLanguage];
    self.updatedAt = [aDecoder decodeObjectForKey:kTranslationsUpdatedAt];
    self.translation = [aDecoder decodeObjectForKey:kTranslationsTranslation];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_helpMessageId forKey:kTranslationsHelpMessageId];
    [aCoder encodeDouble:_translationsIdentifier forKey:kTranslationsId];
    [aCoder encodeObject:_createdAt forKey:kTranslationsCreatedAt];
    [aCoder encodeObject:_languageId forKey:kTranslationsLanguageId];
    [aCoder encodeObject:_language forKey:kTranslationsLanguage];
    [aCoder encodeObject:_updatedAt forKey:kTranslationsUpdatedAt];
    [aCoder encodeObject:_translation forKey:kTranslationsTranslation];
}

- (id)copyWithZone:(NSZone *)zone {
    HelpMessageTranslationDataModel *copy = [[HelpMessageTranslationDataModel alloc] init];
    
    
    
    if (copy) {

        copy.helpMessageId = self.helpMessageId;
        copy.translationsIdentifier = self.translationsIdentifier;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.languageId = self.languageId;
        copy.language = [self.language copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.translation = [self.translation copyWithZone:zone];
    }
    
    return copy;
}


@end
