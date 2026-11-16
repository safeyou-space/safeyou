//
//  CreatePasswordViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/26/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#define ERRORVIEW_HEIGHT 65

#import "CreatePasswordViewController.h"
#import "RegistrationViewController.h"
#import "RegistrationDataModel.h"
#import "SYAuthenticationService.h"
#import "PasswordTextField.h"


@interface CreatePasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet SYLabelBold *mainTitleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *secondaryTitleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableView *errorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorViewHeightConstraint;
@property (weak, nonatomic) IBOutlet SYLabelRegular *errorTextLabel;

@property (weak, nonatomic) IBOutlet SYLabelBold *passwordFieldTitleLabel;
@property (weak, nonatomic) IBOutlet SYTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet SYLabelBold *confirmPasswordTitleLabel;
@property (weak, nonatomic) IBOutlet PasswordTextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet SYCorneredButton *nextButton;

@property (nonatomic) SYAuthenticationService *updatePasswordService;

@end

@implementation CreatePasswordViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.updatePasswordService = [[SYAuthenticationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showErrorView:NO];
    [self configureUIElements];
}

#pragma mark - ConfigureUI

- (void)configureUIElements
{
    self.nextButton.enabled = false;
    self.passwordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.secureTextEntry = YES;
}


- (void)updateLocalizations
{
    self.mainTitleLabel.text = LOC(@"create_your_password_text");
    self.secondaryTitleLabel.text = LOC(@"please_enter_valid_password_message_key");
}
#pragma mark - Private

- (BOOL)isFormComleted
{
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        self.errorTextLabel.text = LOC(@"passwords_not_match_text_key");
        [self showErrorView:YES];
        return NO;
    }
    if ( self.passwordTextField.text.length < 8) {
        self.errorTextLabel.text = LOC(@"please_enter_valid_password_message_key");
        [self showErrorView:YES];
        return NO;
    }

    NSString *passwordRegex = @"^.{8,}$";
    NSPredicate *validationPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    if (![validationPredicate evaluateWithObject:self.passwordTextField.text]) {
        self.errorTextLabel.text = LOC(@"please_enter_valid_password_message_key");
        [self showErrorView:YES];
        return NO;
    }
    return YES;
}

- (void)showErrorView:(BOOL)show
{
    self.errorView.hidden = !show;
    if (show) {
        self.errorViewHeightConstraint.constant = ERRORVIEW_HEIGHT;
    } else {
        self.errorViewHeightConstraint.constant = 0;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - Actions
- (IBAction)nextButtonAction:(SYCorneredButton *)sender {
    if ([self isFormComleted]) {
        if (self.isRecoverFlow) {
            [self performUpdatePassword];
        } else {
            [self performSegueWithIdentifier:@"showAccountDetailsView" sender:nil];
        }
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDidChange:(SYTextField *)sender {
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        self.nextButton.enabled = YES;
    }
}


#pragma Mark - Update Password

- (void)performUpdatePassword
{
    weakify(self);
    [self showLoader];
    [self.updatePasswordService createNewpassowrd:self.passwordTextField.text confirm:self.confirmPasswordTextField.text token:self.recoveryToken andPhoneNumber:self.phoneNumber withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        [self navigateToSourceView];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        [self handleError:error.userInfo];
    }];
}

- (void)navigateToSourceView
{
    if (self.navigationController.viewControllers.count == 3) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    } else {
        NSInteger destinationIdex = self.navigationController.viewControllers.count - 4; // -1-3 (number of forgot password flow controllers)
        UIViewController *destinationVC = self.navigationController.viewControllers[destinationIdex];
        [self.navigationController popToViewController:destinationVC animated:YES];
    }
}

- (void)handleError:(NSDictionary *)errorInfo
{
    NSString *message = @"";
    if (errorInfo[@"message"]) {
        if ([errorInfo[@"message"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *errorMessageDict = errorInfo[@"message"];
            if ([errorMessageDict[@"message"] isKindOfClass:[NSArray class]]) {
                message = errorMessageDict[@"message"][0];
            } else if (errorMessageDict[@"password"]) {
                NSArray *messages = errorMessageDict[@"password"];
                message = messages.firstObject;
            } else if (errorMessageDict[@"password"]) {
                NSArray *messages = errorMessageDict[@"confirm_password"];
                message = messages.firstObject;
            } else {
                message = errorMessageDict[@"message"];
            }
        } else {
            message = errorInfo[@"message"];
        }
    }
    [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:message cancelButtonTitle:nil okButtonTitle:LOC(@"ok") cancelAction:nil okAction:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAccountDetailsView"]) {
        RegistrationViewController *destinationVC = segue.destinationViewController;
        RegistrationDataModel *registrationData = [[RegistrationDataModel alloc] init];
        registrationData.password = self.passwordTextField.text;
        registrationData.confirmPassword = self.confirmPasswordTextField.text;
        registrationData.phoneNumber = self.phoneNumber;
        destinationVC.registrationData = registrationData;
    }
}

@end
