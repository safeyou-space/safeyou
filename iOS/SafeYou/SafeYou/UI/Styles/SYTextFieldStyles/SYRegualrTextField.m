//
//  SYRegualrTextField.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYRegualrTextField.h"

@implementation SYRegualrTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat pointSize = self.font.pointSize;
    UIFont *font = [UIFont regularFontOfSize:pointSize];
     [self setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.adjustsFontForContentSizeCategory = YES;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGFloat left = 0;
    CGFloat right = 0;
    if (self.leftViewMode == UITextFieldViewModeUnlessEditing ||
        self.leftViewMode == UITextFieldViewModeAlways) {
        left = self.leftView.bounds.size.width + 10;
    }
    if (self.rightViewMode == UITextFieldViewModeUnlessEditing ||
        self.rightViewMode == UITextFieldViewModeAlways) {
        right = self.rightView.bounds.size.width;
    }
    return CGRectMake(left, 1, bounds.size.width - left - right, bounds.size.height + 6);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGFloat left = 0;
    CGFloat right = 0;
    if (self.leftViewMode == UITextFieldViewModeWhileEditing ||
        self.leftViewMode == UITextFieldViewModeAlways) {
        left = self.leftView.bounds.size.width + 10;
    }
    if (self.rightViewMode == UITextFieldViewModeWhileEditing ||
        self.rightViewMode == UITextFieldViewModeAlways) {
        right = self.rightView.bounds.size.width;
    }
    return CGRectMake(left, 1, bounds.size.width - left - right, bounds.size.height + 6);
}

@end
