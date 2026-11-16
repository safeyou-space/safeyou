//
//  HyRobotoLabelRegular.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "HyRobotoLabelRegular.h"

@implementation HyRobotoLabelRegular

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// FONT FAMILY

/*
 HayRoboto-Black
 HayRoboto-BlackItalic
 HayRoboto-Bold
 HayRoboto-BoldItalic
 HayRoboto-Italic
 HayRoboto-Light
 HayRoboto-LightItalic
 HayRoboto-Medium
 HayRoboto-MediumItalic
 HayRoboto-Normal
 HayRoboto-Regular
 HayRoboto-Thin
 HayRoboto-ThinItalic
 */


- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.font.pointSize;
    [self setFont:[UIFont fontWithName:@"HayRoboto-Regular" size:pointSize]];
}

@end
