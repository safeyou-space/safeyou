//
//  ForumDetials.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForumDetialsData.h"
#import "ChatMessageDataModel.h"
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


@interface ForumDetialsData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) NSArray <ChatMessageDataModel *>*replyList;

@property (nonatomic) NSInteger viewLevel;

@end

@implementation ForumDetialsData

//@synthesize comments = _comments;
@synthesize shortDescription = _shortDescription;
@synthesize imagePath = _imagePath;
@synthesize forumId = _forumId;
@synthesize createdAt = _createdAt;
@synthesize title = _title;
@synthesize code = _code;
@synthesize topCommentedUsers = _topCommentedUsers;
@synthesize commentsCount = _commentsCount;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict level:(NSInteger)level {
    ForumDetialsData *forumdetailsInstance = [[self alloc] initWithDictionary:dict];
    forumdetailsInstance.viewLevel = level;
    return forumdetailsInstance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        
        self.shortDescription = [self objectOrNilForKey:kForumDetialsShortDescription fromDictionary:dict];
        self.imagePath = [self objectOrNilForKey:kForumDetialsImagePath fromDictionary:dict];
        self.forumId = [self objectOrNilForKey:kForumDetialsId fromDictionary:dict];
        self.createdAt = [self objectOrNilForKey:kForumDetialsCreatedAt fromDictionary:dict];
        self.title = [self objectOrNilForKey:kForumDetialsTitle fromDictionary:dict];
        self.code = [self objectOrNilForKey:kForumDetialsCode fromDictionary:dict];
        
        
    }
    
    return self;
}

#pragma mark - NSCoding Methods

@end
