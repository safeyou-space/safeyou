//
//  SYSemiRoundedView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/24/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYSemiRoundedView.h"

@interface SYSemiRoundedView ()

@property (nonatomic) UIRectCorner topLeftCorner;
@property (nonatomic) UIRectCorner topRightCorner;
@property (nonatomic) UIRectCorner bottomLeftCorner;
@property (nonatomic) UIRectCorner bottomRightCorner;

@end

@implementation SYSemiRoundedView

- (void)drawRect:(CGRect)rect {
    [self configureCorners];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self configureCorners];
}

- (void)configureCorners
{
    if (self.topLeft) {
        self.topLeftCorner = UIRectCornerTopLeft;
    } else {
        self.topLeftCorner = 0;
    }
    
    if (self.topRigth) {
        self.topRightCorner = UIRectCornerTopRight;
    } else {
        self.topRightCorner = 0;
    }
    
    if (self.bottomLeft) {
        self.bottomLeftCorner = UIRectCornerBottomLeft;
    } else {
        self.bottomLeftCorner = 0;
    }
    
    if (self.bottomRigth) {
        self.bottomRightCorner = UIRectCornerBottomRight;
    } else {
        self.bottomRightCorner = 0;
    }
    
    UIRectCorner corners = (self.topLeftCorner | self.topRightCorner | self.bottomLeftCorner | self.bottomRightCorner);
    [self roundCorners:corners];
}

- (void)roundCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(corners) cornerRadii:CGSizeMake(self.cornerRadius, 0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    super.cornerRadius = cornerRadius;
    self.layer.cornerRadius = 0;
}

@end
