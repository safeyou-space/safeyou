//
//  UITextField+UITextField_NumberPad.m
//  SafeYou
//
//  Created by Garnik Simonyan on 2/29/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "UITextField+UITextField_NumberPad.h"

@implementation UITextField (UITextField_NumberPad)

- (void)createNumberTextFieldInputAccessoryView
{
    NSString *returnKeyString;
    if(self.returnKeyType == UIReturnKeyDefault) {
        returnKeyString = LOC(@"return_key");
    } else if(self.returnKeyType == UIReturnKeyNext) {
        returnKeyString = LOC(@"next_key");
    } else if(self.returnKeyType == UIReturnKeyDone) {
        returnKeyString = LOC(@"done_key");
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc] init];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:returnKeyString style:UIBarButtonItemStyleDone target:self action:@selector(numberTextFieldNextButtonPrressed)],
                           nil];
    [numberToolbar setTintColor:[UIColor mainTintColor1]];
    [numberToolbar setBarTintColor:[UIColor lightGrayColor]];
    [numberToolbar sizeToFit];
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.inputAccessoryView = numberToolbar;
}

- (void)numberTextFieldNextButtonPrressed
{
    [self resignFirstResponder];
}

@end
