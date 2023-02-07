//
//  UIView+Layer.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/27/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Layer)

- (void)roundCorners:(UIRectCorner)corners topLeftRadius:(CGFloat)topLeftRadius topRightRadius:(CGFloat)topRightRadius bottomRightRadius:(CGFloat)bottomRightRadius bottomLeftRadius:(CGFloat)bottomLeftRadius;

@end

NS_ASSUME_NONNULL_END
