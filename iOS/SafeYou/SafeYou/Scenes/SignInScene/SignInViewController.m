//
//  SignInViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SignInViewController.h"
#import "UIColor+SYColors.h"
#import "UIStyles.h"
#import "SYAuthenticationService.h"
#import "SYProfileService.h"
#import "VerifyPhoneNumberViewController.h"
#import "AppDelegate.h"

@interface SignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *phoneNumbertextField;
@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet HyRobotoButton *signInButton;
@property (weak, nonatomic) IBOutlet HyRobotoButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet HyRobotoButton *signUpButton;

@property (weak, nonatomic) HyRobotoRegualrTextField *activeField;

@property (nonatomic) SYAuthenticationService *loginService;
@property (nonatomic) SYProfileService *profileDataService;

@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *password;


@end

@implementation SignInViewController

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
    self.phoneNumbertextField.text = [Settings sharedInstance].countryPhoneCode;
    [self configureGradientBackground];
    [self registerForKeyboardNotifications];
    
    self.title = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

#pragma mark - Requests

- (void)updateLocalizations
{
    self.phoneNumbertextField.placeholder = LOC(@"mobile_number_text_key");
    self.passwordTextField.placeholder = LOC(@"password_text_key");
    
    self.titleLabel.text = LOC(@"title_login");
    [self.signInButton setTitle:LOC(@"title_login") forState:UIControlStateNormal];
    [self.signUpButton setTitle:LOC(@"title_signup") forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:LOC(@"title_forgot_password") forState:UIControlStateNormal];
}

#pragma mark - Webservice Requests

- (void)performSignInAction
{
    weakify(self);
    [self showLoader];
    [self.loginService loginUserWithPhoneNumber:self.phoneNumbertextField.text andPassword:self.passwordTextField.text withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        if ([response[@"statuseCode"] integerValue] == 202) {
            [self resendSMSCodeInBackground];
            [self performSegueWithIdentifier:@"showVerifyPhoneNumberView" sender:self.phoneNumber];
        } else {
            if (response[@"refresh_token"] && response[@"access_token"]) {
                [Settings sharedInstance].userRefreshToken = response[@"refresh_token"];
                [Settings sharedInstance].userAuthToken = response[@"access_token"];
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
                [self handleSignInError:error];
                return;
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
        [Settings sharedInstance].onlineUser = userData;
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

- (void)handleSignInError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSDictionary *errorsDict = errorInfo[@"message"];
    NSString *firstErrorKey = [errorsDict allKeys].firstObject;
    NSArray *errorsArray = errorsDict[firstErrorKey];
    NSString *errorMessage = [self textFromStringsArray:errorsArray];
    
    if (!errorMessage.length) {
        errorMessage = errorInfo[@"message"];
    }
    
    [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:errorMessage cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    
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
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    UIColor *color1 = [UIColor colorWithSYColor:SYGradientColorTypeBottom alpha:1.0];
    UIColor *color2 = [UIColor colorWithSYColor:SYGradientColorTypeTop alpha:1.0];
    gradient.colors = @[(id)color2.CGColor, (id)color1.CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - Actions

- (IBAction)cancelEditingTapPressed:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)signInButtonPressed:(UIButton *)sender
{
    if (self.phoneNumbertextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.phoneNumber = self.phoneNumbertextField.text;
        self.password = self.passwordTextField.text;
        [self performSignInAction];
    } else {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"fill_required_fields_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
}

- (IBAction)signUpButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"showRegistrationView" sender:nil];
}


- (IBAction)forgotPasswordButtonPressed:(UIButton *)sender
{
    [self showForgotPasswordFlow:self];
}



#pragma mark - handle Keyboard show/hide

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.signUpButton.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, self.signUpButton.frame.origin.y-kbSize.height);
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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
    self.activeField = (HyRobotoRegualrTextField *)textField;
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
        destinationVC.isFromRegistration = YES;
        destinationVC.phoneNumber = self.phoneNumber;
        destinationVC.password = self.password;
        destinationVC.phoneNumber = sender;
    }
    
}


@end
