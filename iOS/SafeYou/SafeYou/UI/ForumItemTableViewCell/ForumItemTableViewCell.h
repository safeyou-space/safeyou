//
//  ForumItemTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/3/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumItemDataModel;
NS_ASSUME_NONNULL_BEGIN

@interface ForumItemTableViewCell : UITableViewCell

- (void)configureWithForumItem:(ForumItemDataModel *)forumItem;

@end

NS_ASSUME_NONNULL_END
