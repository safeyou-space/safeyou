//
//  FiltersView.h
//  SafeYou
//
//  Created by MacBook Pro on 06.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersView;

NS_ASSUME_NONNULL_BEGIN

@protocol FiltersViewDelegate <NSObject>

- (void)filterView:(FiltersView *)filterView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FiltersView : UIView

@property (nonatomic, weak) id <FiltersViewDelegate> delegate;

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) BOOL haveAllSelection;
@property (nonatomic) BOOL isMultiSelection;
@property (nonatomic, readonly) CGSize contentSize;

- (void)reloadData;
- (void)clearAllSelections;
- (NSArray<NSString *> *)getSelectedItems;

@end

NS_ASSUME_NONNULL_END
