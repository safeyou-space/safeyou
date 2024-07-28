//
//  SignInPasswordViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#define ERRORVIEW_HEIGHT 65.0

#import "SignInPasswordViewController.h"
#import "UIColor+SYColors.h"
#import "UIStyles.h"
#import "SYAuthenticationService.h"
#import "SYProfileService.h"
#import "VerifyPhoneNumberViewController.h"
#import "AppDelegate.h"

@interface SignInPasswordViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backBarButton;
@property (weak, nonatomic) IBOutlet SYLabelBold *mainTitleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *fieldTitleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableView *errorView;
@property (weak, nonatomic) IBOutlet SYLabelRegular *errorTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorViewHeightConstraint;
@property (weak, nonatomic) IBOutlet SYTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet SYCorneredButton *nexButton;
@property (weak, nonatomic) IBOutlet SYRegularButtonButton *forgotPasswordButton;


@property (weak, nonatomic) SYRegualrTextField *activeField;

@property (nonatomic) SYAuthenticationService *loginService;
@property (nonatomic) SYProfileService *profileDataService;

@property (nonatomic) NSString *password;


@end

@implementation SignInPasswordViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.loginService = [[SYAuthenticationService alloc] init];
        self.profileDataService = [[SYProfileService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    [self registerForKeyboardNotifications];
    [self showErrorView:NO];
    self.title = @"";
    if ([[Settings sharedInstance] isLanguageRTL]) {
        self.passwordTextField.textAlignment = NSTextAlignmentRight;
    } else {
        self.passwordTextField.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

#pragma mark - Private

- (void)showErrorView:(BOOL)show
{
    self.errorView.hidden = !show;
    if (show) {
        self.errorViewHeightConstraint.constant = ERRORVIEW_HEIGHT;
    } else {
        self.errorViewHeightConstraint.constant = 0;
    }
}

#pragma mark - Requests

- (void)updateLocalizations
{
    self.passwordTextField.placeholder = LOC(@"password_text_key");
    
    self.mainTitleLabel.text = LOC(@"enter_your_password_text");
    [self.nexButton setTitle:LOC(@"title_login").capitalizedString forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:LOC(@"title_forgot_password") forState:UIControlStateNormal];
}

#pragma mark - Webservice Requests

- (void)performSignInAction
{
    weakify(self);
    [self showLoader];
    if (self.phoneNumber == nil) {
        self.phoneNumber = [Settings sharedInstance].onlineUser.phone;
    }
    [self.loginService loginUserWithPhoneNumber:self.phoneNumber andPassword:self.password withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        if ([response[@"statuseCode"] integerValue] == 202) {
            [self resendSMSCodeInBackground];
            [self performSegueWithIdentifier:@"showVerifyPhoneNumberView" sender:self.phoneNumber];
        } else {
            if (response[@"refresh_token"] && response[@"access_token"]) {
                [[Settings sharedInstance] activateUsingDualPin:NO];
                [self fetchUserProfileData];
            } else {
                // @TODO: temporary code
                [self hideLoader];
                [self performSegueWithIdentifier:@"showVerifyPhoneNumberView" sender:self.phoneNumber];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        NSDictionary *errorInfo = error.userInfo;
        NSString *message = LOC(@"something_went_wrong_text_key");
        if (errorInfo[@"message"]) {
            if ([errorInfo[@"message"] isKindOfClass:[NSDictionary class]]) {
                message = [self messageFromError:error];
            } else {
                message = errorInfo[@"message"];
            }
        }
        if (errorInfo[@"error_description"]) {
            message = errorInfo[@"error_description"];
        }
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:message cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }];
}

- (void)fetchUserProfileData
{
    weakify(self);
    [self.profileDataService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate openApplication:YES];
        if ([Settings sharedInstance].updatedFcmToken) {
            [self saveFcmToken];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

// @TODO: Dublicate code, need refactor
- (void)saveFcmToken
{
    [self.profileDataService updateUserDataField:@"device_token" value:[Settings sharedInstance].updatedFcmToken withComplition:^(id response) {
        [Settings sharedInstance].savedFcmToken = [Settings sharedInstance].updatedFcmToken;
        [Settings sharedInstance].updatedFcmToken = nil;
        
    } failure:^(NSError *error) {
        // handle Error
    }];
}


#pragma mark - Handle Errors

- (NSString *)messageFromError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSDictionary *errorsDict = errorInfo[@"message"];
    NSString *firstErrorKey = [errorsDict allKeys].firstObject;
    NSArray *errorsArray = errorsDict[firstErrorKey];
    NSString *errorMessage = [self textFromStringsArray:errorsArray];
    
    if (!errorMessage.length) {
        errorMessage = errorInfo[@"message"];
    }
    
    return errorMessage;
}

- (NSString *)textFromStringsArray:(NSArray *)stringsArray
{
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *errorText in stringsArray) {
        [mString appendString:[NSString stringWithFormat: @"%@\n", errorText]];
    }
    
    return [mString copy];
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
}

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    self.view.backgroundColor = [UIColor mainTintColor2];
}

#pragma mark - Actions

- (IBAction)cancelEditingTapPressed:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)backBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    if (self.passwordTextField.text.length > 0) {
        self.password = self.passwordTextField.text;
        [self performSignInAction];
    } else {
        self.errorTextLabel.text = LOC(@"fill_required_fields_text_key");
        [self showErrorView:YES];
    }
}

- (IBAction)forgotPasswordButtonAction:(UIButton *)sender {
    [self showForgotPasswordFlow:self];
}


#pragma mark - handle Keyboard show/hide

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}

#pragma mark - enable Keyboard Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UItextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = (SYRegualrTextField *)textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - Functionality

- (void)resendSMSCodeInBackground
{
    [self.loginService resendVerifyCodeToPhoneNumber:self.phoneNumber withComplition:^(id  _Nonnull response) {
    } failure:^(NSError * _Nonnull error) {
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showVerifyPhoneNumberView"]) {
        VerifyPhoneNumberViewController *destinationVC = segue.destinationViewController;
        destinationVC.phoneNumber = self.phoneNumber;
        destinationVC.password = self.password;
        destinationVC.phoneNumber = sender;
    }
    
}


@end
