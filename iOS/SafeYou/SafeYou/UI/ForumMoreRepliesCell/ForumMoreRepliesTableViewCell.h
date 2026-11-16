//
//  ForumMoreRepliesTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/24/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ForumMoreRepliesTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol MoreRepliesCellDelegate <NSObject>

- (void)didSelectViewMoreReplies:(ForumMoreRepliesTableViewCell *)selectedCell;

@end

@interface ForumMoreRepliesTableViewCell : UITableViewCell

- (void)configureWithNumber:(NSNumber *)repliesNumber;

@property (nonatomic, weak) id <MoreRepliesCellDelegate> viewMoreDelegate;

@end

NS_ASSUME_NONNULL_END
