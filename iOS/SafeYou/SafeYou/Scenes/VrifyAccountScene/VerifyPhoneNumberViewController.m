//
//  VerifyPhoneNumberViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "SYAuthenticationService.h"
#import "CreatePasswordViewController.h"
#import "MainTabbarController.h"
#import "ApplicationLaunchCoordinator.h"
#import "SYProfileService.h"
#import "UITextField+UITextField_NumberPad.h"
#import "AppDelegate.h"
#import "SafeYou-Swift.h"
#import "SignInPasswordViewController.h"

@interface VerifyPhoneNumberViewController () <UITextFieldDelegate, DigitInputViewDelegate>

{
    int currSeconds;
}

@property (weak, nonatomic) IBOutlet SYLabelBold *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *infoTextLabel;
@property (weak, nonatomic) IBOutlet UIView *digitInputContainerView;
@property (weak, nonatomic) IBOutlet SYLabelRegular *resendPasswordTimerLabel;
@property (weak, nonatomic) IBOutlet SYRegularButtonButton *resendButton;
@property (weak, nonatomic) IBOutlet SYCorneredButton *nextButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *startEditingTap;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backButtonItem;

- (IBAction)resendButtonPressed:(UIButton *)sender;
- (IBAction)nextButtonPressed:(UIButton *)sender;
- (IBAction)cancelEditingAction:(UITapGestureRecognizer *)sender;
- (IBAction)startEditingTapAction:(UITapGestureRecognizer *)sender;

@property (nonatomic) NSTimer *second30Timer;

@property (nonatomic) NSString *insertedCode;

@property (nonatomic) SYAuthenticationService *verifyNumberService;
@property (nonatomic) SYProfileService *profileDataService;

@property (nonatomic) DigitInputView *digitInputView;


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
    [self configureDigitInputView];
    [self enableKeyboardNotifications];
    [self disableNextButton];
    [self start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNotificationsBarButtonitem:NO];
    [[self mainTabbarController] hideTabbar:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.digitInputView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.second30Timer invalidate];
    [super viewWillDisappear:animated];
}

#pragma mark - ResendButton

- (void)enableResendButton
{
    self.resendButton.hidden = NO;
    self.resendButton.enabled = YES;
    self.resendButton.backgroundColorAlpha = 1.0;
    self.resendButton.titleColorTypeAlpha = 1.0;
}

- (void)disableResendButton
{
    self.resendButton.hidden = YES;
    self.resendButton.enabled = NO;
    self.resendButton.backgroundColorAlpha = 0.8;
    self.resendButton.titleColorTypeAlpha = 0.7;
}

#pragma mark - ResendButton

- (void)enableNextButton
{
    self.nextButton.enabled = YES;
}

- (void)disableNextButton
{
    self.nextButton.enabled = NO;
}


#pragma mark - DigitViewDelegate

- (void)digitsDidChangeWithDigitInputView:(DigitInputView *)digitInputView
{

}

- (void)digitsDidFinishWithDigitInputView:(DigitInputView *)digitInputView
{
    self.nextButton.enabled = YES;
    self.insertedCode = digitInputView.text;
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
    self.titleLabel.text = LOC(@"verifying_otp_text_key");
    self.infoTextLabel.text = [NSString stringWithFormat:LOC(@"otp_info_text_key"), self.phoneNumber];
    [self.nextButton setTitle:LOC(@"next_key") forState:UIControlStateNormal];
    [self.resendButton setTitle:LOC(@"resend_title_key") forState:UIControlStateNormal];
    self.backButtonItem.title = LOC(@"back");
}

#pragma mark - Customize views

- (void)configureDigitInputView
{
    self.digitInputView = [[DigitInputView alloc] initWithFrame:self.digitInputContainerView.bounds];
    
    self.digitInputView.delegate = self;
    self.digitInputView.numberOfDigits = 6;
    self.digitInputView.borderColor = [UIColor purpleColor4];
    self.digitInputView.textColor = [UIColor purpleColor2];
    self.digitInputView.acceptableCharacters = @"0123456789";
    self.digitInputView.keyboardType = UIKeyboardTypeDecimalPad;
    self.digitInputView.font = [UIFont semiBoldFontOfSize:20.0];

    // if you wanna use layout constraints
    self.digitInputView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.digitInputContainerView addSubview:self.digitInputView];

    [NSLayoutConstraint activateConstraints:@[
        [self.digitInputView.topAnchor constraintEqualToAnchor:self.digitInputContainerView.topAnchor constant:0.0],
        [self.digitInputView.leadingAnchor constraintEqualToAnchor:self.digitInputContainerView.leadingAnchor constant:0.0],
        [self.digitInputView.trailingAnchor constraintEqualToAnchor:self.digitInputContainerView.trailingAnchor constant:0.0],
        [self.digitInputView.bottomAnchor constraintEqualToAnchor:self.digitInputContainerView.bottomAnchor constant:0.0],
    ]];
}


#pragma mark - Actions

- (IBAction)backButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)resendButtonPressed:(UIButton *)sender {
    // do resend staff
    [self resendSMSCode];
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    if (self.isFromForgotPasswordView) {
        [self showLoader];
        weakify(self);
        [self.verifyNumberService verifyForgotPasswordPhoneNumber:self.phoneNumber withCode:self.insertedCode withComplition:^(id  _Nonnull response) {
            [self hideLoader];
            NSString *token = response[@"token"];
            [self performSegueWithIdentifier:@"showCreatePasswordView" sender:token];
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
            [self handleError:error.userInfo];
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
            if (self.isSignInFlow) {
                [self performSegueWithIdentifier:@"showEnterPasswordView" sender:nil];
            } else {
                [self loginRegisteredUser];
            }
            
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
            [self handleError:error.userInfo];
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
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate openApplication:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

- (IBAction)cancelEditingAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
}

#pragma mark - Error Handling

- (void)handleError:(NSDictionary *)errorInfo
{
    NSString *message = @"";
    if (errorInfo[@"message"]) {
        if ([errorInfo[@"message"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *errorMessageDict = errorInfo[@"message"];
            if ([errorMessageDict[@"message"] isKindOfClass:[NSArray class]]) {
                message = errorMessageDict[@"message"][0];
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
    if ([segue.identifier isEqualToString:@"showCreatePasswordView"]) {
        NSString *token = (NSString *)sender;
        CreatePasswordViewController *destinationVC = segue.destinationViewController;
        destinationVC.isRecoverFlow = YES;
        destinationVC.recoveryToken = token;
        destinationVC.phoneNumber = self.phoneNumber;
    }

    if ([segue.identifier isEqualToString:@"showEnterPasswordView"]) {
        SignInPasswordViewController *destinationVC = (SignInPasswordViewController *)segue.destinationViewController;
        destinationVC.phoneNumber = self.phoneNumber;

    }
}

@end
