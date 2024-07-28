//
//  UIFont+AppFont.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UIFont+AppFont.h"

/*
 OpenSans-Regular
 OpenSans-Italic
 OpenSans-Medium
 OpenSans-MediumItalic
 OpenSans-Bold
 OpenSans-BoldItalic
 OpenSans-Light
 OpenSans-LightItalic

 OpenSans-SemiBold
 OpenSans-SemiBoldItalic
 OpenSans-ExtraBold
 OpenSans-ExtraBoldItalic

*/


@implementation UIFont (AppFont)

+ (UIFont *)regularFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-Regular" size:size]) {
        return [UIFont fontWithName:@"OpenSans-Regular" size:size];
    }
    NSAssert(NO, @"Open Sans Font Regular not loaded!!!");
    return [UIFont systemFontOfSize:size];
    
}

+ (UIFont *)mediumFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-Medium" size:size]) {
        return [UIFont fontWithName:@"OpenSans-Medium" size:size];
    }
    NSAssert(NO, @"Open Sans Font Mediun not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    
}

+ (UIFont *)mediumItalicFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-MediumItalic" size:size]) {
        return [UIFont fontWithName:@"OpenSans-MediumItalic" size:size];
    }
    NSAssert(NO, @"Open Sans Font MediumItalic not loaded!!!");
    return [UIFont italicSystemFontOfSize:size];

}

+ (UIFont *)italicFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-Italic" size:size]) {
        return [UIFont fontWithName:@"OpenSans-Italic" size:size];
    }
    NSAssert(NO, @"Open Sans Font Italic not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

+ (UIFont *)boldFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-Bold" size:size]) {
        return [UIFont fontWithName:@"OpenSans-Bold" size:size];
    }
    NSAssert(NO, @"Open Sans Font Bold not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

+ (UIFont *)boldItalicFontOfSize:(CGFloat)size {
    if ([UIFont fontWithName:@"OpenSans-BoldItalic" size:size]) {
        return [UIFont fontWithName:@"OpenSans-BoldItalic" size:size];
    }
    NSAssert(NO, @"Open Sans Font Bold Italic not loaded!!!");
    return [UIFont italicSystemFontOfSize:size];
}

+ (UIFont *)extraBoldFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-ExtraBold" size:size]) {
        return [UIFont fontWithName:@"OpenSans-ExtraBold" size:size];
    }
    NSAssert(NO, @"Open Sans Font ExtraBold not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

+ (UIFont *)semiBoldFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-SemiBold" size:size]) {
        return [UIFont fontWithName:@"OpenSans-SemiBold" size:size];
    }
    NSAssert(NO, @"Open Sans Font SemiBold not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

+ (UIFont *)lightFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-Light" size:size]) {
        return [UIFont fontWithName:@"OpenSans-Light" size:size];
    }
    NSAssert(NO, @"Open Sans Font Light not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    
}

+ (UIFont *)lightItalicFontOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"OpenSans-LightItalic" size:size]) {
        return [UIFont fontWithName:@"OpenSans-LightItalic" size:size];
    }
    NSAssert(NO, @"Open Sans Font Light Italic not loaded!!!");
    return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
}

@end
