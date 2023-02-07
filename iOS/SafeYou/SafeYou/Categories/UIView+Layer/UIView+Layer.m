//
//  UIView+Layer.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/27/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

- (void)roundCorners:(UIRectCorner)corners topLeftRadius:(CGFloat)topLeftRadius topRightRadius:(CGFloat)topRightRadius bottomRightRadius:(CGFloat)bottomRightRadius bottomLeftRadius:(CGFloat)bottomLeftRadius
{
    CGFloat minx = CGRectGetMinX(self.bounds);
    CGFloat miny = CGRectGetMinY(self.bounds);
    CGFloat maxx = CGRectGetMaxX(self.bounds);
    CGFloat maxy = CGRectGetMaxY(self.bounds);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(minx + topLeftRadius, miny)];
    [path addLineToPoint:CGPointMake(maxx - topRightRadius, miny)];
    [path addArcWithCenter:CGPointMake(maxx - topRightRadius, miny + topRightRadius) radius: topRightRadius startAngle: 3 * M_PI_2 endAngle: 0 clockwise: YES];
    [path addLineToPoint:CGPointMake(maxx, maxy - bottomRightRadius)];
    [path addArcWithCenter:CGPointMake(maxx - bottomRightRadius, maxy - bottomRightRadius) radius: bottomRightRadius startAngle: 0 endAngle: M_PI_2 clockwise: YES];
    [path addLineToPoint:CGPointMake(minx + bottomLeftRadius, maxy)];
    [path addArcWithCenter:CGPointMake(minx + bottomLeftRadius, maxy - bottomLeftRadius) radius: bottomLeftRadius startAngle: M_PI_2 endAngle:M_PI clockwise: YES];
    [path addLineToPoint:CGPointMake(minx, miny + topLeftRadius)];
    [path addArcWithCenter:CGPointMake(minx + topLeftRadius, miny + topLeftRadius) radius: topLeftRadius startAngle: M_PI endAngle:3 * M_PI_2 clockwise: YES];
    [path closePath];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

@end
