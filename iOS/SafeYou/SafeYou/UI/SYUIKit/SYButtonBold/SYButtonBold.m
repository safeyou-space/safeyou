//
//  SYButtonBold.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/24/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "SYButtonBold.h"

@implementation SYButtonBold

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.titleLabel.font.pointSize;
    self.titleLabel.font = [UIFont boldFontOfSize:pointSize];
}

@end
