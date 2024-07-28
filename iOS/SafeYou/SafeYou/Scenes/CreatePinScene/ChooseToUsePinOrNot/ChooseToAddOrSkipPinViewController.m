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

@property (weak, nonatomic) IBOutlet SYLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *secondaryTitleLabel;
@property (weak, nonatomic) IBOutlet SYRegularButtonButton *addDualPinButton;
@property (weak, nonatomic) IBOutlet SYRegularButtonButton *continueWithoutPinButton;

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
    self.view.backgroundColor = [UIColor mainTintColor2];
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
