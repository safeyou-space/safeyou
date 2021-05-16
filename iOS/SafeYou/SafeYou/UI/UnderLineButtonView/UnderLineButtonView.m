//
//  UnderLineButtonView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/13/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UnderLineButtonView.h"
#import "UIView+AutoLayout.h"

@interface UnderLineButtonView ()

@property (weak, nonatomic) IBOutlet SYDesignableButton *button;
@property (weak, nonatomic) IBOutlet SYDesignableView *underLineView;

- (IBAction)buttonAction:(UIButton *)sender;

@end

@implementation UnderLineButtonView


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        [self setupFromNib];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupFromNib];
}

- (void)setupFromNib
{
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"UnderLineButtonView" owner:self options:nil].firstObject;
    [self addSubviewWithZeroMargin:contentView];
    if (self.title.length > 0) {
        [self.button setTitle:self.title forState:UIControlStateNormal];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_selected) {
        self.button.titleColorType = SYColorTypeMain1;
        self.underLineView.backgroundColorType = SYColorTypeMain1;
        self.underLineView.backgroundColorAlpha = 1;
    } else {
        self.button.titleColorType = SYColorTypeLightGray;
        self.underLineView.backgroundColorAlpha = 0;
    }
}

- (IBAction)buttonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(underlineButtonAction:)]) {
        [self.delegate underlineButtonAction:self];
    }
}

@end
