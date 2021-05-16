//
//  ChooseToAddOrSkipPinViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/18/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseToAddOrSkipPinViewController.h"
#import "AppDelegate.h"

@interface ChooseToAddOrSkipPinViewController ()

@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *secondaryTitleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoButton *addDualPinButton;
@property (weak, nonatomic) IBOutlet HyRobotoButton *continueWithoutPinButton;

- (IBAction)addDualPinButtonAction:(UIButton *)sender;
- (IBAction)continueWithoutPinButtonAction:(UIButton *)sender;



@end

@implementation ChooseToAddOrSkipPinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureGradientBackground];
}

#pragma mark - Translations
- (void)updateLocalizations
{
    self.titleLabel.text = LOC(@"add_dual_pin_title_key");
    UIFont *font = self.secondaryTitleLabel.font;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 0.35 * font.lineHeight;
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle,
    };
    self.secondaryTitleLabel.attributedText = [[NSAttributedString alloc]initWithString:LOC(@"add_dual_pin_for_security") attributes:attributes];
    self.secondaryTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.addDualPinButton setTitle:LOC(@"add_dual_pin_title_key").uppercaseString forState:UIControlStateNormal];
    [self.continueWithoutPinButton setTitle:LOC(@"continue_without_pin_title_key").uppercaseString forState:UIControlStateNormal];
}

#pragma mark - Customzie Views
// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    UIColor *color1 = [UIColor colorWithSYColor:SYGradientColorTypeBottom alpha:1.0];
    UIColor *color2 = [UIColor colorWithSYColor:SYGradientColorTypeTop alpha:1.0];
    gradient.colors = @[(id)color2.CGColor, (id)color1.CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - Actions
- (IBAction)addDualPinButtonAction:(UIButton *)sender {
    [[Settings sharedInstance] activateUsingDualPin:YES];
    [self performSegueWithIdentifier:@"showCreateDualPinView" sender:nil];
}

- (IBAction)continueWithoutPinButtonAction:(UIButton *)sender {
    [[Settings sharedInstance] activateUsingDualPin:NO];
    // open application
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate openApplication:YES];
}

@end
