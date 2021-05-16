//
//  PinNumberView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/1/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "PinNumberView.h"

@interface PinNumberView ()

@property (strong, nonatomic) IBOutletCollection(SYDesignableButton) NSArray *numberOutletCollection;

@property (weak, nonatomic) IBOutlet SYDesignableButton *forgotPinButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *backSpaceButton;

@property (weak, nonatomic) IBOutlet SYDesignableButton *number1;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number2;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number3;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number4;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number5;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number6;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number7;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number8;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number9;
@property (weak, nonatomic) IBOutlet SYDesignableButton *number0;

@end

@implementation PinNumberView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateLocalizations
{
    [self.forgotPinButton setTitle:LOC(@"forgot_pin_text_key") forState:UIControlStateNormal];
}

#pragma mark - Actions
- (IBAction)numberButtonPressed:(UIButton *)sender
{
    NSString *value;
    if (sender == self.number0) {
        value = @"0";
    }
    
    if (sender == self.number1) {
        value = @"1";
    }
    
    if (sender == self.number2) {
        value = @"2";
    }
    
    if (sender == self.number3) {
        value = @"3";
    }
    
    if (sender == self.number4) {
        value = @"4";
    }
    
    if (sender == self.number5) {
        value = @"5";
    }
    
    if (sender == self.number6) {
        value = @"6";
    }
    
    if (sender == self.number7) {
        value = @"7";
    }
    
    if (sender == self.number8) {
        value = @"8";
    }
    
    if (sender == self.number9) {
        value = @"9";
    }
    
    if ([self.delegate respondsToSelector:@selector(numberView:didSelectNumber:)]) {
        [self.delegate numberView:self didSelectNumber:value];
    }
}

- (IBAction)backspaceButtonPressed:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(numberViewDidSelectBackspace:)]) {
        [self.delegate numberViewDidSelectBackspace:self];
    }
}

- (IBAction)forgotPinButtonPressed:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(numberViewDidSelectForgotPin:)]) {
        [self.delegate numberViewDidSelectForgotPin:self];
    }
}

@end
