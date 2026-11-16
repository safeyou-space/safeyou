//
//  RecordDetailsViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"
@class RecordListItemDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecordDetailsViewController : SYViewController

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSArray <RecordListItemDataModel *> *recordsList;

@end

NS_ASSUME_NONNULL_END
