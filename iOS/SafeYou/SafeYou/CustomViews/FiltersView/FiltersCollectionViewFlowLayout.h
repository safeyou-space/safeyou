//
//  FiltersCollectionViewFlowLayout.h
//  SafeYou
//
//  Created by MacBook Pro on 04.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FiltersCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat itemsMaxSpace;

- (instancetype)initWithItemMaxSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
