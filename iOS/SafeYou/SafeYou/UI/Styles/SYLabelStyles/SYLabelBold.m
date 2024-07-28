//
//  SYLabelBold.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYLabelBold.h"

@implementation SYLabelBold

/*
OpenSans
*/


- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.font.pointSize;
    [self setFont:[UIFont boldFontOfSize:pointSize]];
}



@end
