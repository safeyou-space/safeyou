//
//  HelpMessageLanguageDataModel.m
//
//  Created by   on 5/15/20
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "HelpMessageLanguageDataModel.h"


NSString *const kLanguageStatus = @"status";
NSString *const kLanguageId = @"id";
NSString *const kLanguageCode = @"code";
NSString *const kLanguageTitle = @"title";
NSString *const kLanguageImageId = @"image_id";
NSString *const kLanguageCreatedAt = @"created_at";
NSString *const kLanguageUpdatedAt = @"updated_at";


@interface HelpMessageLanguageDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HelpMessageLanguageDataModel

@synthesize status = _status;
@synthesize languageIdentifier = _languageIdentifier;
@synthesize code = _code;
@synthesize title = _title;
@synthesize imageId = _imageId;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.status = [[self objectOrNilForKey:kLanguageStatus fromDictionary:dict] doubleValue];
            self.languageIdentifier = [[self objectOrNilForKey:kLanguageId fromDictionary:dict] doubleValue];
            self.code = [self objectOrNilForKey:kLanguageCode fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLanguageTitle fromDictionary:dict];
            self.imageId = [[self objectOrNilForKey:kLanguageImageId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kLanguageCreatedAt fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kLanguageUpdatedAt fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kLanguageStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.languageIdentifier] forKey:kLanguageId];
    [mutableDict setValue:self.code forKey:kLanguageCode];
    [mutableDict setValue:self.title forKey:kLanguageTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.imageId] forKey:kLanguageImageId];
    [mutableDict setValue:self.createdAt forKey:kLanguageCreatedAt];
    [mutableDict setValue:self.updatedAt forKey:kLanguageUpdatedAt];

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

    self.status = [aDecoder decodeDoubleForKey:kLanguageStatus];
    self.languageIdentifier = [aDecoder decodeDoubleForKey:kLanguageId];
    self.code = [aDecoder decodeObjectForKey:kLanguageCode];
    self.title = [aDecoder decodeObjectForKey:kLanguageTitle];
    self.imageId = [aDecoder decodeDoubleForKey:kLanguageImageId];
    self.createdAt = [aDecoder decodeObjectForKey:kLanguageCreatedAt];
    self.updatedAt = [aDecoder decodeObjectForKey:kLanguageUpdatedAt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kLanguageStatus];
    [aCoder encodeDouble:_languageIdentifier forKey:kLanguageId];
    [aCoder encodeObject:_code forKey:kLanguageCode];
    [aCoder encodeObject:_title forKey:kLanguageTitle];
    [aCoder encodeDouble:_imageId forKey:kLanguageImageId];
    [aCoder encodeObject:_createdAt forKey:kLanguageCreatedAt];
    [aCoder encodeObject:_updatedAt forKey:kLanguageUpdatedAt];
}

- (id)copyWithZone:(NSZone *)zone {
    HelpMessageLanguageDataModel *copy = [[HelpMessageLanguageDataModel alloc] init];
    
    
    
    if (copy) {

        copy.status = self.status;
        copy.languageIdentifier = self.languageIdentifier;
        copy.code = [self.code copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.imageId = self.imageId;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
    }
    
    return copy;
}


@end
