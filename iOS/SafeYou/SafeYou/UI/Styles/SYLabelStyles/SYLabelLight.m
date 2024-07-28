//
//  SYLabelLight.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYLabelLight.h"

@implementation SYLabelLight


/*
OpenSans
*/


- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.font.pointSize;
    UIFont *font = [UIFont lightFontOfSize:pointSize];
    [self setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.adjustsFontForContentSizeCategory = YES;
}

@end
