//
//  ForumDetailsViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class SocketIOClient, ForumItemDataModel, ForumCommentDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ForumCommentsViewController : SYViewController

@property (nonatomic) ForumItemDataModel *forumItemData;

@property (nonatomic) ForumCommentDataModel *currentComment; // nil if level is 0

@property (nonatomic) BOOL isForComposing;

@property (nonatomic) NSInteger level;


@end

NS_ASSUME_NONNULL_END
