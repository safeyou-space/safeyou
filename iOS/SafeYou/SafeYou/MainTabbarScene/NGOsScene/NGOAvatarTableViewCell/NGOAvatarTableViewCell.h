//
//  AvatarTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/6/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NGOAvatarCellViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol NGOAvatarTableViewCellDelegate <NSObject>

- (void)ngoAvatarCellDidPressPrivateChat;

@end

@interface NGOAvatarTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NGOAvatarTableViewCellDelegate> delegate;

- (void)configureCell:(NGOAvatarCellViewModel *)viewModel hideChatButton:(BOOL)hideChatButton;

@end

NS_ASSUME_NONNULL_END
