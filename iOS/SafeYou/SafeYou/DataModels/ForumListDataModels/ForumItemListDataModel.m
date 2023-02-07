//
//  ForumItemListDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumItemListDataModel.h"
#import "ForumItemDataModel.h"

NSString *const kForumItemsListData = @"data";
NSString *const kForumsLastPage = @"last_page";


@interface ForumItemListDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ForumItemListDataModel

@synthesize forumItems = _forumItems;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        integerObjectOrNilForKey(self.lastPage, dict, kForumsLastPage);
        NSObject *receivedForumItem = [dict objectForKey:kForumItemsListData];
        NSMutableArray *parsedForumItem = [NSMutableArray array];
        
        if ([receivedForumItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedForumItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedForumItem addObject:[ForumItemDataModel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedForumItem isKindOfClass:[NSDictionary class]]) {
            [parsedForumItem addObject:[ForumItemDataModel modelObjectWithDictionary:(NSDictionary *)receivedForumItem]];
        }
        
        self.forumItems = [NSArray arrayWithArray:parsedForumItem];
        
    } else if (self && [dict isKindOfClass:[NSArray class]]) {
        NSMutableArray *parsedForumItem = [NSMutableArray array];
        for (NSDictionary *item in (NSArray *)dict) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedForumItem addObject:[ForumItemDataModel modelObjectWithDictionary:item]];
            }
        }
        self.forumItems = [NSArray arrayWithArray:parsedForumItem];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForForumItem = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.forumItems) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForForumItem addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForForumItem addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForForumItem] forKey:kForumItemsListData];
    
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
    
    self.forumItems = [aDecoder decodeObjectForKey:kForumItemsListData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_forumItems forKey:kForumItemsListData];
}

- (id)copyWithZone:(NSZone *)zone {
    ForumItemListDataModel *copy = [[ForumItemListDataModel alloc] init];
    
    
    
    if (copy) {
        
        copy.forumItems = [self.forumItems copyWithZone:zone];
    }
    
    return copy;
}


@end
