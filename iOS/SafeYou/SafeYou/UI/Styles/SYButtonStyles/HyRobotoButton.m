//
//  HyRobotoButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "HyRobotoButton.h"

@implementation HyRobotoButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat pointSize = self.titleLabel.font.pointSize;
    [self.titleLabel setFont:[UIFont fontWithName:@"HayRoboto-Regular" size:pointSize]];
    
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

@end
