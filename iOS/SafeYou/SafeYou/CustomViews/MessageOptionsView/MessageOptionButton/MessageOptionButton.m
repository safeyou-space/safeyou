//
//  MessageOptionButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/29/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "MessageOptionButton.h"

@implementation MessageOptionButton

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image tag:(MessageButtonTag)tag {
    self = [super init];
    if (self) {
        self.tag = tag;
        if(title != nil) {
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if(image != nil) {
            [self setImage:image forState:UIControlStateNormal];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
    }
    return self;
}

@end
