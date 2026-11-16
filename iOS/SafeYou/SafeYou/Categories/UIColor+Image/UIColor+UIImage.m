//
//  UIColor+UIImage.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/10/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "UIColor+UIImage.h"

@implementation UIColor (UIImage)

- (UIImage *)getImageWithPoint:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
