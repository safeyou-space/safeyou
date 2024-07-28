//
//  UIFont+AppFont.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (AppFont)

+ (UIFont *)regularFontOfSize:(CGFloat)size;
+ (UIFont *)italicFontOfSize:(CGFloat)size;
+ (UIFont *)mediumFontOfSize:(CGFloat)size;
+ (UIFont *)mediumItalicFontOfSize:(CGFloat)size;
+ (UIFont *)boldFontOfSize:(CGFloat)size;
+ (UIFont *)boldItalicFontOfSize:(CGFloat)size;
+ (UIFont *)extraBoldFontOfSize:(CGFloat)size;
+ (UIFont *)semiBoldFontOfSize:(CGFloat)size;
+ (UIFont *)lightFontOfSize:(CGFloat)size;
+ (UIFont *)lightItalicFontOfSize:(CGFloat)size;


@end

NS_ASSUME_NONNULL_END
