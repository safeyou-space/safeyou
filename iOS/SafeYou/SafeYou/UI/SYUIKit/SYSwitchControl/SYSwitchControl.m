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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.subviews[0].subviews[0].backgroundColor = [UIColor whiteColor];
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
    self.tintColor = [UIColor whiteColor];
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
    self.tintColor = [UIColor whiteColor];
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

- (void)configureOnTintColor
{
    self.onTintColor = [UIColor whiteColor];
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

    if ([self isOn]) {
        [self setThumbTintColor:[UIColor mainTintColor3]];
        self.layer.borderColor = [UIColor mainTintColor3].CGColor;

    } else {
        [self setThumbTintColor:[UIColor grayColor1]];
        self.layer.borderColor = [UIColor grayColor1].CGColor;
    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    [super setOn:on animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configThumbOnOffTintColor];
    });
    
}

@end
