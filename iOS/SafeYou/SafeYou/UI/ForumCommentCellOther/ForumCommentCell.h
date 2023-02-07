//
//  ForumCommentCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMessageDataModel, ForumCommentCell;

NS_ASSUME_NONNULL_BEGIN

@protocol ForumCommentCellDelegate <NSObject>

- (void)commentCellDidSelectLike:(NSNumber *)messageId isLiked:(BOOL)isLiked;
- (void)commentCellDidSelectMessage:(ForumCommentCell *)cell;
- (void)commentCellDidSelectReply:(ForumCommentCell *)cell;
- (void)commentCellDidSelectMore:(ForumCommentCell *)cell moreButton:(SYDesignableButton *)button;
- (void)commentCellDidSelectImage:(ForumCommentCell *)cell;

@end



@interface ForumCommentCell : UITableViewCell

- (void)configureWithMessageData:(ChatMessageDataModel *)messageData andUserAge:(BOOL)isMinorUser;

@property (weak, nonatomic) id<ForumCommentCellDelegate> delegate;
//@property (nonatomic, readonly) ChatMessageDataModel *messageData;
@property (nonatomic) ChatMessageDataModel *messageData;


@end

NS_ASSUME_NONNULL_END
