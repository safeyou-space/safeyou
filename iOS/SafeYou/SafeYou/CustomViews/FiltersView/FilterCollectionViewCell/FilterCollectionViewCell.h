//
//  FilterCollectionViewCell.h
//  SafeYou
//
//  Created by MacBook Pro on 01.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FilterViewModel;

@interface FilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) FilterViewModel *viewModel;

- (void)configureWithViewModel:(FilterViewModel*)viewModel;
- (void)selectCell:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
