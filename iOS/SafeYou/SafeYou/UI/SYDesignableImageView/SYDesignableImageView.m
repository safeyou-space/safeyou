//
//  SYDesignableImageView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/1/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableImageView.h"
#import "Settings.h"

@implementation SYDesignableImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _imageColorAlpha = 1;
        _backgroundColorAlpha = 1;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _imageColorAlpha = 1;
    _backgroundColorAlpha = 1;
}


- (void)prepareForInterfaceBuilder
{
}

- (void)setImageColorType:(NSInteger)imageColorType
{
    _imageColorType = imageColorType;
    [self configureImageColor];
}

- (void)setImageColorAlpha:(CGFloat)imageColorAlpha
{
    _imageColorAlpha = imageColorAlpha;
    [self configureImageColor];
}

- (void)configureImageColor
{
    if(_imageColorType < SYColorTypeNone || _imageColorType > SYColorTypeLast) {
        
    } else {
        UIColor *imageColor =  [UIColor colorWithSYColor:self.imageColorType alpha:1.0];
        if(_imageColorAlpha == 1 || _imageColorAlpha == -1) {
            imageColor = [UIColor getColor:imageColor withAlpha:_imageColorAlpha];
        } else {
            imageColor = [UIColor getColor:imageColor withAlpha:_imageColorAlpha];
        }
        
        [self setTintColor:imageColor];
        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self customInit];
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
        UIColor *backgroundColor = [UIColor colorWithSYColor:self.backgroundColorType alpha:1.0];
        if(_backgroundColorAlpha == 1 || _backgroundColorAlpha == -1) {
            self.backgroundColor = backgroundColor;
        } else {
            self.backgroundColor = [UIColor getColor:backgroundColor withAlpha:_backgroundColorAlpha];
        }
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColorType:(NSInteger)borderColorType
{
    _borderColorType = borderColorType;
    
    if(_borderColorType < SYColorTypeNone || _borderColorType > SYColorTypeLast) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        UIColor *borderColor = [UIColor colorWithSYColor:self.borderColorType alpha:1.0];
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)customInit
{
    self.image = _backgroundImage;
}

@end
