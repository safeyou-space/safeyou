//
//  ForumDetials.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumDetials.h"
#import "ForumCommentDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import "Constants.h"


NSString *const kForumDetialsComments = @"comments";
NSString *const kForumDetialsReplies = @"reply_list";
NSString *const kForumDetialsShortDescription = @"short_description";
NSString *const kForumDetialsImagePath = @"image_path";
NSString *const kForumDetialsId = @"id";
NSString *const kForumDetialsCreatedAt = @"created_at";
NSString *const kForumDetialsTitle = @"title";
NSString *const kForumDetialsCode = @"code";
NSString *const kForumDetialsTopCommentedUsers = @"top_commented_users";
NSString *const kForumDetialsCommentsCount = @"comments_count";


@interface ForumDetials ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) NSArray <ForumCommentDataModel *>*replyList;

@property (nonatomic) NSInteger viewLevel;

@end

@implementation ForumDetials

@synthesize comments = _comments;
@synthesize shortDescription = _shortDescription;
@synthesize imagePath = _imagePath;
@synthesize forumId = _forumId;
@synthesize createdAt = _createdAt;
@synthesize title = _title;
@synthesize code = _code;
@synthesize topCommentedUsers = _topCommentedUsers;
@synthesize commentsCount = _commentsCount;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict level:(NSInteger)level {
    ForumDetials *forumdetailsInstance = [[self alloc] initWithDictionary:dict];
    forumdetailsInstance.viewLevel = level;
    return forumdetailsInstance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        [self parseReplies:dict];
        
        NSObject *receivedComments = [dict objectForKey:kForumDetialsComments];
        if ([receivedComments isKindOfClass:[NSArray class]]) {
            NSMutableArray *parsedComments = [NSMutableArray array];
            for (NSDictionary *item in (NSArray *)receivedComments) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    ForumCommentDataModel *comment = [ForumCommentDataModel modelObjectWithDictionary:item];
                    [parsedComments addObject:comment];
                }
            }
            
            NSMutableArray *reversedArray = [self reverse:parsedComments];
            
            NSMutableArray *finalStrippedArray = [[NSMutableArray alloc] init];
            NSMutableArray *finalParsedComments = [[NSMutableArray alloc] init];
            for (ForumCommentDataModel *comment in reversedArray) {
                [finalParsedComments addObject:comment];
                [finalStrippedArray addObject:comment];
                NSArray *repliesArray = [self fetchRepliesForComment:comment];
                NSArray *reversedReplies = [self reverse:[repliesArray mutableCopy]];
                
                if (reversedReplies.count > 0) {
                    if (reversedReplies.count > 2) {
                        NSIndexSet *firstTwoIndeces = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
                        NSMutableArray *strippedRepliesArray = [[reversedReplies objectsAtIndexes:firstTwoIndeces] mutableCopy];
                        NSInteger numberOfRestReplies = reversedReplies.count - 2;
                        [finalStrippedArray addObjectsFromArray:strippedRepliesArray];
                        [finalParsedComments addObjectsFromArray:reversedReplies];
                        [finalStrippedArray addObject:@(numberOfRestReplies)];
                    } else {
                        [finalStrippedArray addObjectsFromArray:reversedReplies];
                        [finalParsedComments addObjectsFromArray:reversedReplies];
                    }
                }
            }
            
            self.strippedComments = [NSArray arrayWithArray:finalStrippedArray];
            self.comments = [NSArray arrayWithArray:finalParsedComments];
        }
        
        self.shortDescription = [self objectOrNilForKey:kForumDetialsShortDescription fromDictionary:dict];
        self.imagePath = [self objectOrNilForKey:kForumDetialsImagePath fromDictionary:dict];
        self.forumId = [self objectOrNilForKey:kForumDetialsId fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kForumDetialsCreatedAt fromDictionary:dict];
        self.title = [self objectOrNilForKey:kForumDetialsTitle fromDictionary:dict];
        self.code = [self objectOrNilForKey:kForumDetialsCode fromDictionary:dict];
        NSObject *receivedTopCommentedUsers = [dict objectForKey:kForumDetialsTopCommentedUsers];
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
        self.commentsCount = [[self objectOrNilForKey:kForumDetialsCommentsCount fromDictionary:dict] doubleValue];
        
    }
    
    return self;
}

- (NSMutableArray *)reverse:(NSMutableArray *)reversingArray {
    if ([reversingArray count] <= 1)
        return [reversingArray copy];
    NSUInteger i = 0;
    NSUInteger j = [reversingArray count] - 1;
    while (i < j) {
        [reversingArray exchangeObjectAtIndex:i
                  withObjectAtIndex:j];

        i++;
        j--;
    }
    return [reversingArray mutableCopy];
}

- (void)parseReplies:(NSDictionary *)dict
{
    NSObject *receivedReplies = [dict objectForKey:kForumDetialsReplies];
    NSMutableArray *parsedReplies = [NSMutableArray array];
    
    if ([receivedReplies isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedReplies) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                ForumCommentDataModel *replyComment = [ForumCommentDataModel modelObjectWithDictionary:item];
                replyComment.isReply = YES;
                [parsedReplies addObject:replyComment];
            }
        }
        self.replyList = parsedReplies;
    }
}

- (NSArray <ForumCommentDataModel *>*)fetchRepliesForComment:(ForumCommentDataModel *)comment
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId=%@", comment.commentId];
    NSArray *filteredArray = [self.replyList filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        for (ForumCommentDataModel *reply in filteredArray) {
            ForumCommentDataModel *parentComment = [self fetchParentForReply:reply replyList:filteredArray];
            NSString *replyInfo = @"";
            if (parentComment) {
                replyInfo = [self replyInfoForReply:reply commen:parentComment];
            } else {
                replyInfo = [self replyInfoForReply:reply commen:comment];
            }
            reply.replyInfo = replyInfo;
        }
    }
    
    return filteredArray;
}

- (ForumCommentDataModel *)fetchCommentForId:(NSNumber *)commentId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId=%@", commentId];
    NSArray *fileteredArray = [_comments filteredArrayUsingPredicate:predicate];
    
    return fileteredArray.firstObject;;
}

- (NSArray<ForumCommentDataModel *> *)comments
{
    if (self.currentCommentId) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId=%@ OR groupId=%@",self.currentCommentId, self.currentCommentId];
        NSArray *filteredArray = [_comments filteredArrayUsingPredicate:predicate];
        return filteredArray;
    } else {
        return _strippedComments;
    }
}

- (NSArray<ForumCommentDataModel *> *)originalComments
{
    return _comments;
}

- (ForumCommentDataModel *)fetchParentForReply:(ForumCommentDataModel *)commentData replyList:(NSArray *)replyList
{
    NSNumber *searchingId;
    if (commentData.replyId) {
        searchingId = commentData.replyId;
    } else {
        searchingId = commentData.groupId;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId = %@", searchingId];
    NSArray *filteredArray = [replyList filteredArrayUsingPredicate:predicate];
    ForumCommentDataModel *parentComment = filteredArray.firstObject;
    
    return parentComment;
}

- (NSString *)replyInfoForReply:(ForumCommentDataModel *)reply commen:(ForumCommentDataModel *)parentComment
{
    if (reply.isMine) {
        NSString *replyInfo = [NSString stringWithFormat:LOC(@"you_replied_to_{param}"), parentComment.name];
        return replyInfo;
    } else {
        NSString *replyInfo = [NSString stringWithFormat:LOC(@"{person1}_replied_to_{person2}"),reply.name, parentComment.name];
        return replyInfo;
    }
    return @"";
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForComments = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.comments) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForComments addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForComments addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForComments] forKey:kForumDetialsComments];
    [mutableDict setValue:self.shortDescription forKey:kForumDetialsShortDescription];
    [mutableDict setValue:self.imagePath forKey:kForumDetialsImagePath];
    [mutableDict setValue:self.forumId forKey:kForumDetialsId];
    [mutableDict setValue:self.createdAt forKey:kForumDetialsCreatedAt];
    [mutableDict setValue:self.title forKey:kForumDetialsTitle];
    [mutableDict setValue:self.code forKey:kForumDetialsCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTopCommentedUsers] forKey:kForumDetialsTopCommentedUsers];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentsCount] forKey:kForumDetialsCommentsCount];

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

    self.comments = [aDecoder decodeObjectForKey:kForumDetialsComments];
    self.shortDescription = [aDecoder decodeObjectForKey:kForumDetialsShortDescription];
    self.imagePath = [aDecoder decodeObjectForKey:kForumDetialsImagePath];
    self.forumId = [aDecoder decodeObjectForKey:kForumDetialsId];
    self.createdAt = [aDecoder decodeObjectForKey:kForumDetialsCreatedAt];
    self.title = [aDecoder decodeObjectForKey:kForumDetialsTitle];
    self.code = [aDecoder decodeObjectForKey:kForumDetialsCode];
    self.topCommentedUsers = [aDecoder decodeObjectForKey:kForumDetialsTopCommentedUsers];
    self.commentsCount = [aDecoder decodeDoubleForKey:kForumDetialsCommentsCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_comments forKey:kForumDetialsComments];
    [aCoder encodeObject:_shortDescription forKey:kForumDetialsShortDescription];
    [aCoder encodeObject:_imagePath forKey:kForumDetialsImagePath];
    [aCoder encodeObject:_forumId forKey:kForumDetialsId];
    [aCoder encodeObject:_createdAt forKey:kForumDetialsCreatedAt];
    [aCoder encodeObject:_title forKey:kForumDetialsTitle];
    [aCoder encodeObject:_code forKey:kForumDetialsCode];
    [aCoder encodeObject:_topCommentedUsers forKey:kForumDetialsTopCommentedUsers];
    [aCoder encodeDouble:_commentsCount forKey:kForumDetialsCommentsCount];
}

- (id)copyWithZone:(NSZone *)zone {
    ForumDetials *copy = [[ForumDetials alloc] init];
    
    
    
    if (copy) {

        copy.comments = [self.comments copyWithZone:zone];
        copy.shortDescription = [self.shortDescription copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.forumId = self.forumId;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.code = [self.code copyWithZone:zone];
        copy.topCommentedUsers = [self.topCommentedUsers copyWithZone:zone];
        copy.commentsCount = self.commentsCount;
    }
    
    return copy;
}


@end
