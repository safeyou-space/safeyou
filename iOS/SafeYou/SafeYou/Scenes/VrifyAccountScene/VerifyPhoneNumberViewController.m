//
//  VerifyPhoneNumberViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "SYAuthenticationService.h"
#import "NewPasswordViewController.h"
#import "ApplicationLaunchCoordinator.h"
#import "SYProfileService.h"
#import "UITextField+UITextField_NumberPad.h"
#import "AppDelegate.h"

@interface VerifyPhoneNumberViewController () <UITextFieldDelegate>

{
    int currSeconds;
}

@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *infoTextLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *enterOTPTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputOTPTextField;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *resendPasswordTimerLabel;
@property (weak, nonatomic) IBOutlet HyRobotoButton *resendButton;
@property (weak, nonatomic) IBOutlet HyRobotoButton *nextButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *startEditingTap;

- (IBAction)resendButtonPressed:(UIButton *)sender;
- (IBAction)nextButtonPressed:(UIButton *)sender;
- (IBAction)cancelEditingAction:(UITapGestureRecognizer *)sender;
- (IBAction)startEditingTapAction:(UITapGestureRecognizer *)sender;

@property (nonatomic) NSTimer *second30Timer;

@property (nonatomic) NSString *insertedCode;

@property (nonatomic) SYAuthenticationService *verifyNumberService;
@property (nonatomic) SYProfileService *profileDataService;



@end

@implementation VerifyPhoneNumberViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.verifyNumberService = [[SYAuthenticationService alloc] init];
        self.profileDataService = [[SYProfileService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputOTPTextField.delegate = self;
    [self enableKeyboardNotifications];
    [self configureGradientBackground];
    [self.inputOTPTextField createNumberTextFieldInputAccessoryView];
    [self start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputOTPTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.second30Timer invalidate];
    [super viewWillDisappear:animated];
}

#pragma mark - ResendButton

- (void)enableResendButton
{
    self.resendButton.enabled = YES;
    self.resendButton.backgroundColorAlpha = 1.0;
    self.resendButton.titleColorTypeAlpha = 1.0;
}

- (void)disableResendButton
{
    self.resendButton.enabled = NO;
    self.resendButton.backgroundColorAlpha = 0.8;
    self.resendButton.titleColorTypeAlpha = 0.7;
}

#pragma mark - UITaxtFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Timer

- (void)start
{
    [self disableResendButton];
    currSeconds = 30;
    self.second30Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired
{
    if(currSeconds == 0) {
        [self.second30Timer invalidate];
        [self enableResendButton];
    } else if(currSeconds > 0) {
        currSeconds-=1;
        self.resendPasswordTimerLabel.text = [NSString stringWithFormat:LOC(@"resend_otp_text_key"), @(currSeconds)];
    }
}

#pragma mark - Override

- (void)updateLocalizations
{
    self.inputOTPTextField.text = @"";
    self.inputOTPTextField.placeholder = LOC(@"enter_code_here");
    self.titleLabel.text = LOC(@"verifying_otp_text_key");
    self.infoTextLabel.text = [NSString stringWithFormat:LOC(@"otp_info_text_key"), self.phoneNumber];
    self.inputOTPTextField.placeholder = LOC(@"code");
    [self.nextButton setTitle:LOC(@"next_key") forState:UIControlStateNormal];
    [self.resendButton setTitle:LOC(@"resend_title_key") forState:UIControlStateNormal];
}

#pragma mark - Customize views


// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    UIColor *color1 = [UIColor colorWithSYColor:SYGradientColorTypeBottom alpha:1.0];
    UIColor *color2 = [UIColor colorWithSYColor:SYGradientColorTypeTop alpha:1.0];
    gradient.colors = @[(id)color2.CGColor, (id)color1.CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)resendButtonPressed:(UIButton *)sender {
    // do resend staff
    [self resendSMSCode];
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    self.insertedCode = self.inputOTPTextField.text;
    if (self.insertedCode.length == 0) {
        [self showAlertViewWithTitle:LOC(@"error_text_key")
                         withMessage:LOC(@"enter_code_sent_to_number") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
        return;
    }
    if (self.isFromForgotPasswordView) {
        [self showLoader];
        weakify(self);
        [self.verifyNumberService verifyForgotPasswordPhoneNumber:self.phoneNumber withCode:self.insertedCode withComplition:^(id  _Nonnull response) {
            [self hideLoader];
            NSString *token = response[@"token"];
            [self performSegueWithIdentifier:@"showNewPasswordViewFromVerifyNumber" sender:token];
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
        }];
    } else if (self.isFromEditPhoneNumber) {
        [self verifyNumberFromEditPhoneNumber];
    } else {
        [self showLoader];
        weakify(self);
        [self.verifyNumberService verifyPhoneNumber:self.phoneNumber withCode:self.insertedCode withComplition:^(id  _Nonnull response) {
            strongify(self);
            [self hideLoader];
            // show create dual pin
            [self loginRegisteredUser];
            
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
            // handle error
        }];
    }
}

#pragma mark - Webservice Requests

- (void)loginRegisteredUser
{
    weakify(self);
    [self showLoader];
    [self.verifyNumberService loginUserWithPhoneNumber:self.phoneNumber andPassword:self.password withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        if (response[@"refresh_token"] && response[@"access_token"]) {
            [Settings sharedInstance].userRefreshToken = response[@"refresh_token"];
            [Settings sharedInstance].userAuthToken = response[@"access_token"];
            [self fetchUserProfileData];
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"something_went_wrong_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }];
}

- (void)fetchUserProfileData
{
    [self.profileDataService getUserDataWithComplition:^(UserDataModel *userData) {
        [Settings sharedInstance].onlineUser = userData;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate openApplication:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

- (IBAction)cancelEditingAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)startEditingTapAction:(UITapGestureRecognizer *)sender {
    [self.inputOTPTextField becomeFirstResponder];
}

#pragma mark - Edit Phone number flow

- (void)verifyNumberFromEditPhoneNumber
{
    [self showLoader];
    weakify(self);
    [self.verifyNumberService verifyPhoneNumber:self.phoneNumber withCode:self.insertedCode withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)logoutUser
{
    [self.verifyNumberService logoutUserWithComplition:^(id  _Nonnull response) {
        [[Settings sharedInstance] resetUserData];
        [self dismissViewControllerAnimated:NO completion:^{
            [ApplicationLaunchCoordinator showWelcomeScreenAfterLogout];
        }];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Logout error");
    }];
}

#pragma mark - Functionality

- (void)resendSMSCode
{
    [self showLoader];
    weakify(self)
    [self.verifyNumberService resendVerifyCodeToPhoneNumber:self.phoneNumber withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        [self start];
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

#pragma mark - handle Keyboard show/hide

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.contentScrolView.contentInset = contentInsets;
    self.contentScrolView.scrollIndicatorInsets = contentInsets;    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentScrolView.contentInset = contentInsets;
    self.contentScrolView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewPasswordViewFromVerifyNumber"]) {
        NewPasswordViewController *destination = segue.destinationViewController;
        destination.token = (NSString *)sender;
        destination.recoveredPhoneNumber = self.phoneNumber;
    }
}


@end
