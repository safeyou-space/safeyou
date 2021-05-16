//
//  NewPasswordViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "SYAuthenticationService.h"

@interface NewPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet HyRobotoRegualrTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;

@property (weak, nonatomic) HyRobotoRegualrTextField *activeField;

@property (nonatomic) SYAuthenticationService *passwordService;

@end

@implementation NewPasswordViewController

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
    
    [self configureNavigationBar];
    [self configureGradientBackground];
    [self registerForKeyboardNotifications];
    [self configureRightViewButtonForPasswordField:self.passwordTextField];
    [self configureRightViewButtonForPasswordField:self.confirmPasswordTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.titleLabel.text = LOC(@"new_password_title_key");
    self.passwordTextField.placeholder = LOC(@"new_password_title_key");
    self.confirmPasswordTextField.placeholder = LOC(@"confirm_password_text_key");
    [self.updatePasswordButton setTitle:LOC(@"update_password_title") forState:UIControlStateNormal];
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)configureRightViewButtonForPasswordField:(UITextField *)textField
{
    UIButton *rightViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textField.frame.size.height, textField.frame.size.height)];
    [rightViewButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    [rightViewButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateSelected];
    if (textField == self.passwordTextField) {
        [rightViewButton addTarget:self action:@selector(rightViewButtonPressedField1:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (textField == self.confirmPasswordTextField) {
        [rightViewButton addTarget:self action:@selector(rightViewButtonPressedField2:) forControlEvents:UIControlEventTouchUpInside];
    }
    textField.rightView = rightViewButton;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)rightViewButtonPressedField1:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passwordTextField.secureTextEntry = NO;
    } else {
        self.passwordTextField.secureTextEntry = YES;
    }
}

- (void)rightViewButtonPressedField2:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.confirmPasswordTextField.secureTextEntry = NO;
    } else {
        self.confirmPasswordTextField.secureTextEntry = YES;
    }
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

- (IBAction)updatePasswordButtonPressed:(UIButton *)sender
{
    // perform update password flow do request and dismiss flow navigation controller
    
    
    if (self.passwordTextField.text.length >= 8) {
        NSString *password = self.passwordTextField.text;
        if ([self.confirmPasswordTextField.text isEqualToString:password]) {
            NSString *confirmPassword = self.confirmPasswordTextField.text;
            weakify(self);
            [self showLoader];
            [self.passwordService createNewpassowrd:password confirm:confirmPassword token:self.token andPhoneNumber:self.recoveredPhoneNumber withComplition:^(id  _Nonnull response) {
                strongify(self);
                [self hideLoader];
                [self navigateToSourceView];
            } failure:^(NSError * _Nonnull error) {
                strongify(self);
                [self hideLoader];
            }];
        } else {
            [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"passwords_not_match_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
        }
    } else {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"please_enter_valid_password_message_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
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
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
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

#pragma mark - UItextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = (HyRobotoRegualrTextField *)textField;
}

@end
