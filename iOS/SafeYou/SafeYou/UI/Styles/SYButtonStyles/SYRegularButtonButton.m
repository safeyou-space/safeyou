//
//  SYRegularButtonButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYRegularButtonButton.h"

@implementation SYRegularButtonButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat pointSize = self.titleLabel.font.pointSize;
    UIFont *font = [UIFont regularFontOfSize:pointSize];
    [self.titleLabel setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

@end
