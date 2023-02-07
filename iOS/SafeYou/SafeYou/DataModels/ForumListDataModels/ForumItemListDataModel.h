//
//  ForumItemListDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
@class ForumItemDataModel;


@interface ForumItemListDataModel : BaseDataModel

@property (nonatomic, strong) NSArray <ForumItemDataModel *>*forumItems;
@property (nonatomic) NSInteger lastPage;


@end
