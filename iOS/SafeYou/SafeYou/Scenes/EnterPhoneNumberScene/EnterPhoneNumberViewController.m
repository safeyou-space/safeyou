//
//  EnterPhoneNumberViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/24/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#define ERRORVIEW_HEIGHT 65.0
#define FORGOTPASSWORD_BUTTON_HEIGHT 30.0

#import "EnterPhoneNumberViewController.h"
#import "Settings.h"
#import "PhoneNumberService.h"
#import "SigninPasswordViewController.h"
#import "CreatePasswordViewController.h"
#import "VerifyPhoneNumberViewController.h"
#import "SYAuthenticationService.h"
#import "ImageDataModel.h"
#import "RegionalOptionDataModel.h"
#import <SDWebImage.h>

@interface EnterPhoneNumberViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SYLabelBold *mainTitleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *secondaryTitleLabel;
@property (weak, nonatomic) IBOutlet SYButtonBold *processRelatedButton;
@property (weak, nonatomic) IBOutlet SYDesignableView *errorView;
@property (weak, nonatomic) IBOutlet SYLabelRegular *errorTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorViewHeightConstraint;

@property (weak, nonatomic) IBOutlet SYLabelBold *fieldTitleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *flagImageView;
@property (weak, nonatomic) IBOutlet SYLabelRegular *countryCodeLabel;
@property (weak, nonatomic) IBOutlet SYTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet SYCorneredButton *nextButton;
@property (weak, nonatomic) IBOutlet SYButtonBold *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backBarButton;

// forgotpassword related
@property (weak, nonatomic) IBOutlet SYLabelBold *havingTroubleLabel;
@property (weak, nonatomic) IBOutlet SYButtonBold *supportEmailButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgotPasswordButtonheigthConstraint;


@property (nonatomic) PhoneNumberService *phoneNumberService;
@property (nonatomic) SYAuthenticationService *forgotPasswordService;
@property (nonatomic) NSString *insertedPhoneNumber;

@end

@implementation EnterPhoneNumberViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.phoneNumberService = [[PhoneNumberService alloc] init];
        self.forgotPasswordService = [[SYAuthenticationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUIElements];
}


#pragma mark - UI

- (void)configureUIElements
{
    self.phoneNumberTextField.delegate = self;
    [self.navigationController setNavigationBarHidden:NO];
    self.countryCodeLabel.text = [Settings sharedInstance].countryPhoneCode;
    NSString *iconImageStr = [NSString stringWithFormat:@"%@/%@", BASE_RESOURCE_URL, [Settings sharedInstance].selectedCountry.imageData.url];
    NSURL *iconImageURL = [NSURL URLWithString:iconImageStr];
    [self.flagImageView sd_setImageWithURL:iconImageURL];
    [self showErrorView:NO];
    self.nextButton.enabled = YES;
    self.phoneNumberTextField.fieldType = LTFT_PhoneNumberType;
    self.supportEmailButton.enabled = NO;
    self.supportEmailButton.hidden = YES;
    self.havingTroubleLabel.hidden = YES;
    if ([[Settings sharedInstance] isLanguageRTL]) {
        self.phoneNumberTextField.textAlignment = NSTextAlignmentRight;
    } else {
        self.phoneNumberTextField.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)configureNavigationBar
{

}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.processRelatedButton.hidden = NO;
    self.forgotPasswordButton.hidden = NO;
    [self.forgotPasswordButton setTitle:LOC(@"title_forgot_password") forState:UIControlStateNormal];
    self.forgotPasswordButtonheigthConstraint.constant = FORGOTPASSWORD_BUTTON_HEIGHT;
     self.fieldTitleLabel.text = LOC(@"enter_phone_number_text");
    self.backBarButton.title = LOC(@"back").capitalizedString;
    self.backBarButton.tintColorType = 22;
    [self.nextButton setTitle:LOC(@"next_key") forState:UIControlStateNormal];
    self.phoneNumberTextField.placeholder = LOC(@"mobile_phone_number");
    if (self.phoneNumberMode == PhoneNumberViewModeLogIn) {
        self.mainTitleLabel.text = LOC(@"login_to_your_account_text");
        self.secondaryTitleLabel.text = LOC(@"new_user_text");
        [self.processRelatedButton setTitle:LOC(@"create_account_text") forState:UIControlStateNormal];
        self.errorTextLabel.text = [self errorText];
    }
    if (self.phoneNumberMode == PhoneNumberViewModeRegistration) {
        self.mainTitleLabel.text = LOC(@"create_your_account_text");
        NSString *secondaryTitleText = [NSString stringWithFormat:@"%@\n%@", LOC(@"provide_valid_phone_number_text"), LOC(@"already_have_account_text")];
        self.secondaryTitleLabel.text = secondaryTitleText;
        [self.processRelatedButton setTitle:LOC(@"log_in_text") forState:UIControlStateNormal];
        self.errorTextLabel.text = [self errorText];
        self.forgotPasswordButton.hidden = YES;
        self.forgotPasswordButtonheigthConstraint.constant = 0;

    }
    if (self.phoneNumberMode == PhoneNumberViewModeForgotPassword) {
        [self.processRelatedButton setTitle:@"" forState:UIControlStateNormal];
        self.processRelatedButton.hidden = YES;
        self.forgotPasswordButton.hidden = YES;
        self.forgotPasswordButtonheigthConstraint.constant = 0;
        NSString *sendCodeTitle = LOC(@"send_code_text").capitalizedString;
        [self.nextButton setTitle:sendCodeTitle forState:UIControlStateNormal];
        self.mainTitleLabel.text = LOC(@"title_forgot_password");
        NSString *secondaryText = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                                   LOC(@"forgot_password_step1"), LOC(@"forgot_password_step2"), LOC(@"forgot_password_step3"), LOC(@"forgot_password_step4")];
        NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:secondaryText];
        [mAttrString addAttributes:@{NSFontAttributeName: [UIFont regularFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor blackColor]} range:NSMakeRange(0, secondaryText.length)];
        [mAttrString addAttributes:@{NSFontAttributeName: [UIFont boldFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor purpleColor2]} range:[secondaryText rangeOfString:sendCodeTitle]];
        self.secondaryTitleLabel.attributedText = [mAttrString copy];
        self.havingTroubleLabel.text = LOC(@"having_trouble_text");
        [self.supportEmailButton setTitle:LOC(@"support_mail") forState:UIControlStateNormal];

    }
}

- (NSString *)errorText
{
    NSString *errorText = @"";
    if (self.phoneNumberMode == PhoneNumberViewModeLogIn) {
        errorText = LOC(@"not_registered_text");
    } else if (self.phoneNumberMode == PhoneNumberViewModeRegistration) {
        errorText = LOC(@"phone_number_already_used_text");
    }

    return errorText;
}

#pragma mark - Setter

- (void)setPhoneNumberMode:(PhoneNumberViewMode)phoneNumberMode
{
    _phoneNumberMode = phoneNumberMode;
    [self showErrorView:NO];
    [self updateLocalizations];
}


#pragma mark - Actions

- (IBAction)backBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)processRelatedButtonAction:(UIButton *)sender {
    if (self.phoneNumberMode == PhoneNumberViewModeLogIn) {
        self.phoneNumberMode = PhoneNumberViewModeRegistration;
    } else {
        self.phoneNumberMode = PhoneNumberViewModeLogIn;
    }
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    if (self.phoneNumberTextField.text.length > 0) {
        self.insertedPhoneNumber = [self phoneNumber];
        if (self.phoneNumberMode == PhoneNumberViewModeForgotPassword) {
            [self performForgotPasswordRequest];
        } else {
            [self performRequest];
        }
    } else {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"fill_required_fields_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
}

- (IBAction)forgotPasswordButtonAction:(UIButton *)sender {
    [self showForgotPasswordFlow:self];
}

- (IBAction)supportEmailButtonAction:(UIButton *)sender {
    // link to mail to
}

- (IBAction)textFieldEditingChanged:(SYTextField *)sender {
    self.errorTextLabel.text = @"";
    self.errorView.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = updatedText.length;
    return newLength <= 10;
}

#pragma mark - Requests

- (void)performRequest
{
    [self showLoader];
    weakify(self);
    [self.phoneNumberService checkPhoneNumber:[self phoneNumber] success:^(id  _Nonnull response) {
        strongify(self)
        [self hideLoader];
        NSLog(@"%@", response);
        if (self.phoneNumberMode == PhoneNumberViewModeRegistration) {
            // continue to registration
            [self performSegueWithIdentifier:@"showCreatePasswordView" sender:nil];
        } else {
            self.errorTextLabel.text = [self errorText];
            [self showErrorView:YES];

        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        if (self.phoneNumberMode == PhoneNumberViewModeLogIn) {
            if (error.code == 409) {
                // show passwordView
                [self performSegueWithIdentifier:@"showPasswordViewController" sender:nil];
            } else if (error.code == 412) {
                // show verification view
                [self performSegueWithIdentifier:@"showVerifyPhoneNumberView" sender:nil];
            } else {
                NSString *errorMessage = error.userInfo[@"message"][@"phone"][0];
                self.errorTextLabel.text = errorMessage;
                [self showErrorView:YES];
            }
        } else {
            if (error.code == 409) {
                // show passwordView
                self.errorTextLabel.text = [self errorText];
                [self showErrorView:YES];
            }
        }
    }];
}

- (void)performForgotPasswordRequest
{
    weakify(self);
    [self showLoader];
    [self.forgotPasswordService sendForgotPasswordWithPhoneNumber:[self phoneNumber] withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        [self performSegueWithIdentifier:@"showVerifyPhoneNumberView" sender:nil];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        [self handleNetworkError:error];

    }];
}

#pragma mark - Handle Network Errors

- (void)handleNetworkError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSDictionary *errorsDict = errorInfo[@"message"];
    NSString *errorMessage;
    if ([errorsDict isKindOfClass:[NSDictionary class]] && errorsDict[@"phone"]) {
        NSArray *errorArray = errorsDict[@"phone"];
        errorMessage = errorArray.firstObject;
    } else {
        errorMessage = errorInfo[@"message"];
    }

    [self showAlertViewWithTitle:LOC(@"registration_error_key") withMessage:errorMessage cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
}

#pragma mark - Private

- (NSString *)phoneNumber
{
    return [NSString stringWithFormat:@"%@%@",[Settings sharedInstance].countryPhoneCode, self.phoneNumberTextField.text];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPasswordViewController"]) {
        SignInPasswordViewController *destinationVC = (SignInPasswordViewController *)segue.destinationViewController;
        destinationVC.phoneNumber = self.insertedPhoneNumber;
    }

    if ([segue.identifier isEqualToString:@"showCreatePasswordView"]) {
        CreatePasswordViewController *destinationVC = (CreatePasswordViewController *)segue.destinationViewController;
        destinationVC.phoneNumber = self.insertedPhoneNumber;
    }

    if ([segue.identifier isEqualToString:@"showVerifyPhoneNumberView"]) {
        VerifyPhoneNumberViewController *destinationVC = (VerifyPhoneNumberViewController *)segue.destinationViewController;
        if (self.phoneNumberMode == PhoneNumberViewModeLogIn) {
            destinationVC.isSignInFlow = YES;
        } else if (self.phoneNumberMode == PhoneNumberViewModeForgotPassword) {
            destinationVC.isFromForgotPasswordView = YES;
        }

        destinationVC.phoneNumber = self.insertedPhoneNumber;
    }
}


@end
