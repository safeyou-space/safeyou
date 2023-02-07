//
//  SYDesignableButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableButton.h"
#import "UIColor+SyColors.h"

@implementation SYDesignableButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.titleColorTypeAlpha = -1;
        self.backgroundColorAlpha = -1;
    }
    return self;
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
        UIColor *backgroundColor = [UIColor colorWithSYColor:self.backgroundColorType alpha:self.backgroundColorAlpha];
            self.backgroundColor = backgroundColor;
    }
}

- (void)setTitleColorType:(NSInteger)titleColorType
{
    _titleColorType = titleColorType;
    [self configureTitleColor];
}

- (void)setTitleColorTypeAlpha:(CGFloat)titleColorTypeAlpha
{
    _titleColorTypeAlpha = titleColorTypeAlpha;
    [self configureTitleColor];
}

- (void)configureTitleColor
{
    NSInteger titleColorType = _titleColorType;
    if(titleColorType < SYColorTypeNone || titleColorType > SYColorTypeLast) {
        // todo handle
    } else {
        UIColor *titleColor = [UIColor colorWithSYColor:self.titleColorType alpha:self.titleColorTypeAlpha];
        
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

- (void)setImageColorType:(NSInteger)imageColorType
{
    _imageColorType = imageColorType;
    if(!self.isSelected) {
        [self changeImageTintColorWithColorType:_imageColorType];
    }
}

- (void)setSelectedImageColorType:(NSInteger)selectedImageColorType
{
    _selectedImageColorType = selectedImageColorType;
    if(self.isSelected) {
        [self changeImageTintColorWithColorType:_selectedImageColorType];
    }
}

- (void)changeImageTintColorWithColorType:(NSInteger)selectedImageColorType
{
    
    if(selectedImageColorType < SYColorTypeNone || selectedImageColorType > SYColorTypeLast) {
        
    } else {
        if (self.currentImage) {
            UIColor *imageColor = [UIColor colorWithSYColor:self.selectedImageColorType alpha:1.0];
            [self setTintColor:imageColor];
            self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        if(self.imageView.image) {
            UIColor *imageColor = [UIColor colorWithSYColor:self.selectedImageColorType alpha:1.0];
            [self setTintColor:imageColor];
            self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
    }
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

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self.layer setCornerRadius:_cornerRadius];
}


@end
