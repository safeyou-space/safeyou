//
//  UIView+AutoLayout.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/13/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)addSubviewWithZeroMargin:(UIView *)subView
{
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:subView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:0.0]];
}

@end
