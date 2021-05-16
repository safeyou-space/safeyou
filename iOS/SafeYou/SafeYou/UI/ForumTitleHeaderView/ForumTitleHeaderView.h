//
//  ForumTitleHeaderView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableView.h"
@class ForumItemDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ForumTitleHeaderView : UITableViewHeaderFooterView

- (void)configureWithFourmData:(ForumItemDataModel *)forumData;

@end

NS_ASSUME_NONNULL_END
