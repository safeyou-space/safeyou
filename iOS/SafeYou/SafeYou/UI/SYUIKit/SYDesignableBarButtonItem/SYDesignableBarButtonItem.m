//
//  SYDesignableBarButtonItem.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableBarButtonItem.h"

@implementation SYDesignableBarButtonItem

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
