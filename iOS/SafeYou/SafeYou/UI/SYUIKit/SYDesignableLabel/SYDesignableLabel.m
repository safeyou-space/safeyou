//
//  SYDesignableLabel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableLabel.h"
#import "UIColor+SYColors.h"

@implementation SYDesignableLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.textColorAlpha = -1;
        self.backgroundColorAlpha = -1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColorAlpha = -1;
        self.backgroundColorAlpha = -1;
    }
    return self;
}

- (void)setTextColorType:(NSInteger)textColorType
{
    _textColorType = textColorType;
    [self configureTextColor];
}

- (void)setTextColorAlpha:(CGFloat)textColorAlpha
{
    _textColorAlpha = textColorAlpha;
    [self configureTextColor];
}

- (void)configureTextColor
{
    NSInteger textColorType = _textColorType;
    if(textColorType < SYColorTypeNone || textColorType > SYColorTypeLast) {
        
    } else {
        UIColor *textColor = [UIColor colorWithSYColor:self.textColorType alpha:self.textColorAlpha];
        if(_textColorAlpha == 1 || _textColorAlpha == -1) {
            textColor = textColor;
        } else {
            textColor = [UIColor getColor:textColor withAlpha:_textColorAlpha];
        }
        self.textColor = textColor;
    }
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
    
    if(backgroundColorType < SYColorTypeNone || _backgroundColorType > SYColorTypeLast) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        UIColor *backgroundColor = [UIColor colorWithSYColor:self.backgroundColorType alpha:self.backgroundColorAlpha];
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
    [self.layer setCornerRadius:_cornerRadius];
}

#pragma mark - Customization


@end
