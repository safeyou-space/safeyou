//
//  SYSwitchControl.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYSwitchControl.h"

@implementation SYSwitchControl

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialViewData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialViewData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(switchStateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self initialViewData];
}

- (void)initialViewData
{
    self.backgroundColorAlpha = 1;
    self.tintColorAlpha = 1;
    self.onTintColoAlpha = 1;
    self.onThumbTintColorAlpha = 1;
    self.offThumbTintColorAlpha = 1;
    
    self.layer.cornerRadius = 16;
}

- (void)switchStateChanged:(SYSwitchControl *)sender
{
    [self setOn:sender.on animated:YES];
}

- (void)prepareForInterfaceBuilder
{
    self.layer.cornerRadius = 16;
    [self configThumbOnOffTintColor];
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

- (void)setTintColorType:(NSInteger)tintColorType
{
    _tintColorType = tintColorType;
    [self configureTintColor];
}

- (void)setTintColorAlpha:(CGFloat)tintColorAlpha
{
    _tintColorAlpha = tintColorAlpha;
    [self configureTintColor];
}

- (void)configureTintColor
{
    
    NSInteger tintColorType = _tintColorType;
    
    if(tintColorType < SYColorTypeNone || tintColorType > SYColorTypeLast) {
        self.tintColor = [UIColor clearColor];
    } else {
        UIColor *tintColor = [UIColor colorWithSYColor:self.tintColorType alpha:1.0];
        if(_tintColorAlpha == 1 || self.tintColorAlpha == -1) {
            self.tintColor = tintColor;
        } else {
            self.tintColor = [UIColor getColor:tintColor withAlpha:_tintColorAlpha];
        }
    }
}

- (void)setOnTintColorType:(NSInteger)onTintColorType
{
    _onTintColorType = onTintColorType;
    [self configureOnTintColor];
}

- (void)setOnTintColoAlpha:(CGFloat)onTintColoAlpha
{
    _onTintColoAlpha = onTintColoAlpha;
    [self configureOnTintColor];
}

-(void)configureOnThumbTintColor
{
    
}

- (void)configureOnTintColor
{
    
    NSInteger onTintColorType = _onTintColorType;
    
    if(onTintColorType < SYColorTypeNone || onTintColorType > SYColorTypeLast) {
        self.tintColor = [UIColor clearColor];
    } else {
        UIColor *onTintColor = [UIColor colorWithSYColor:_onTintColorType alpha:1.0];
        if(_onTintColoAlpha == 1 || _onTintColoAlpha == -1) {
            self.onTintColor = onTintColor;
        } else {
            self.onTintColor = [UIColor getColor:onTintColor withAlpha:_onTintColoAlpha];
        }
    }
}

- (void)setOnThumbTintColorType:(NSInteger)onThumbTintColorType
{
    _onThumbTintColorType = onThumbTintColorType;
    [self configThumbOnOffTintColor];
}

-(void)setOnThumbTintColorAlpha:(CGFloat)onThumbTintColorAlpha
{
    _onThumbTintColorAlpha = onThumbTintColorAlpha;
    [self configThumbOnOffTintColor];
}

- (void)setOffThumbTintColorType:(NSInteger)offThumbTintColorType
{
    _offThumbTintColorType = offThumbTintColorType;
    [self configThumbOnOffTintColor];
}

- (void)setOffThumbTintColorAlpha:(CGFloat)offThumbTintColorAlpha
{
    _offThumbTintColorAlpha = offThumbTintColorAlpha;
    [self configThumbOnOffTintColor];
}

- (void)configThumbOnOffTintColor
{
    UIColor *thumbTintColor;
    
    if(self.isOn) {
        if(self.onThumbTintColorType < SYColorTypeNone || self.onThumbTintColorType > SYColorTypeLast) {
            thumbTintColor = [UIColor clearColor];
        } else {
            if (_onThumbTintColorAlpha == 1) {
                thumbTintColor = [UIColor colorWithSYColor:self.onThumbTintColorType alpha:1.0];
            } else {
                UIColor *thumbTintColor = [UIColor colorWithSYColor:self.onThumbTintColorType alpha:self.onThumbTintColorAlpha];
            }
        }
        
    } else {
        if(self.offThumbTintColorType < SYColorTypeNone || self.offThumbTintColorType > SYColorTypeLast) {
            thumbTintColor = [UIColor clearColor];
        } else {
            if (_offThumbTintColorAlpha == 1) {
                thumbTintColor = [UIColor colorWithSYColor:_offThumbTintColorType alpha:1.0];
            } else {
                thumbTintColor = [UIColor colorWithSYColor:_offThumbTintColorType alpha:_offThumbTintColorAlpha];
            }
        }
    }
    
    [self setThumbTintColor:thumbTintColor];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    [super setOn:on animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configThumbOnOffTintColor];
    });
    
}

@end
