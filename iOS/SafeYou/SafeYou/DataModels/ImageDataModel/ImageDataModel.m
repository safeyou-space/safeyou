//
//  ImageDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ImageDataModel.h"

NSString *const kImagePath = @"path";
NSString *const kImageName = @"name";
NSString *const kImageUrl = @"url";
NSString *const kImageType = @"type";
NSString *const kImageImageId = @"id";

@implementation ImageDataModel (ImageURL)

- (NSURL *)imageFullURL
{
    NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", [Settings sharedInstance].baseResourceURL, self.url];
    return [NSURL URLWithString:imageUrlString];
}

@end

@interface ImageDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ImageDataModel

@synthesize path = _path;
@synthesize name = _name;
@synthesize url = _url;
@synthesize type = _type;
@synthesize imageId = _imageId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.path = [self objectOrNilForKey:kImagePath fromDictionary:dict];
            self.name = [self objectOrNilForKey:kImageName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kImageUrl fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kImageType fromDictionary:dict] doubleValue];
            self.imageId = [self objectOrNilForKey:kImageImageId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.path forKey:kImagePath];
    [mutableDict setValue:self.name forKey:kImageName];
    [mutableDict setValue:self.url forKey:kImageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kImageType];
    [mutableDict setValue:self.imageId forKey:kImageImageId];

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

    self.path = [aDecoder decodeObjectForKey:kImagePath];
    self.name = [aDecoder decodeObjectForKey:kImageName];
    self.url = [aDecoder decodeObjectForKey:kImageUrl];
    self.type = [aDecoder decodeIntegerForKey:kImageType];
    self.imageId = [aDecoder decodeObjectForKey:kImageImageId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_path forKey:kImagePath];
    [aCoder encodeObject:_name forKey:kImageName];
    [aCoder encodeObject:_url forKey:kImageUrl];
    [aCoder encodeInteger:_type forKey:kImageType];
    [aCoder encodeObject:_imageId forKey:kImageImageId];
}

- (id)copyWithZone:(NSZone *)zone {
    ImageDataModel *copy = [[ImageDataModel alloc] init];
    
    if (copy) {
        copy.path = [self.path copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.type = self.type;
        copy.imageId = self.imageId;
    }
    return copy;
}


@end
