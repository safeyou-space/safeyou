//
//  SYDesignableAttributedLabel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableAttributedLabel.h"

@implementation SYDesignableAttributedLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configureLinkColor];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit
{
    
    [self configureTextColor];
    [self configureBackgroundColor];
}

- (void)setTextColorType:(NSInteger)textColorType
{
    _textColorType = textColorType;
    [self configureTextColor];
}

- (void)configureTextColor
{
    NSInteger textColorType = _textColorType;
    if(textColorType < SYColorTypeNone || textColorType > SYColorTypeLast) {
        self.text = @"Wrong text Color type";
    } else {
        UIColor *textColor = [UIColor colorWithSYColor:self.textColorType alpha:1];
        self.textColor = textColor;
    }
}

- (void)setBackgroundColorType:(NSInteger)backgroundColorType
{
    _backgroundColorType = backgroundColorType;
    [self configureBackgroundColor];
}

- (void)configureBackgroundColor
{
    NSInteger backgroundColorType = _backgroundColorType;
    
    if(backgroundColorType < SYColorTypeNone || backgroundColorType > SYColorTypeLast) {
        self.text = @"Wrong backgroun Color type";
    } else {
        UIColor *backgroundColor = [UIColor colorWithSYColor:self.backgroundColorType alpha:1];
        self.backgroundColor = backgroundColor;
    }
}

- (void)setLinkColorType:(NSInteger)linkColorType
{
    _linkColorType = linkColorType;
    [self configureLinkColor];
}

- (void)configureLinkColor
{
    NSInteger linkColorType = _linkColorType;
    UIColor *linkColor;
    
    if(linkColorType < SYColorTypeNone || linkColorType > SYColorTypeLast || !linkColorType) {
        linkColor = [UIColor colorWithSYColor:SYColorTypeMain2 alpha:1];;
    } else {
        linkColor = [UIColor colorWithSYColor:self.linkColorType alpha:1];
    }
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    linkAttributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleThick);
    linkAttributes[NSForegroundColorAttributeName] = linkColor;
    self.linkAttributes = linkAttributes;
}

@end

