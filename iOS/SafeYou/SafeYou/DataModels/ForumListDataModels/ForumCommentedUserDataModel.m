//
//  ForumCommentedUserDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumCommentedUserDataModel.h"


NSString *const kTopCommentedUsersUserId = @"user_id";
NSString *const kTopCommentedUsersImagePath = @"image_path";
NSString *const kTopCommentedUsersNickname = @"nickname";


@interface ForumCommentedUserDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ForumCommentedUserDataModel

@synthesize userId = _userId;
@synthesize imagePath = _imagePath;
@synthesize nickname = _nickname;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userId = [[self objectOrNilForKey:kTopCommentedUsersUserId fromDictionary:dict] doubleValue];
            self.imagePath = [self objectOrNilForKey:kTopCommentedUsersImagePath fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kTopCommentedUsersNickname fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kTopCommentedUsersUserId];
    [mutableDict setValue:self.imagePath forKey:kTopCommentedUsersImagePath];
    [mutableDict setValue:self.nickname forKey:kTopCommentedUsersNickname];

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

    self.userId = [aDecoder decodeDoubleForKey:kTopCommentedUsersUserId];
    self.imagePath = [aDecoder decodeObjectForKey:kTopCommentedUsersImagePath];
    self.nickname = [aDecoder decodeObjectForKey:kTopCommentedUsersNickname];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_userId forKey:kTopCommentedUsersUserId];
    [aCoder encodeObject:_imagePath forKey:kTopCommentedUsersImagePath];
    [aCoder encodeObject:_nickname forKey:kTopCommentedUsersNickname];
}

- (id)copyWithZone:(NSZone *)zone {
    ForumCommentedUserDataModel *copy = [[ForumCommentedUserDataModel alloc] init];
    
    
    
    if (copy) {

        copy.userId = self.userId;
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
    }
    
    return copy;
}


@end
