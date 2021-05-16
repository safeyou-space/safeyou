//
//  IntroductionViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/24/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "IntroductionViewController.h"
#import "UIColor+SyColors.h"
#import "RoundButtonView.h"
#import "IntorductionDialogViewController.h"
#import "SYDesignableView.h"
#import "Utilities.h"
#import "UIButton+ArrangeImage.h"

@interface IntroductionViewController ()

@property (weak, nonatomic) IBOutlet SYDesignableView *contentView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *dualPinButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *supportButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *forumsButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *ngosButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property (weak, nonatomic) IBOutlet SYDesignableButton *nextButton;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *descriptionLabel;
@property (strong, nonatomic) IBOutletCollection(SYDesignableButton) NSArray *introButtonsCollection;

- (IBAction)nextButtonAction:(SYDesignableButton *)sender;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nextButton arrangeImageToTheRight];
    if (self.isFromMenu) {
        self.nextButton.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
    [self configureGradientBackground];
    [self drawShadowsNearButtons];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.helpButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


#pragma mark - Translations
- (void)updateLocalizations
{
    self.nextBarButtonItem.title = LOC(@"next_key");
    [self.nextButton setTitle:LOC(@"next_key") forState:UIControlStateNormal];
    self.title = LOC(@"title_tutorial");
    [self.ngosButton setTitle:LOC(@"ngos_title_key").uppercaseString forState:UIControlStateNormal];
    [self.dualPinButton setTitle:LOC(@"security").uppercaseString forState:UIControlStateNormal];
    [self.forumsButton setTitle:LOC(@"forums_title_key").uppercaseString forState:UIControlStateNormal];
    [self.supportButton setTitle:LOC(@"support_title_key").uppercaseString forState:UIControlStateNormal];
    self.descriptionLabel.text = LOC(@"intro_view_description_text_key");
    
    NSString *imageName = [NSString stringWithFormat:@"help_icon_intro_%@", [Settings sharedInstance].selectedLanguageCode];
    UIImage *localizedImage = [UIImage imageNamed:imageName];
    [self.helpButton setImage:localizedImage forState:UIControlStateNormal];
}


#pragma mark - Customization

- (void)drawShadowsNearButtons
{
    for (SYDesignableButton *introButton in self.introButtonsCollection) {
        introButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
        introButton.layer.shadowOffset = CGSizeMake(0, 2.0f);
        introButton.layer.shadowOpacity = 1.0f;
        introButton.layer.shadowRadius = 1.0f;
        introButton.layer.masksToBounds = NO;
        
        // configure label
        introButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont fontWithName:@"HayRoboto-regular" size:18]}];

}

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    UIColor *color1 = [UIColor colorWithSYColor:SYColorTypeMain1 alpha:1.0];
    gradient.backgroundColor = color1.CGColor;
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}


#pragma mark - Helper

- (UIImage *)imageFromColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 64));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, 1, 64));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - RoundButtonAction

- (IBAction)nextButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showWelcomeView" sender:nil];
}

- (IBAction)helpButtonPressed:(UIButton *)sender {
    if (sender == self.helpButton) {
        NSString *messageTitle = LOC(@"help_intro_title_key");
        NSString *messageText = LOC(@"help_section_descritpion_text_key");
        [self showIntroDialogWithTitle:messageTitle message:messageText];
    }
}

- (IBAction)nextButtonAction:(SYDesignableButton *)sender {
    [self nextButtonPressed:sender];
}

- (IBAction)introButtonPressed:(SYDesignableButton *)sender
{
    NSString *messageTitle;
    NSString *messageText;
    if (sender == self.dualPinButton) {
        messageTitle = LOC(@"security");
        messageText = LOC(@"security_introduction_text_key");
    }
    
    if (sender == self.ngosButton) {
        messageTitle = LOC(@"ngos_title_key");
        messageText = LOC(@"ngos_descritpion_text_key");
    }
    
    if (sender == self.forumsButton) {
        messageTitle = LOC(@"forums_title_key");
        messageText = LOC(@"forums_descritpion_text_key");
    }
    
    if (sender == self.supportButton) {
        messageTitle = LOC(@"support_title_key");
        messageText = LOC(@"In this section you can choose upto 3 personal contacts from you phone's contact list, upto 3 support contacts from our Network, as well as can enable the function of applying to the police.");
    }
    [self showIntroDialogWithTitle:messageTitle message:messageText];
}

- (void)showIntroDialogWithTitle:(NSString *)title message:(NSString *)message
{
    IntorductionDialogViewController *dialogViewController = [[IntorductionDialogViewController alloc] initWithTitle:title message:message];
    [self addChildViewController:dialogViewController];
}

- (void)addChildViewController:(UIViewController *)childController
{
    childController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:childController.view];
    [super addChildViewController:childController];
    [childController didMoveToParentViewController:self];
}

@end
