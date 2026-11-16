//
//  EmergencyMessageFooterView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "EmergencyMessageFooterView.h"

@interface EmergencyMessageFooterView ( ) <UITextViewDelegate>

@end

@implementation EmergencyMessageFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emergencyTextView.editable = NO;
    self.emergencyTextView.tintColor = [UIColor mainTintColor2];
    self.emergencyTextView.returnKeyType = UIReturnKeyNext;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    // handle counter
}


- (IBAction)editButtonPressed:(UIButton *)sender {
    if (self.emergencyTextView.isFirstResponder) {
        self.emergencyTextView.editable = NO;
        [sender setImage:[UIImage imageNamed:@"edit_button"] forState:UIControlStateNormal];
        [self.emergencyTextView resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(emergencyMessageDidUpdate:)]) {
            [self.delegate emergencyMessageDidUpdate:self.emergencyTextView.text];
        }
    } else {
        self.emergencyTextView.editable = YES;
        [sender setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
        [self.emergencyTextView becomeFirstResponder];
    }
}


@end
