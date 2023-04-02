//
//  FormTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "FormTableViewCell.h"
#import "Constants.h"
#import "SelectDateField.h"
#import "UIColor+SYColors.h"

@interface FormTableViewCell () <UITextFieldDelegate, DateFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *formTextField;
@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *textViewTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

- (IBAction)textFieldDidChange:(HyRobotoRegualrTextField *)sender;

@property (nonatomic) NSString *regex;

@end

@implementation FormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inputLength = -1;
    self.formTextField.delegate = self;
    self.arrowImageView.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.formTextField.placeholder = @"";
    self.formTextField.text = @"";
    self.formTextField.enabled = YES;
}

- (void)configureWithFieldType:(FormFieldType)fieldType dataType:(FormFieldDataType)fieldDataType title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value isRequired:(BOOL)isRequired
{
    self.formTextField.placeholder = placeholder;
    
    if (![title isEqualToString:placeholder]) {
//        self.formTextField.tit
    }
    if (fieldType == FormFieldTypeText) {
        self.formTextField.enabled = YES;
        if (fieldDataType == FormFieldDataTypeNumber) {
            [self createNumberTextFieldInputAccessoryView];
        }
    } else if (fieldType == FormFieldTypePicker) {
        [self createBirthDatePickerView];
        ((SelectDateField *)self.formTextField).dateFieldDelegate = self;
    }  else if (fieldType == FormFieldTypePassword) {
        self.formTextField.secureTextEntry = YES;
        [self configureRightViewButtonForPasswordField];
    } else {
        self.formTextField.secureTextEntry = NO;
        self.formTextField.rightView = nil;
        self.formTextField.rightViewMode = UITextFieldViewModeNever;
    }
    
    if (value) {
        self.formTextField.text = value;
    }
}

- (void)configureRightViewButtonForPasswordField
{
    UIButton *rightViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.formTextField.frame.size.height, self.formTextField.frame.size.height)];
    

    UIImage *closeEyeImage = [[UIImage imageNamed:@"eye_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *openEyeImage = [[UIImage imageNamed:@"eye_open"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [rightViewButton setImage:closeEyeImage forState:UIControlStateNormal];
    [rightViewButton setImage:openEyeImage forState:UIControlStateSelected];
    if (self.eyeIconTintColorType) {
        UIColor *imagetintColor = [UIColor colorWithSYColor:self.eyeIconTintColorType alpha:1.0];
        [rightViewButton setTintColor:imagetintColor];
    }
    [rightViewButton addTarget:self action:@selector(rightViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.formTextField.rightView = rightViewButton;
    self.formTextField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)rightViewButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.formTextField.secureTextEntry = NO;
    } else {
        self.formTextField.secureTextEntry = YES;
    }
}

- (void)configureWithFieldType:(FormFieldType)fieldType dataType:(FormFieldDataType)fieldDataType title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value regex:(NSString *)regex isRequired:(BOOL)isRequired returnType:(UIReturnKeyType)returnKeyType;
{
    if (isRequired) {
        placeholder = [NSString stringWithFormat:@"%@ *", placeholder];
    }
    if (fieldType == FormFieldTypeLargeText) {
        self.textViewTitleLabel.text = title;
        self.inputTextView.text = value;
        self.inputTextView.delegate = self;
    } else {
        [self configureWithFieldType:fieldType dataType:fieldDataType title:title placeholder:placeholder value:value isRequired:isRequired];
        self.regex = regex;
        self.formTextField.returnKeyType = returnKeyType;
        if (fieldDataType == FormFieldDataTypeNumber) {
            [self createNumberTextFieldInputAccessoryView];
        } else if (fieldDataType == FormFieldDataTypePhoneNumber){
            [self createPhoneNumberTextFieldInputAccessoryView];
        } else if (fieldDataType == FormFieldDataTypeChooseOption) {
            self.formTextField.selectedPlaceholderColorAlpha = 0;
            self.arrowImageView.hidden = NO;
            self.formTextField.enabled = NO;
        } else {
            self.formTextField.inputAccessoryView = nil;
            self.formTextField.keyboardType = UIKeyboardTypeDefault;
        }
        self.formTextField.text = value;
    }
}

- (void)resetCell
{
    self.formTextField.text = @"";
    self.formTextField.rightViewImage = nil;
    self.formTextField.enabled = YES;
}

- (void)createPhoneNumberTextFieldInputAccessoryView
{
    NSString *returnKeyString;
    if(self.formTextField.returnKeyType == UIReturnKeyDefault) {
        returnKeyString = LOC(@"return_key");
    } else if(self.formTextField.returnKeyType == UIReturnKeyNext) {
        returnKeyString = LOC(@"next_key");
    } else if(self.formTextField.returnKeyType == UIReturnKeyDone) {
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
    
    self.formTextField.keyboardType = UIKeyboardTypePhonePad;
    self.formTextField.inputAccessoryView = numberToolbar;
    [self.formTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)createNumberTextFieldInputAccessoryView
{
    NSString *returnKeyString;
    if(self.formTextField.returnKeyType == UIReturnKeyDefault) {
        returnKeyString = LOC(@"return_key");
    } else if(self.formTextField.returnKeyType == UIReturnKeyNext) {
        returnKeyString = LOC(@"next_key");
    } else if(self.formTextField.returnKeyType == UIReturnKeyDone) {
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
    
    self.formTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.formTextField.inputAccessoryView = numberToolbar;
    [self.formTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)createBirthDatePickerView
{
    SelectDateField *dateField = (SelectDateField *)self.formTextField;
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    [offsetComponents setYear:-90]; // note that I'm setting it to -1
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    [offsetComponents setYear:-12];
    NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    
    [offsetComponents setYear:-18];
    NSDate *currentDate = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    dateField.width = self.contentView.frame.size.width;
    dateField.date = currentDate;
    dateField.minDate = minDate;
    dateField.maxDate = maxDate;
    dateField.datePickerMode = UIDatePickerModeDate;
    
    dateField.dateFormat = @"dd/MM/YYYY";
    [dateField setupPickerView];
}

- (void)numberTextFieldNextButtonPrressed
{
    [self resignFirstResponder];
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    if ([self.formCellDelegate respondsToSelector:@selector(formTableViewCell:didChangeText:)]) {
        [self.formCellDelegate formTableViewCell:self didChangeText:sender.text];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.formCellDelegate respondsToSelector:@selector(formTableViewCell:didChangeText:)]) {
        [self.formCellDelegate formTableViewCell:self didChangeText:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newString.length > 144) {
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.formCellDelegate respondsToSelector:@selector(formTableViewCellShouldRetrun:returnKeyType:)]) {
        [self.formCellDelegate formTableViewCellShouldRetrun:self returnKeyType:textField.returnKeyType];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (self.inputLength !=-1 && self.inputLength > 0) {
        if (textField.text.length >= self.inputLength) {
            return NO;
        }
    }
    
    if ([self.formCellDelegate respondsToSelector:@selector(formCell:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.formCellDelegate formCell:self shouldChangeCharactersInRange:range replacementString:string];
    }
    // allow backspace
    if (!string.length) {
        return YES;
    }
    
    // Prevent invalid character input, if keyboard is numberpad
    
    if (self.regex && self.regex.length > 0) {
        NSPredicate *validationPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex];
        
        NSString *validatingText = [NSString stringWithFormat:@"%@%@",textField.text, string];
        
        return [validationPredicate evaluateWithObject:validatingText];
    }
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad || textField.keyboardType == UIKeyboardTypeDecimalPad) {
                
        NSString *numberRegex = @"^[0-9]+$";
        NSPredicate *validationPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        
        NSString *validatingText = [NSString stringWithFormat:@"%@%@",textField.text, string];
        
        return [validationPredicate evaluateWithObject:validatingText];
        
    }
    return YES;
}

- (void)selectDateFieldValueChanged:(SelectDateField *)dateField
{
    if ([self.formCellDelegate respondsToSelector:@selector(formTableViewCell:didChangeText:)]) {
        [self.formCellDelegate formTableViewCell:self didChangeText:dateField.text];
    }
}

- (void)dateFiledShouldReturn:(SelectDateField *)dateField;
{
    [self textFieldDidChange:dateField];
    if ([self.formCellDelegate respondsToSelector:@selector(formTableViewCellShouldRetrun:returnKeyType:)]) {
        [self.formCellDelegate formTableViewCellShouldRetrun:self returnKeyType:dateField.returnKeyType];
    }
}

#pragma mark - Override

- (BOOL)becomeFirstResponder
{
    return [self.formTextField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.formTextField resignFirstResponder];
}

@end
