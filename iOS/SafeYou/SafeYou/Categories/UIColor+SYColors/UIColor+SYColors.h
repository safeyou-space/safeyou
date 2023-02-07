//
//  UIColor+SYColors.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/18/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYColorType) {
    SYColorTypeNone = 0,
    SYColorTypeMain1 = 1,
    SYColorTypeMain2 = 2,
    SYColorTypeMain3 = 3,
    SYColorTypeMain4 = 4,
    SYColorTypeMain5 = 5,
    SYColorTypeBlack = 6,
    SYColorTypeDarkGray = 7,
    SYColorTypeLightGray = 8,
    SYColorTypeWhite = 9,
    SYColorTypeNavyBlue = 10,
    SYColorTypeBlue = 11,
    SYColorTypeGreen = 12,
    SYColorTypeRed = 13,
    SYGradientColorTypeBottom = 14,
    SYGradientColorTypeTop = 15,
    SYColorTypeBrown = 16,
    SYColorTypeOtherGray = 17,
    SYColorTypeLightBlue = 18,
    // new Accent Colors
    SYColorTypeMain6 = 19,
    SYColorTypeMain7 = 20,
    SYColorTypeMain8 = 21,
    SYColorTypeOtherAccent = 22,
    SYColorTypeLast = 23
};

@interface UIColor (SYColors)

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)getColor:(UIColor *)color withAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithSYColor:(SYColorType)colorType alpha:(CGFloat)alpha;

+ (UIColor *)mainTintColor1;

+ (UIColor *)mainTintColor2;

+ (UIColor *)mainTintColor3;

+ (UIColor *)mainTintColor4;

+ (UIColor *)mainTintColor5;

+ (UIColor *)mainTintColor6;

+ (UIColor *)mainTintColor7;

+ (UIColor *)mainTintColor8;

+ (UIColor *)blackColor;

+ (UIColor *)darkGrayColor;

+ (UIColor *)lightGrayColor;

+ (UIColor *)whiteColor;

+ (UIColor *)navyBlueColor;

+ (UIColor *)blueColor;

+ (UIColor *)greenColor;

+ (UIColor *)redColor1;

+ (UIColor *)redColor2;

+ (UIColor *)purpleColor1;

@end

NS_ASSUME_NONNULL_END
