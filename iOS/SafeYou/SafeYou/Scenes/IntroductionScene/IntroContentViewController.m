//
//  IntroContentViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/21/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "IntroContentViewController.h"
#import "IntroductionContentViewModel.h"
#import "IntroDetailsContentView.h"

@interface IntroContentViewController ()
@property (weak, nonatomic) IBOutlet SYDesignableImageView *iconImageView;
@property (weak, nonatomic) IBOutlet SYLabelBold *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *secondaryTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet SYCorneredButton *skipButton;

@end

@implementation IntroContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
}



#pragma mark -

- (void)configureView
{
    self.title = @"";
    self.backBarButtonItem.title = LOC(@"back");
    [self.skipButton setTitle:LOC(@"skip") forState:UIControlStateNormal];
    self.iconImageView.image = [UIImage imageNamed:self.viewModel.iconImageName];
    self.titleLabel.text = self.viewModel.localizedTitle;
    self.secondaryTitleLabel.text = self.viewModel.localizedHeading;
    [self cleanStackView];

    for (IntrodutionDescriptionViewModel *descriptionViewModel in self.viewModel.descritpionContents) {
        IntroDetailsContentView *descriptionView = [[IntroDetailsContentView alloc] initWithViewModel:descriptionViewModel];
        [self.stackView addArrangedSubview:descriptionView];
    }
}

- (void)cleanStackView
{
    for (UIView *arrancgedSubview in self.stackView.arrangedSubviews) {
        [self.stackView removeArrangedSubview:arrancgedSubview];
    }
}

#pragma mark - NavigationBar

- (void)configureNavigationBar
{
    [super configureNavigationBar];
    [self.navigationController.navigationBar setBarTintColor:[UIColor purpleColor1]];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    [self configureView];
}

- (IBAction)skipButtonAction:(SYDesignableButton *)sender {
    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
