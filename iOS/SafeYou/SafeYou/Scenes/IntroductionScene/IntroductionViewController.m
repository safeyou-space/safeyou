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
#import "SYDesignableView.h"
#import "Utilities.h"
#import "UIButton+ArrangeImage.h"
#import "MainTabbarController.h"
#import "IntroductionItemView.h"
#import "IntroContentViewController.h"
#import "IntroductionContentManager.h"

#define BUTTON_IMAGE_INSET 13

@interface IntroductionViewController () <IntroductionItemViewDelegate>

@property (weak, nonatomic) IBOutlet SYDesignableView *contentView;
@property (weak, nonatomic) IBOutlet IntroductionItemView *dualPinItem;
@property (weak, nonatomic) IBOutlet IntroductionItemView *emergencyContactsItem;
@property (weak, nonatomic) IBOutlet IntroductionItemView *privateMessagesItem;
@property (weak, nonatomic) IBOutlet IntroductionItemView *forumsItem;
@property (weak, nonatomic) IBOutlet IntroductionItemView *emergencyHelpItem;
@property (weak, nonatomic) IBOutlet IntroductionItemView *ngosItem;
@property (weak, nonatomic) IBOutlet SYCorneredButton *skipButton;
@property (weak, nonatomic) IBOutlet SYLabelBold *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *descriptionLabel;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backBarButtonItem;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isFromMenu) {
        self.backBarButtonItem.title = LOC(@"back");
        self.backBarButtonItem.enabled = YES;
    } else {
        self.backBarButtonItem.title = @"";
        self.backBarButtonItem.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureNavigationBar];
    [[self mainTabbarController] hideTabbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - NavigationBar

#pragma mark - NavigationBar

- (void)configureNavigationBar
{
    [super configureNavigationBar];
    [self.navigationController.navigationBar setBarTintColor:[UIColor purpleColor1]];
}


#pragma mark - Translations
- (void)updateLocalizations
{
    if (self.isFromMenu) {
        self.backBarButtonItem.title = LOC(@"back");
        self.backBarButtonItem.enabled = YES;
    } else {
        self.backBarButtonItem.title = @"";
        self.backBarButtonItem.enabled = NO;
    }
    self.titleLabel.text = LOC(@"how_it_works_text");
    [self.skipButton setTitle:LOC(@"skip") forState:UIControlStateNormal];
    self.descriptionLabel.text = LOC(@"intro_view_description_text_key");

    [self configureViewItems];
}

- (void)configureViewItems
{
    IntroductionItemViewModel *dualPinViewModel = [[IntroductionItemViewModel alloc] initWithLocalizationKey:@"dual_pin_code_title_key" imageName:@"intro_icon_dual_pin"];
    IntroductionItemViewModel *emergencyContactsViewModel = [[IntroductionItemViewModel alloc] initWithLocalizationKey:@"emergency_contacts_title_key" imageName:@"intro_icon_emergency_contact"];
    IntroductionItemViewModel *privateMessagesViewModel = [[IntroductionItemViewModel alloc] initWithLocalizationKey:@"messages_title_key" imageName:@"intro_icon_private_message"];
    IntroductionItemViewModel *forumsViewModel = [[IntroductionItemViewModel alloc] initWithLocalizationKey:@"forums_title_key" imageName:@"intro_icon_forum"];
    IntroductionItemViewModel *emergencyHelpButtonViewModel = [[IntroductionItemViewModel alloc] initWithLocalizationKey:@"help_button_title_key" imageName:@"intro_icon_help"];
    IntroductionItemViewModel *ngosViewModel = [[IntroductionItemViewModel alloc] initWithLocalizationKey:@"network_title" imageName:@"intro_icon_network"];

    [self.dualPinItem configureWithViewModel:dualPinViewModel];
    [self.emergencyContactsItem configureWithViewModel:emergencyContactsViewModel];
    [self.privateMessagesItem configureWithViewModel:privateMessagesViewModel];
    [self.forumsItem configureWithViewModel:forumsViewModel];
    [self.emergencyHelpItem configureWithViewModel:emergencyHelpButtonViewModel];
    [self.ngosItem configureWithViewModel:ngosViewModel];
}

#pragma mark - Actions

- (IBAction)skipButtonAction:(SYDesignableButton *)sender {
    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backBarButtonItemAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IntroductionViewItemDelegate

- (void)itemViewDidSelect:(IntroductionItemView *)itemView
{
    [self performSegueWithIdentifier:@"showIntroductionDetailView" sender:itemView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showIntroductionDetailView"]) {
        IntroductionItemView *itemView = (IntroductionItemView *)sender;
        IntroContentViewController *destinationVC = (IntroContentViewController *)segue.destinationViewController;
        IntroductionContentManager *contentManager = [[IntroductionContentManager alloc] init];
        IntroductionContentViewModel *itemViewModel;
        if (itemView == self.dualPinItem) {
            itemViewModel = [contentManager viewModelForType:IntroductionContentTypeDualPin];
        }

        if (itemView == self.emergencyContactsItem) {
            itemViewModel = [contentManager viewModelForType:IntroductionContentTypeEmergencyContacts];
        }

        if (itemView == self.privateMessagesItem) {
            itemViewModel = [contentManager viewModelForType:IntroductionContentTypePrivateMessages];
        }

        if (itemView == self.forumsItem) {
            itemViewModel = [contentManager viewModelForType:IntroductionContentTypeForums];
        }

        if (itemView == self.emergencyHelpItem) {
            itemViewModel = [contentManager viewModelForType:IntroductionContentTypeHelpButton];
        }

        if (itemView == self.ngosItem) {
            itemViewModel = [contentManager viewModelForType:IntroductionContentTypeNetwork];
        }
        destinationVC.viewModel = itemViewModel;
    }
}

@end
