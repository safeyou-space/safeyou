//
//  ChangePinViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/10/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChangePinViewController.h"

@interface ChangePinViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SYRegualrTextField *realiPinField;
@property (weak, nonatomic) IBOutlet SYRegualrTextField *realPinConfirmField;
@property (weak, nonatomic) IBOutlet SYRegualrTextField *fakePinField;
@property (weak, nonatomic) IBOutlet SYRegualrTextField *fakePinConfirmField;
@property (strong, nonatomic) IBOutletCollection(SYRegualrTextField) NSArray *allTextFieldsCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *fieldsStackView;

@property (weak, nonatomic) IBOutlet SYCorneredButton *saveButton;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backButton;

- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)textDidChange:(UITextField *)sender;
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)cancelEditingTapAction:(UITapGestureRecognizer *)sender;

// Data
@property (nonatomic) NSString *realPin;
@property (nonatomic) NSString *confirmRealPin;
@property (nonatomic) NSString *fakePin;
@property (nonatomic) NSString *confirmFakePin;


@end

@implementation ChangePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self enableKeyboardNotifications];
    [self configuretextFields];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor1];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.realiPinField.placeholder = LOC(@"enter_real_pin_text_key");
    self.realPinConfirmField.placeholder = LOC(@"confirm_real_pin_text_key");
    self.fakePinField.placeholder = LOC(@"enter_fake_pin_text_key");
    self.fakePinConfirmField.placeholder = LOC(@"confirm_fake_pin_text_key");
    [self.saveButton setTitle:LOC(@"save_key") forState:UIControlStateNormal];
}

#pragma mark - Customize UI Elements

- (void)configuretextFields
{
    for (SYTextField *textField in self.allTextFieldsCollection) {
        textField.delegate = self;
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}


#pragma mark - Actions

- (IBAction)cancelEditingTapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(createPinViewDidCancel:)]) {
        [self.delegate createPinViewDidCancel:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textDidChange:(UITextField *)sender {
    if (sender == self.realiPinField) {
        self.realPin = sender.text;
    }
    
    if (sender == self.realPinConfirmField) {
        self.confirmRealPin = sender.text;
    }
    
    if (sender == self.fakePinField) {
        self.fakePin = sender.text;
    }
    
    if (sender == self.fakePinConfirmField) {
        self.confirmFakePin = sender.text;
    }
}

- (IBAction)saveButtonAction:(UIButton *)sender {
    if ([self isFormCompleted]) {
        [Settings sharedInstance].userPin = self.realPin;
        [Settings sharedInstance].userFakePin = self.fakePin;
        if (self.isUpdating) {
            if ([self.delegate respondsToSelector:@selector(createPinViewDidUpdatePin:)]) {
                [self.delegate createPinViewDidUpdatePin:self];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(createPinViewDidCreatePin:)]) {
                [self.delegate createPinViewDidCreatePin:self];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Validation

- (BOOL)isFormCompleted
{
    if (self.realPin.length != 4) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pin_length_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if (![self.realPin isEqualToString:self.confirmRealPin]) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pins_do_not_match_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if ([self.realPin isEqualToString:self.fakePin]) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"real_pin_fake_pin_different") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if (self.fakePin.length !=4) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pin_length_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if (![self.fakePin isEqualToString:self.fakePin]) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pins_do_not_match_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    return YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length == 4) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

@end
