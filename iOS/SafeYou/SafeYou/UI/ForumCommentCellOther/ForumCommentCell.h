//
//  ForumCommentCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumCommentDataModel, ForumCommentCell;

NS_ASSUME_NONNULL_BEGIN

@protocol ForumCommentCellDelegate <NSObject>

- (void)commentCellDidSelectReply:(ForumCommentCell *)cell;

@end



@interface ForumCommentCell : UITableViewCell

- (void)configureWithCommentData:(ForumCommentDataModel *)commentData;

@property (weak, nonatomic) id<ForumCommentCellDelegate> delegate;
@property (nonatomic, readonly) ForumCommentDataModel *commentData;


@end

NS_ASSUME_NONNULL_END
