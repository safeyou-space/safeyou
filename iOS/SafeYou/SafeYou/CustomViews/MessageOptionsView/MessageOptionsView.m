//
//  MessageOptionsView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/27/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "MessageOptionsView.h"
#import "UIView+AutoLayout.h"

static const CGFloat kButtonHeight = 50;
static const CGFloat kButtonWidth = 170;

@interface MessageOptionsView ()

@property (nonatomic, weak) SYDesignableView *contentView;

@end

@implementation MessageOptionsView

#pragma mark - Initialisation Methods

- (instancetype)initWithButtonsArray:(NSArray<MessageOptionButton *> *)buttonsArray {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        MessageOptionsView *customView = [[[NSBundle mainBundle] loadNibNamed:@"MessageOptionsView" owner:self options:nil] objectAtIndex:0];
        self.contentView = customView;
        [self addSubviewWithZeroMargin:self.contentView];
        self.frame = [self createViewWithButtons:buttonsArray];
    }
    return self;
}

#pragma mark - Private Methods

- (CGRect )createViewWithButtons:(NSArray<MessageOptionButton *> *)buttonsArray {
    CGFloat index = 0;
    for (MessageOptionButton *button in buttonsArray) {
        button.frame = CGRectMake(0, index * kButtonHeight, kButtonWidth, kButtonHeight);
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        index += 1;
    }
    return CGRectMake(0, 0, kButtonWidth, index * kButtonHeight);
}

#pragma mark - Action Methods

- (IBAction)buttonSelected:(MessageOptionButton *)sender {
    if ([self.delegate respondsToSelector:@selector(messageOptionsDidSelectButton:)]) {
        [self.delegate messageOptionsDidSelectButton:sender];
    }
}

@end
