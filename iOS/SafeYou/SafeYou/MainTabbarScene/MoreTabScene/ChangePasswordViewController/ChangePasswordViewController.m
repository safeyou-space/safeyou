//
//  ChangePasswordViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SYAuthenticationService.h"
#import "PasswordTextField.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backBarBUttonItem;

@property (weak, nonatomic) IBOutlet SYLabelBold *currentPasswordTitleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *creatingPasswordTitleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *confirmCreatingPasswordTitleLabel;

@property (weak, nonatomic) IBOutlet PasswordTextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet PasswordTextField *passwordNewTextField;
@property (weak, nonatomic) IBOutlet PasswordTextField *confirmNewPasswordTextField;
@property (weak, nonatomic) IBOutlet SYCorneredButton *savePasswordButton;
@property (weak, nonatomic) IBOutlet SYCorneredButton *cancelChangesButton;
@property (weak, nonatomic) IBOutlet SYButtonBold *forgotPasswordButton;

- (IBAction)savePasswordButtonPressed:(UIButton *)sender;
- (IBAction)cancelChangesButtonPressed:(UIButton *)sender;
- (IBAction)forgotPasswordButtonPressed:(UIButton *)sender;

@property (nonatomic) SYAuthenticationService *passwordService;

@end

@implementation ChangePasswordViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.passwordService = [[SYAuthenticationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureTextFields];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor1];
}

#pragma mark - Customize

- (void)configureTextFields
{
    self.currentPasswordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordNewTextField.returnKeyType = UIReturnKeyNext;
    self.confirmNewPasswordTextField.returnKeyType = UIReturnKeyDone;
    
    self.currentPasswordTextField.delegate = self;
    self.passwordNewTextField.delegate = self;
    self.confirmNewPasswordTextField.delegate = self;
}

#pragma mark - Override

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"change_password_key");
    self.backBarBUttonItem.title = LOC(@"back");
    self.currentPasswordTitleLabel.text = LOC(@"current_password_text_key");
    self.creatingPasswordTitleLabel.text = LOC(@"new_password_title_key");;
    self.confirmCreatingPasswordTitleLabel.text = LOC(@"confirm_new_password");
    self.currentPasswordTextField.placeholder = LOC(@"current_password_text_key");
    self.passwordNewTextField.placeholder = LOC(@"new_password_title_key");
    self.confirmNewPasswordTextField.placeholder = LOC(@"confirm_new_password");
    [self.savePasswordButton setTitle:[LOC(@"save_key") uppercaseString] forState:UIControlStateNormal];
    [self.cancelChangesButton setTitle:[LOC(@"cancel") uppercaseString] forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:LOC(@"title_forgot_password") forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)backbarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelEditingTapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)savePasswordButtonPressed:(UIButton *)sender {
    
    NSString *errorString;
    if (self.currentPasswordTextField.text.length > 0) {
        if (self.passwordNewTextField.text.length >= 8) {
            if ([self.passwordNewTextField.text isEqualToString:self.confirmNewPasswordTextField.text]) {
                weakify(self);
                [self showLoader];
                [self.passwordService changePassowrd:self.currentPasswordTextField.text withNewPassword:self.passwordNewTextField.text confirmPassword:self.confirmNewPasswordTextField.text withComplition:^(id  _Nonnull response) {
                    strongify(self);
                    [self hideLoader];
                    [self showAlertViewWithTitle:LOC(@"success_text_key") withMessage:LOC(@"password_update_success_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    } okAction:nil];
                } failure:^(NSError * _Nonnull error) {
                    strongify(self);
                    [self hideLoader];
                    
                }];
            } else {
                errorString = LOC(@"passwords_not_match_text_key");
            }
        } else {
            errorString = LOC(@"please_enter_valid_password_message_key");
        }
    } else {
        errorString = LOC(@"fill_current_password_field_text_key");
    }
    
    if (errorString.length > 0) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:errorString cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
}

- (IBAction)cancelChangesButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)forgotPasswordButtonPressed:(UIButton *)sender
{
    // show forgot password view
    [self showForgotPasswordFlow:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.currentPasswordTextField) {
        [self.passwordNewTextField becomeFirstResponder];
    } else if (textField == self.passwordNewTextField) {
        [self.confirmNewPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmNewPasswordTextField) {
        [self.confirmNewPasswordTextField resignFirstResponder];
    }
    
    return YES;
}

@end
