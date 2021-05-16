//
//  ForumDescriptionCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumItemDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ForumDescriptionCell : UITableViewCell

- (void)configureWithForumData:(ForumItemDataModel *)forumItemData;

@end

NS_ASSUME_NONNULL_END
