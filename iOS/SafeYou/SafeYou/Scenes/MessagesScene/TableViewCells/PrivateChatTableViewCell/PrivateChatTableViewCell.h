//
//  PrivateChatTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/28/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMessageDataModel, MessageFileDataModel, PrivateChatTableViewCell;

@class ChatMessageDataModel;

NS_ASSUME_NONNULL_BEGIN

@protocol PrivateChatTableViewCellDelegate <NSObject>

- (void)commentCellDidSelectImage:(PrivateChatTableViewCell *)cell;
- (void)commentCellDidSelectPlayAudio:(PrivateChatTableViewCell *)cell;
- (void)commentCellDidSelectPauseAudio;

@end

@interface PrivateChatTableViewCell : UITableViewCell

@property (nonatomic, readonly) ChatMessageDataModel *messageData;
@property (nonatomic) MessageFileDataModel *messageFileDataModel;
@property (weak, nonatomic) id<PrivateChatTableViewCellDelegate> delegate;

- (void)configureWithMessageData:(ChatMessageDataModel *)messageData;
- (void)stopPlayingAudio;

@end

NS_ASSUME_NONNULL_END
