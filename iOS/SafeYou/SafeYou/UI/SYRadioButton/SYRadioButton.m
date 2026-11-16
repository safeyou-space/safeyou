//
//  SYRadioButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYRadioButton.h"

@implementation SYRadioButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageColorType = SYColorTypeOtherAccent;
    [self setImage:[UIImage imageNamed:@"radio_button_pink_selected"] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"radion_button_pink_empty"] forState:UIControlStateNormal];
}


- (void)handleClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

@end
