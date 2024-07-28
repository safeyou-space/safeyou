//
//  SYLabelBoldItalic.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYLabelBoldItalic.h"

@implementation SYLabelBoldItalic

/*
OpenSans
*/

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.font.pointSize;
    [self setFont:[UIFont boldItalicFontOfSize:pointSize]];
}

@end
