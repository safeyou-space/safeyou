//
//  SYDesignableBarButtonItem.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableBarButtonItem.h"
#import "UIFont+AppFont.h"

@implementation SYDesignableBarButtonItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self applyStyles];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self applyStyles];
    }
    return self;
}

- (void)applyStyles
{
    [self setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldFontOfSize:15.0]} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldFontOfSize:14.0]} forState:UIControlStateHighlighted];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setTintColorType:(NSInteger)tintColorType
{
    _tintColorType = tintColorType;
    
    if (_tintColorType < SYColorTypeNone || _tintColorType > SYColorTypeLast) {
        self.tintColor = [UIColor clearColor];
    } else {
        self.tintColor = [UIColor colorWithSYColor:self.tintColorType alpha:1.0];
    }
}

@end
