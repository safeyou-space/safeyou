//
//  ForumItemDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumItemDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import "ImageDataModel.h"
#import "SafeYou-Swift.h"


NSString *const kForumItemImagePath = @"image_path";
NSString *const kForumItemShortDescription = @"short_description";
NSString *const kForumItemSubTitle = @"sub_title";
NSString *const kForumItemId = @"id";
NSString *const kForumItemCode = @"code";
NSString *const kForumItemCreatedAt = @"created_at";
NSString *const kForumItemTitle = @"title";
NSString *const kForumItemTopCommentedUsers = @"top_commented_users";
NSString *const kForumItemUsersCount = @"users_count";
NSString *const kForumItemDescription = @"description";
NSString *const kForumItemCommentsCount = @"comments_count";
NSString *const kForumItemViewCount = @"views_count";
NSString *const kForumItemNewMessagesCount = @"NEW_MESSAGES_COUNT";
NSString *const kForumItemImage = @"image";
NSString *const kForumItemAuthor = @"author";


@interface ForumItemDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ForumItemDataModel

@synthesize imagePath = _imagePath;
@synthesize shortDescription = _shortDescription;
@synthesize subTitle = _subTitle;
@synthesize forumItemId = _forumItemId;
@synthesize code = _code;
@synthesize createdAt = _createdAt;
@synthesize title = _title;
@synthesize topCommentedUsers = _topCommentedUsers;
@synthesize usersCount = _usersCount;
@synthesize forumItemDescription = _forumItemDescription;
@synthesize commentsCount = _commentsCount;
@synthesize author = _author;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.imagePath = [self objectOrNilForKey:kForumItemImagePath fromDictionary:dict];
        self.shortDescription = [self objectOrNilForKey:kForumItemShortDescription fromDictionary:dict];
        self.subTitle = [self objectOrNilForKey:kForumItemSubTitle fromDictionary:dict];
        self.forumItemId = [self objectOrNilForKey:kForumItemId fromDictionary:dict];
        self.code = [self objectOrNilForKey:kForumItemCode fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kForumItemCreatedAt fromDictionary:dict];
        self.title = [self objectOrNilForKey:kForumItemTitle fromDictionary:dict];
        self.commentsCount = [[self objectOrNilForKey:kForumItemCommentsCount fromDictionary:dict] integerValue];
        self.viewsCount = [[self objectOrNilForKey:kForumItemViewCount fromDictionary:dict] integerValue];
        self.imageData = [ImageDataModel modelObjectWithDictionary:dict[kForumItemImage]];
        NSObject *receivedTopCommentedUsers = [dict objectForKey:kForumItemTopCommentedUsers];
        NSMutableArray *parsedTopCommentedUsers = [NSMutableArray array];
        
        if ([receivedTopCommentedUsers isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedTopCommentedUsers) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedTopCommentedUsers addObject:[ForumCommentedUserDataModel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedTopCommentedUsers isKindOfClass:[NSDictionary class]]) {
            [parsedTopCommentedUsers addObject:[ForumCommentedUserDataModel modelObjectWithDictionary:(NSDictionary *)receivedTopCommentedUsers]];
        }
        
        self.topCommentedUsers = [NSArray arrayWithArray:parsedTopCommentedUsers];
        self.usersCount = [[self objectOrNilForKey:kForumItemUsersCount fromDictionary:dict] doubleValue];
        self.forumItemDescription = [self objectOrNilForKey:kForumItemDescription fromDictionary:dict];
        self.commentsCount = [[self objectOrNilForKey:kForumItemCommentsCount fromDictionary:dict] doubleValue];
        self.newMessagesCount = [[self objectOrNilForKey:kForumItemNewMessagesCount fromDictionary:dict] integerValue];

        self.formattedCreatedAt = [Helper formatDateToShowWithInitialDateString:self.createdAt];
        self.author = [self objectOrNilForKey:kForumItemAuthor fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.imagePath forKey:kForumItemImagePath];
    [mutableDict setValue:self.shortDescription forKey:kForumItemShortDescription];
    [mutableDict setValue:self.subTitle forKey:kForumItemSubTitle];
    [mutableDict setValue:self.forumItemId forKey:kForumItemId];
    [mutableDict setValue:self.code forKey:kForumItemCode];
    [mutableDict setValue:self.createdAt forKey:kForumItemCreatedAt];
    [mutableDict setValue:self.title forKey:kForumItemTitle];
    NSMutableArray *tempArrayForTopCommentedUsers = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.topCommentedUsers) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTopCommentedUsers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTopCommentedUsers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTopCommentedUsers] forKey:kForumItemTopCommentedUsers];
    [mutableDict setValue:[NSNumber numberWithDouble:self.usersCount] forKey:kForumItemUsersCount];
    [mutableDict setValue:self.forumItemDescription forKey:kForumItemDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentsCount] forKey:kForumItemCommentsCount];
    [mutableDict setValue:self.author forKey:kForumItemAuthor];
    
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
    
    self.imagePath = [aDecoder decodeObjectForKey:kForumItemImagePath];
    self.shortDescription = [aDecoder decodeObjectForKey:kForumItemShortDescription];
    self.subTitle = [aDecoder decodeObjectForKey:kForumItemSubTitle];
    self.forumItemId = [aDecoder decodeObjectForKey:kForumItemId];
    self.code = [aDecoder decodeObjectForKey:kForumItemCode];
    self.createdAt = [aDecoder decodeObjectForKey:kForumItemCreatedAt];
    self.title = [aDecoder decodeObjectForKey:kForumItemTitle];
    self.topCommentedUsers = [aDecoder decodeObjectForKey:kForumItemTopCommentedUsers];
    self.usersCount = [aDecoder decodeDoubleForKey:kForumItemUsersCount];
    self.forumItemDescription = [aDecoder decodeObjectForKey:kForumItemDescription];
    self.commentsCount = [aDecoder decodeDoubleForKey:kForumItemCommentsCount];
    self.author = [aDecoder decodeObjectForKey:kForumItemAuthor];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_imagePath forKey:kForumItemImagePath];
    [aCoder encodeObject:_shortDescription forKey:kForumItemShortDescription];
    [aCoder encodeObject:_subTitle forKey:kForumItemSubTitle];
    [aCoder encodeObject:_forumItemId forKey:kForumItemId];
    [aCoder encodeObject:_code forKey:kForumItemCode];
    [aCoder encodeObject:_createdAt forKey:kForumItemCreatedAt];
    [aCoder encodeObject:_title forKey:kForumItemTitle];
    [aCoder encodeObject:_topCommentedUsers forKey:kForumItemTopCommentedUsers];
    [aCoder encodeDouble:_usersCount forKey:kForumItemUsersCount];
    [aCoder encodeObject:_forumItemDescription forKey:kForumItemDescription];
    [aCoder encodeDouble:_commentsCount forKey:kForumItemCommentsCount];
    [aCoder encodeObject:_author forKey:kForumItemAuthor];
}

- (id)copyWithZone:(NSZone *)zone {
    ForumItemDataModel *copy = [[ForumItemDataModel alloc] init];
    if (copy) {
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.shortDescription = [self.shortDescription copyWithZone:zone];
        copy.subTitle = [self.subTitle copyWithZone:zone];
        copy.forumItemId = self.forumItemId;
        copy.code = [self.code copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.topCommentedUsers = [self.topCommentedUsers copyWithZone:zone];
        copy.usersCount = self.usersCount;
        copy.forumItemDescription = [self.forumItemDescription copyWithZone:zone];
        copy.commentsCount = self.commentsCount;
        copy.author = self.author;
    }
    return copy;
}


@end
