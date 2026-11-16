//
//  SYDesignableView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableView.h"
#import "UIColor+SYColors.h"


@interface SYDesignableView()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong)  UIColor *gradientTopColor;
@property (nonatomic, strong)  UIColor *gradientBottomColor;

@end

@implementation SYDesignableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)prepareForInterfaceBuilder
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setGradientBackground];
}

- (void)setBackgroundColorType:(NSInteger)backgroundColorType
{
    _backgroundColorType = backgroundColorType;
    [self configureBackgroundColor];
}


- (void)setBackgroundColorAlpha:(CGFloat)backgroundColorAlpha
{
    _backgroundColorAlpha = backgroundColorAlpha;
    [self configureBackgroundColor];
}

- (void)configureBackgroundColor
{
    
    NSInteger backgroundColorType = _backgroundColorType;
    
    if(backgroundColorType < SYColorTypeNone || backgroundColorType > SYColorTypeLast) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        UIColor *backgroundColor = [UIColor colorWithSYColor:backgroundColorType alpha:self.backgroundColorAlpha];
        self.backgroundColor = backgroundColor;
    }
}

- (void)setBorderColorType:(NSInteger)borderColorType
{
    _borderColorType = borderColorType;
    
    if(_borderColorType < SYColorTypeNone || _borderColorType > SYColorTypeLast) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        UIColor *borderColor = [UIColor colorWithSYColor:_borderColorType alpha:1.0];
        self.layer.borderColor = borderColor.CGColor;
        
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setShadowColorType:(NSInteger)shadowColorType
{
    _shadowColorType = shadowColorType;
    
    if(_shadowColorType < SYColorTypeNone || _shadowColorType > SYColorTypeLast) {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    } else {
        self.layer.masksToBounds = NO;
        UIColor *shadowColor = [UIColor colorWithSYColor:_shadowColorType alpha:1.0];
        self.layer.shadowColor = shadowColor.CGColor;
        if (self.cornerRadius > 0) {
            self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius].CGPath;
        }
        
    }
}


- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = _shadowOffset;
}


- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    self.layer.shadowRadius = _shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    self.layer.shadowOpacity = _shadowOpacity;
}

- (void)setGradientTopColorType:(NSInteger)gradientTopColorType
{
    _gradientTopColorType = gradientTopColorType;
    if(_gradientTopColorType < SYColorTypeNone || _gradientTopColorType > SYColorTypeLast) {
        self.gradientTopColor = nil;
    } else {
        self.gradientTopColor = [UIColor colorWithSYColor:_gradientTopColorType alpha:1.0];
    }
    [self setGradientBackground];
}

- (void)setGradientBottomColorType:(NSInteger)gradientBottomColorType
{
    _gradientBottomColorType = gradientBottomColorType;
    if(_gradientBottomColorType < SYColorTypeNone || _gradientBottomColorType > SYColorTypeLast) {
        self.gradientBottomColor = nil;
    } else {
        self.gradientBottomColor = [UIColor colorWithSYColor:_gradientTopColorType alpha:1.0];
    }
    [self setGradientBackground];
}

- (void)setGradientBackground
{
    if(self.gradientTopColor && self.gradientBottomColor) {
        if(self.gradientLayer) {
            [self.gradientLayer removeFromSuperlayer];
        } else {
            self.gradientLayer = [[CAGradientLayer alloc] init];
        }
        
        [self.gradientLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        NSArray *colorsArray = [NSArray arrayWithObjects:(id)self.gradientTopColor.CGColor, (id)self.gradientBottomColor.CGColor, nil];
        [self.gradientLayer setColors:colorsArray];
        
        if(self.isHorizontal) {
            self.gradientLayer.startPoint = CGPointMake(0, 0.5);
            self.gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        } else {
            self.gradientLayer.startPoint = CGPointMake(0.5, 0);
            self.gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        }
        
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    } else {
        [self.gradientLayer removeFromSuperlayer];
    }
}

@end
