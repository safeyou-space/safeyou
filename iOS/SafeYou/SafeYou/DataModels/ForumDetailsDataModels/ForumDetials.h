//
//  ForumDetials.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
@class ForumCommentDataModel;


@interface ForumDetials : BaseDataModel

@property (nonatomic, strong) NSArray <ForumCommentDataModel *>*comments;
@property (nonatomic, strong) NSArray <ForumCommentDataModel *>*strippedComments;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *forumId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *topCommentedUsers;
@property (nonatomic, assign) NSInteger commentsCount;

// data for filter comments

@property (nonatomic) NSNumber *currentCommentId;
@property (nonatomic, readonly) NSArray <ForumCommentDataModel *>*originalComments;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict level:(NSInteger)level;

- (NSArray <ForumCommentDataModel *>*)fetchRepliesForComment:(ForumCommentDataModel *)comment;
- (ForumCommentDataModel *)fetchCommentForId:(NSNumber *)commentId;

@end
