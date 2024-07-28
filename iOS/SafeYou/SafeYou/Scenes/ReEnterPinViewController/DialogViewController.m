//
//  ReEnterPinViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/19/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "DialogViewController.h"
#import "SYProfileService.h"

@interface DialogViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet SYDesignableButton *closeButton;
@property (weak, nonatomic) IBOutlet SYLabelBold *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *hintTextLabel;
@property (weak, nonatomic) IBOutlet SYRegualrTextField *pinTextField;
@property (weak, nonatomic) IBOutlet SYSemiRoundedView *contentView;
@property (weak, nonatomic) IBOutlet SYCorneredButton *acceptButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)closeButtonAction:(UIButton *)sender;
- (IBAction)acceptButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewPositionConstraint;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic) SYProfileService *profileService;


@end

@implementation DialogViewController

+ (instancetype)instansiateDialogViewWithType:(DialogViewType)type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DialogViewController" bundle:nil];
    NSString *viewControllerId;
    if (type == DialogViewTypeCreatePin || type == DialogViewTypeEditPin) {
        viewControllerId = @"DialogViewControllerTextField";
    } else if (type == DialogViewTypeCountPicker) {
        viewControllerId = @"DialogViewControllerPickerView";
    } else {
        viewControllerId = @"DialogViewControllerActionButton";
    }
    DialogViewController *dialogView = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];
    dialogView.actionType = type;
    
    return dialogView;
}

+ (instancetype)instansiateDialogViewWithType:(DialogViewType)type title:(NSString *)title message:(NSString *)message
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DialogViewController" bundle:nil];
    NSString *viewControllerId;
    if (type == DialogViewTypeCreatePin || type == DialogViewTypeEditPin) {
        viewControllerId = @"DialogViewControllerTextField";
    } else if (type == DialogViewTypeCountPicker) {
        viewControllerId = @"DialogViewControllerPickerView";
    } else {
        viewControllerId = @"DialogViewControllerActionButton";
    }
    DialogViewController *dialogView = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];
    dialogView.actionType = type;
    dialogView.titleText = title;
    dialogView.message = message;
    
    return dialogView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileService = [[SYProfileService alloc] init];
    }
    
    return self;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[[UIColor navyBlueColor] colorWithAlphaComponent:0.9]];
    self.pickedElement =  self.pickerElementsArray[0];
    NSArray *options = [NSArray array];
    NSMutableArray *optionsArray = [NSMutableArray arrayWithArray:options];
    for (NSInteger i = 0; i < _pickerElementsArray.count; i++) {
        
        id object = _pickerElementsArray[i];
        if ([object isKindOfClass:[ProfileQuestionsOption class]]) {
            ProfileQuestionsOption *option = (ProfileQuestionsOption *)object;
            NSString *name = option.name;
            [optionsArray addObject:name];
        } else {
            NSLog(@"Object is not of the expected type");
        }
    }
    self.pickerData = optionsArray;
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pinTextField.keyboardType = self.keyboardType;
    [self enableKeyboardNotifications];
    [self.pinTextField becomeFirstResponder];
    self.cancelButton.hidden = !self.showCancelButton;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [[pickerView.subviews objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [_pickerData objectAtIndex:row];
    
    return label;
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.titleLabel.text = self.titleText;
    self.hintTextLabel.text = self.message;
    if (_continueButtonText.length == 0) {
        [self.acceptButton setTitle:  [LOC(@"continue_txt") capitalizedString] forState:UIControlStateNormal];
    } else {
        [self.acceptButton setTitle:  [_continueButtonText capitalizedString] forState:UIControlStateNormal];
    }
    [self.cancelButton setTitle:LOC(@"cancel") forState:UIControlStateNormal];
}

#pragma mark - Animation

- (void)shakeInputView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.07];
    [animation setRepeatCount:1];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.contentView center].x - 20.0f, [self.contentView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.contentView center].x + 20.0f, [self.contentView center].y)]];
    [[self.contentView layer] addAnimation:animation forKey:@"position"];
}

#pragma mark - UITextFieldDelegate

- (IBAction)didChangeText:(UITextField *)sender {
    if ([sender.text isEqualToString:self.correctValue]) {
        // success
        if ([self.delegate respondsToSelector:@selector(dialogViewDidEnterCorrectPin:)]) {
            [self.delegate dialogViewDidEnterCorrectPin:self];
        }
        [self closeDialogView];
    } else {
        if (sender.text.length == self.correctValue.length) {
            // shake
            [self shakeInputView];
            sender.text = @"";
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return textField.text.length < self.correctValue.length;
}


#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view.window convertRect:kbRect toView:self.view];
    CGRect textFieldRect = self.pinTextField.frame;
    CGRect convertedTextFieldRect = [self.contentView convertRect:textFieldRect toView:self.view];
    
    CGFloat diff = (convertedTextFieldRect.origin.y + convertedTextFieldRect.size.height)
    - kbRect.origin.y;
    if (diff > -5) {
        [UIView animateWithDuration:0.25 animations:^{
            self.contentViewPositionConstraint.constant = -self.pinTextField.frame.size.height;
            [self.view layoutSubviews];
        }];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

#pragma mark - Functionality

- (void)closeDialogView
{
    if (self.parentViewController) {
        [self willMoveToParentViewController:nil];
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Actions

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self closeDialogView];
    if ([self.delegate respondsToSelector:@selector(dialogViewDidCancel:)]) {
        [self.delegate dialogViewDidCancel:self];
    }
}

- (IBAction)acceptButtonAction:(UIButton *)sender {
    [self closeDialogView];
    if ([self.delegate respondsToSelector:@selector(dialogViewDidPressActionButton:)]) {
        [self.delegate dialogViewDidPressActionButton:self];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickedElement =  self.pickerElementsArray[row];
}

@end
