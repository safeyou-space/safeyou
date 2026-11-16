//
//  ForumItemDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
@class ImageDataModel, ReviewDataModel;

@interface ForumItemDataModel : BaseDataModel

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSNumber *forumItemId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *topCommentedUsers;
@property (nonatomic, assign) NSInteger usersCount;
@property (nonatomic, strong) NSString *forumItemDescription;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, assign) NSInteger viewsCount;
@property (nonatomic, assign) NSInteger newMessagesCount;
@property (nonatomic, strong) ImageDataModel *imageData;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, assign) NSInteger ratesCount;
@property (nonatomic, assign) double rate;
@property (nonatomic, strong) ReviewDataModel *reviewData;

@property (nonatomic, strong) NSURL *imageURL;

@property (nonatomic) NSString *formattedCreatedAt;

// viewModel

@property (nonatomic, strong) NSString *descriptionAttributedText;

@end
