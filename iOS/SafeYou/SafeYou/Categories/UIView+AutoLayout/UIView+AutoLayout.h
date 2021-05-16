//
//  UIView+AutoLayout.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/13/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AutoLayout)

- (void)addSubviewWithZeroMargin:(UIView *)subView;

@end

NS_ASSUME_NONNULL_END
