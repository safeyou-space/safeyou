//
//  WelcomeViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "WelcomeViewController.h"
#import "EnterPhoneNumberViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet SYDesignableButton *loginButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *signUpButton;
@property (weak, nonatomic) IBOutlet SYLabelBold *welcomeLabel;

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
    
    [self configureButtonFont:self.loginButton];
    [self configureButtonFont:self.signUpButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self configureNavigationBar];
}

- (void)updateLocalizations
{
    [self configureAttributedDescriptionText];
    [self.signUpButton setTitle:LOC(@"title_signup").uppercaseString forState:UIControlStateNormal];
    [self.loginButton setTitle:LOC(@"title_login").uppercaseString forState:UIControlStateNormal];
}

/**
 keys

 virtual
 safe_space
 for
 women

 */

- (void)configureAttributedDescriptionText
{
    NSString *textVirtual = LOC(@"virtual").uppercaseString;
    NSString *textSafeSpace = LOC(@"safe_space").uppercaseString;
    NSString *textFor = LOC(@"for_text").uppercaseString;
    NSString *textWomen = LOC(@"women").uppercaseString;
    NSString *allText = LOC(@"virtual_safe_space_for_women").uppercaseString;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: allText];

    NSDictionary *attributesVirtual = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:48.0 weight:UIFontWeightThin]
    };
    NSDictionary *attributesSafeSpace = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:48.0 weight:UIFontWeightBold]
    };
    NSDictionary *attributesFor = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:48.0 weight:UIFontWeightBold]
    };
    NSDictionary *attributesWomen = @{
        NSForegroundColorAttributeName: [UIColor mainTintColor1],
        NSFontAttributeName: [UIFont systemFontOfSize:48.0 weight:UIFontWeightBold]
    };

    [attributedString addAttributes:attributesVirtual range:[allText rangeOfString:textVirtual]];
    [attributedString addAttributes:attributesSafeSpace range:[allText rangeOfString:textSafeSpace]];
    [attributedString addAttributes:attributesFor range:[allText rangeOfString:textFor]];
    [attributedString addAttributes:attributesWomen range:[allText rangeOfString:textWomen]];

    self.welcomeLabel.attributedText = attributedString;
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];

    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithSYColor:SYColorTypeMain1 alpha:1.0]];
    
}

- (void)configureButtonFont:(UIButton *)button
{
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
    button.titleLabel.adjustsFontForContentSizeCategory = YES;
}

#pragma mark - Show Terms&Conditions

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    self.view.backgroundColor = [UIColor blackColor];
}


#pragma mark - Actions

- (IBAction)loginButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"showSigninViewFromWelcomeView" sender:nil];
}

- (IBAction)signUpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"showRegiastrationViewFromWelcomeView" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EnterPhoneNumberViewController *destinationVC = (EnterPhoneNumberViewController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"showSigninViewFromWelcomeView"]) {
        destinationVC.phoneNumberMode = PhoneNumberViewModeLogIn;
    }
    if ([segue.identifier isEqualToString:@"showRegiastrationViewFromWelcomeView"]) {
        destinationVC.phoneNumberMode = PhoneNumberViewModeRegistration;
    }
}

@end
