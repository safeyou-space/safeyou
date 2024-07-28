//
//  SYLabelMedium.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYLabelMedium.h"

@implementation SYLabelMedium

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
OpenSans
*/

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.font.pointSize;
    [self setFont:[UIFont mediumFontOfSize:pointSize]];
}

@end
