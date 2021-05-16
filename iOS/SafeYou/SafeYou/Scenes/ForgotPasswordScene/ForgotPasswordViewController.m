//
//  ForgotPasswordViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "VerifyPhoneNumberViewController.h"
#import "SYAuthenticationService.h"

@interface ForgotPasswordViewController ()

@property (nonatomic) SYAuthenticationService *forgotPasswordService;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet HyRobotoButton *requestPasswordButton;

@end

@implementation ForgotPasswordViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.forgotPasswordService = [[SYAuthenticationService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.phoneNumberField.text = [[Settings sharedInstance] countryPhoneCode];
    [self registerForKeyboardNotifications];
    [self configureGradientBackground];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)updateLocalizations
{
    self.titleLabel.text = LOC(@"title_forgot_password");
    [self.requestPasswordButton setTitle:LOC(@"title_request_new_password") forState:UIControlStateNormal];
    self.phoneNumberField.placeholder = LOC(@"mobile_number_text+key");
}
#pragma mark - Customization

- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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

- (IBAction)requestPasswordButtonPressed:(UIButton *)sender {
    
    if (self.phoneNumberField.text.length > 0) {
        weakify(self);
        [self.forgotPasswordService sendForgotPasswordWithPhoneNumber:self.phoneNumberField.text withComplition:^(id  _Nonnull response) {
            strongify(self);
            [self performSegueWithIdentifier:@"showVerifyNumberViewFromForgotPassword" sender:self.phoneNumberField.text];
        } failure:^(NSError * _Nonnull error) {
            [self handleNetworkError:error];
            
        }];
    } else {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"please_fill_phone_number_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
}

- (IBAction)cancelEditingPressed:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Handle Network Errors

- (void)handleNetworkError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSDictionary *errorsDict = errorInfo[@"message"];
    NSString *errorMessage;
    if (errorsDict[@"phone"]) {
        NSArray *errorArray = errorsDict[@"phone"];
        errorMessage = errorArray.firstObject;
    } else {
        errorMessage = errorInfo[@"message"];
    }
    
    [self showAlertViewWithTitle:LOC(@"registration_error_key") withMessage:errorMessage cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
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
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.requestPasswordButton.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.requestPasswordButton.frame.origin.y-kbSize.height);
//        self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, kbSize, 0)
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, scrollPoint.y, 0);
        [self.scrollView setContentInset:contentInsets];
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVerifyNumberViewFromForgotPassword"]) {
        VerifyPhoneNumberViewController *desitnationVC = (VerifyPhoneNumberViewController *)segue.destinationViewController;
        desitnationVC.isFromForgotPasswordView = YES;
        desitnationVC.phoneNumber = (NSString *)sender;
    }
}

@end
