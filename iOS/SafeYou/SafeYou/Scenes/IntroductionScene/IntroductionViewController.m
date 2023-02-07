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

#define BUTTON_IMAGE_INSET 13

@interface IntroductionViewController ()

@property (weak, nonatomic) IBOutlet SYDesignableView *contentView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *securityButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *emergencyContactsButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *forumsButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *ngosButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *messsagesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property (weak, nonatomic) IBOutlet SYDesignableButton *nextButton;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *descriptionLabel;

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
    [self setupButtonsTwoLinesTitle:@[self.emergencyContactsButton, self.messsagesButton]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
    [self configureGradientBackground];
    [self configureButtonsImageInsets];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.helpButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


#pragma mark - Translations
- (void)updateLocalizations
{
    self.nextBarButtonItem.title = LOC(@"next_key");
    [self.nextButton setTitle:LOC(@"next_key") forState:UIControlStateNormal];
    self.title = LOC(@"title_tutorial");
    [self.ngosButton setTitle:LOC(@"network_title").uppercaseString forState:UIControlStateNormal];
    [self.securityButton setTitle:LOC(@"security").uppercaseString forState:UIControlStateNormal];
    [self.forumsButton setTitle:LOC(@"forums_title_key").uppercaseString forState:UIControlStateNormal];
    [self.emergencyContactsButton setTitle:LOC(@"emergency_contacts_title_key").uppercaseString forState:UIControlStateNormal];
    [self.messsagesButton setTitle:LOC(@"messages_title_key").uppercaseString forState:UIControlStateNormal];
    self.descriptionLabel.text = LOC(@"intro_view_description_text_key");
    
    NSString *imageName = [NSString stringWithFormat:@"help_icon_intro_%@", [Settings sharedInstance].selectedLanguageCode];
    UIImage *localizedImage = [UIImage imageNamed:imageName];
    [self.helpButton setImage:localizedImage forState:UIControlStateNormal];
    [self.helpButton setTitle:LOC(@"help_title_key").uppercaseString forState:UIControlStateNormal];
}


#pragma mark - Customization

- (void)configureButtonsImageInsets
{
    UIEdgeInsets buttonImageInsets = UIEdgeInsetsMake(0, 0, 0, BUTTON_IMAGE_INSET);
    if ([[Settings sharedInstance] isLanguageRTL]) {
        buttonImageInsets = UIEdgeInsetsMake(0, BUTTON_IMAGE_INSET, 0, 0);
        self.nextButton.imageEdgeInsets = buttonImageInsets;
    }
    
    self.ngosButton.imageEdgeInsets = buttonImageInsets;
    self.securityButton.imageEdgeInsets = buttonImageInsets;
    self.emergencyContactsButton.imageEdgeInsets = buttonImageInsets;
    self.messsagesButton.imageEdgeInsets = buttonImageInsets;
    self.forumsButton.imageEdgeInsets = buttonImageInsets;
    self.helpButton.imageEdgeInsets = buttonImageInsets;
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
    self.view.backgroundColor = [UIColor mainTintColor2];
}


#pragma mark - Helper

- (void)setupButtonsTwoLinesTitle:(NSArray *)buttons
{
    for (UIButton *button in buttons) {
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        button.titleLabel.numberOfLines = 2;
    }
}

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
        NSString *messageTitle = LOC(@"help_title_key");
        NSString *messageText = LOC(@"help_section_description_text_key");
        [self showIntroDialogWithTitle:messageTitle message:messageText];
    }
}

- (IBAction)nextButtonAction:(SYDesignableButton *)sender {
    [self nextButtonPressed:sender];
}

- (IBAction)securityButtonAction:(id)sender
{
    [self showIntroDialogWithTitle:LOC(@"security") message:LOC(@"security_introduction_text_key")];
}

- (IBAction)emergencyContactsButtonAction:(id)sender
{
    [self showIntroDialogWithTitle:LOC(@"emergency_contacts_title_key") message:LOC(@"intro_support_text_key")];
}

- (IBAction)forumsButtonAction:(id)sender
{
    [self showIntroDialogWithTitle:LOC(@"forums_title_key") message:LOC(@"forums_description_text_key")];
}

- (IBAction)ngosButtonAction:(id)sender
{
    [self showIntroDialogWithTitle:LOC(@"network_title") message:LOC(@"ngos_description_text_key")];
}

- (IBAction)messagesButtonAction:(id)sender
{
    [self showIntroDialogWithTitle:LOC(@"messages_title_key") message:LOC(@"intro_private_messages_text_key")];
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
