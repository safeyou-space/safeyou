//
//  WelcomeViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIColor+SyColors.h"
#import "WebContentViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet SYDesignableButton *loginButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *signUpButton;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *termsAndConditionsLabel;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)signUpButtonAction:(id)sender;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self == self.navigationController.viewControllers.firstObject) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [self configureGradientBackground];
    self.title = @" ";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.termsAndConditionsLabel.userInteractionEnabled = YES;
    UIButton *termsAndConditionsButton = [[UIButton alloc] initWithFrame:self.termsAndConditionsLabel.bounds];
    [termsAndConditionsButton setTitle:@"" forState:UIControlStateNormal];
    termsAndConditionsButton.backgroundColor = [UIColor clearColor];
    [termsAndConditionsButton addTarget:self action:@selector(showTermsAndConditionsView) forControlEvents:UIControlEventTouchUpInside];
    [self.termsAndConditionsLabel addSubview:termsAndConditionsButton];
}

- (void)updateLocalizations
{
    self.termsAndConditionsLabel.text = LOC(@"agree_terms_and_conditions_title");
    [self.loginButton setTitle:LOC(@"title_login") forState:UIControlStateNormal];
    [self.signUpButton setTitle:LOC(@"title_signup") forState:UIControlStateNormal];
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];

    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithSYColor:SYColorTypeMain1 alpha:1.0]];
    
}

#pragma mark - Show Terms&Conditions

- (void)showTermsAndConditionsView
{
    [self performSegueWithIdentifier:@"showTermsAndConditionsView" sender:nil];
}

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    UIColor *backgroundColor = [UIColor colorWithSYColor:SYColorTypeMain3 alpha:1.0];
    gradient.backgroundColor = backgroundColor.CGColor;
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}


#pragma mark - Actions

- (IBAction)loginButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"showSigninViewFromWelcomeView" sender:nil];
}

- (IBAction)signUpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"showRegiastrationViewFromWelcomeView" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTermsAndConditionsView"]) {
        UINavigationController *destinationNVC = (UINavigationController *)segue.destinationViewController;
        WebContentViewController *destinationVC = destinationNVC.viewControllers.firstObject;
        destinationVC.contentType = SYRemotContentTypeTermsAndConditions;
    }
}
@end
