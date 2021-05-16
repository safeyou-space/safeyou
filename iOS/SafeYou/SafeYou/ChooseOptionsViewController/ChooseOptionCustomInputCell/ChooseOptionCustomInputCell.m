//
//  ChooseOptionCustomInputCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/27/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ChooseOptionCustomInputCell.h"

@interface ChooseOptionCustomInputCell ()

@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *fieldTitleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *inputTextField;

@end

@implementation ChooseOptionCustomInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inputTextField.disableFloatingLabel = YES;
    [self.inputTextField addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithTitle:(NSString *)title placeholder:(NSString *)placeholder
{
    self.fieldTitleLabel.text = title;
    self.inputTextField.placeholder = placeholder;
}

- (NSString *)inputvalue
{
    return self.inputTextField.text;
}

#pragma mark - Text Field Callback

- (void)textFieldDidChangeText:(UITextField *)textField
{
    NSString *text = textField.text;
    if ([self.delegate respondsToSelector:@selector(customOptionCell:didChangeText:)]) {
        [self.delegate customOptionCell:self didChangeText:text];
    }
}

#pragma mark - Functionality

- (void)setIsSelect:(BOOL)isSelect
{
    [super setIsSelect:isSelect];
    if (self.chooseOptionType == SYChooseOptionTypeRadio) {
        self.checkDeactiveImageView.hidden = NO;
    } else {
        self.checkDeactiveImageView.hidden = YES;
    }
    [self configureSelectedState];
}


- (void)configureSelectedState
{
    if (self.isSelect) {
        [self.inputTextField becomeFirstResponder];
    } else {
        [self.inputTextField resignFirstResponder];
    }
}

@end
