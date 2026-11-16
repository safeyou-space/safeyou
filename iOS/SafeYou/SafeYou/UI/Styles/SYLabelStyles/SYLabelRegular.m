//
//  HyRobotoLabelRegular.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYLabelRegular.h"

@implementation SYLabelRegular

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// FONT FAMILY

/*
 OpenSans
 */


- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.font.pointSize;
    UIFont *font = [UIFont regularFontOfSize:pointSize];
    [self setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.adjustsFontForContentSizeCategory = YES;
}

@end
