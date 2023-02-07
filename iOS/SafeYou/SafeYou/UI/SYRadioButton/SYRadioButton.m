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


- (void)handleClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.selected) {
        [self setImage:[UIImage imageNamed:@"radio_button_pink_selected"] forState:UIControlStateSelected];
    } else {
        [self setImage:[UIImage imageNamed:@"radion_button_pink_empty"] forState:UIControlStateNormal];}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
