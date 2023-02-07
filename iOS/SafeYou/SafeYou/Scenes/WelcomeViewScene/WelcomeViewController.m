//
//  WelcomeViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet SYDesignableButton *loginButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *signUpButton;

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

- (void)updateLocalizations
{
    [self.signUpButton setTitle:LOC(@"title_signup").uppercaseString forState:UIControlStateNormal];
    [self.loginButton setTitle:LOC(@"title_login").uppercaseString forState:UIControlStateNormal];
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

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    self.view.backgroundColor = [UIColor mainTintColor8];
}


#pragma mark - Actions

- (IBAction)loginButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"showSigninViewFromWelcomeView" sender:nil];
}

- (IBAction)signUpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"showRegiastrationViewFromWelcomeView" sender:nil];
}

@end
