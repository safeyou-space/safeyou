//
//  UIFont+HyRoboto.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UIFont+HyRoboto.h"

/*
HayRoboto-Black
HayRoboto-BlackItalic
HayRoboto-Bold
HayRoboto-BoldItalic
HayRoboto-Italic
HayRoboto-Light
HayRoboto-LightItalic
HayRoboto-Medium
HayRoboto-MediumItalic
HayRoboto-Normal
HayRoboto-Regular
HayRoboto-Thin
HayRoboto-ThinItalic
*/


@implementation UIFont (HyRoboto)

+ (UIFont *)hyRobotoFontNormalOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"HayRoboto-Normal" size:size]) {
        return [UIFont fontWithName:@"HayRoboto-Normal" size:size];
    }
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

+ (UIFont *)hyRobotoFontRegularOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"HayRoboto-Regular" size:size]) {
        return [UIFont fontWithName:@"HayRoboto-Regular" size:size];
    }
    
    return [UIFont systemFontOfSize:size];
    
}

+ (UIFont *)hyRobotoFontMediumOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"HayRoboto-Medium" size:size]) {
        return [UIFont fontWithName:@"HayRoboto-Medium" size:size];
    }
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    
}

+ (UIFont *)hyRobotoFontBoldOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"HayRoboto-Bold" size:size]) {
        return [UIFont fontWithName:@"HayRoboto-Bold" size:size];
    }
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

+ (UIFont *)hyRobotoFontLightOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"HayRoboto-Light" size:size]) {
        return [UIFont fontWithName:@"HayRoboto-Light" size:size];
    }
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    
}

+ (UIFont *)hyRobotoFontThinOfSize:(CGFloat)size
{
    if ([UIFont fontWithName:@"HayRoboto-Thin" size:size]) {
        return [UIFont fontWithName:@"HayRoboto-Thin" size:size];
    }
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
}

@end
