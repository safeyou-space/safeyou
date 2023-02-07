//
//  UIColor+SYColors.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/18/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UIColor+SYColors.h"

#pragma mark - Main TintColor Purple
static NSString * const mainTitnColorHex1 = @"#DC5D78";
static NSString * const mainTitnColorHex2 = @"#DF6D85";
static NSString * const mainTitnColorHex3 = @"#E37D93";
static NSString * const mainTitnColorHex4 = @"#EA9DAE";
static NSString * const mainTitnColorHex5 = @"#F1BEC9";
static NSString * const mainTitnColorHex6 = @"#F8DEE4";
static NSString * const mainTitnColorHex7 = @"#FBEFF2";
static NSString * const mainTitnColorHex8 = @"#FEFBFC";

static NSString * const gradientColorBottomHex = @"#6F2984";
static NSString * const gradientColoeTopHex = @"#C783DC";

static NSString * const gradientColorOtherGray = @"#F5F5F5";

static NSString * const blackColorHex = @"#1D1D1D"; //black
static NSString * const darkGrayColorHex = @"#818181"; // dark gray
static NSString * const lightGrayColorHex = @"#C6C6C6"; // light gray
static NSString * const whiteColorHex =  @"#FFFFFF"; // white

static NSString * const navyBlueColorHex = @"#142A3B"; // navy blue
static NSString * const blueColorHex = @"#1F3C53"; // blue
static NSString * const lightBlueColorHex = @"#20BAFF"; // light blue
static NSString * const greenColorHex = @"#30BF05"; // green
static NSString * const redColorHex1 = @"#FE0000"; // red1
static NSString * const redColorHex2 = @"#F2253A"; // red2
static NSString * const purpleColorHex1 = @"#9A3F7F"; // purple1



@implementation UIColor (SYColors)

#pragma mark - Application colors

+ (UIColor *)getColor:(UIColor*)color withAlpha:(CGFloat)alpha
{
    return [color colorWithAlphaComponent:alpha];
}

+ (UIColor *)mainTintColor1
{
    return [UIColor colorFromHexString:mainTitnColorHex1];
}

+ (UIColor *)mainTintColor2
{
    return [UIColor colorFromHexString:mainTitnColorHex2];
}

+ (UIColor *)mainTintColor3
{
    return [UIColor colorFromHexString:mainTitnColorHex3];
}

+ (UIColor *)mainTintColor4
{
    return [UIColor colorFromHexString:mainTitnColorHex4];
}

+ (UIColor *)mainTintColor5
{
    return [UIColor colorFromHexString:mainTitnColorHex5];
}

+ (UIColor *)mainTintColor6
{
    return [UIColor colorFromHexString:mainTitnColorHex6];
}

+ (UIColor *)mainTintColor7
{
    return [UIColor colorFromHexString:mainTitnColorHex7];
}

+ (UIColor *)mainTintColor8
{
    return [UIColor colorFromHexString:mainTitnColorHex8];
}

+ (UIColor *)gradientColorBottom
{
    return [UIColor colorFromHexString:gradientColorBottomHex];
}

+ (UIColor *)gradientColorTop
{
    return [UIColor colorFromHexString:gradientColoeTopHex];
}

+ (UIColor *)gradientColorOtherGray
{
    return [UIColor colorFromHexString:gradientColorOtherGray];
}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorFromHexString:lightBlueColorHex];
}

+ (UIColor *)blackColor
{
    return [UIColor colorFromHexString:blackColorHex];
}

+ (UIColor *)darkGrayColor
{
    return [UIColor colorFromHexString:darkGrayColorHex];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorFromHexString:lightGrayColorHex];
}

+ (UIColor *)whiteColor
{
    return [UIColor colorFromHexString:whiteColorHex];
}

+ (UIColor *)navyBlueColor
{
    return [UIColor colorFromHexString:navyBlueColorHex];
}

+ (UIColor *)blueColor
{
    return [UIColor colorFromHexString:blueColorHex];
}

+ (UIColor *)greenColor
{
    return [UIColor colorFromHexString:greenColorHex];
}

+ (UIColor *)redColor1
{
    return [UIColor colorFromHexString:redColorHex1];
}

+ (UIColor *)redColor2
{
    return [UIColor colorFromHexString:redColorHex2];
}

+ (UIColor *)purpleColor1
{
    return [UIColor colorFromHexString:purpleColorHex1];
}

#pragma marl - Color factory for color types

+ (UIColor *)colorWithSYColor:(SYColorType)colorType alpha:(CGFloat)alpha
{
    UIColor *color;
    switch (colorType) {
        case SYColorTypeMain1:
            color = [UIColor mainTintColor1];
            break;
        case SYColorTypeMain2:
            color = [UIColor mainTintColor2];
            break;
        case SYColorTypeMain3:
            color = [UIColor mainTintColor3];
            break;
        case SYColorTypeMain4:
            color = [UIColor mainTintColor4];
            break;
        case SYColorTypeMain5:
            color = [UIColor mainTintColor5];
            break;
        case SYColorTypeBlack:
            color = [UIColor blackColor];
            break;
        case SYColorTypeDarkGray:
            color = [UIColor darkGrayColor];
            break;
        case SYColorTypeLightGray:
            color = [UIColor lightGrayColor];
            break;
        case SYColorTypeWhite:
            color = [UIColor whiteColor];
            break;
        case SYColorTypeNavyBlue:
            color = [UIColor navyBlueColor];
            break;
        case SYColorTypeBlue:
            color = [UIColor blueColor];
            break;
        case SYColorTypeGreen:
            color = [UIColor greenColor];
            break;
            
        case SYColorTypeRed:
            color = [UIColor redColor];
            break;
            
        case SYGradientColorTypeBottom:
            color = [UIColor gradientColorBottom];
            break;
            
        case SYGradientColorTypeTop:
            color = [UIColor gradientColorTop];
            break;
            
        case SYColorTypeOtherGray:
            color = [UIColor gradientColorOtherGray];
            break;
            
        case SYColorTypeLightBlue:
            color = [UIColor lightBlueColor];
            break;
            
        case SYColorTypeMain6:
            color = [UIColor mainTintColor6];
            break;
            
        case SYColorTypeMain7:
            color = [UIColor mainTintColor7];
            break;
            
        case SYColorTypeMain8:
            color = [UIColor mainTintColor8];
            break;
        case SYColorTypeOtherAccent:
            color = [UIColor purpleColor1];
            break;
            
        default:
            color = [UIColor whiteColor];
            break;
    }
    color = [color colorWithAlphaComponent:alpha];
    
    return color;
}

#pragma mark - Category helper
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    CGFloat alphaParam = 1.0;
    if (alpha > 0) {
        alphaParam = alpha;
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alphaParam];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
