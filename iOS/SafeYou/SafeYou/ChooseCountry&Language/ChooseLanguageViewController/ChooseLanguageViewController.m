//
//  ChooseLanguageViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseLanguageViewController.h"
#import "RegionalOptionsService.h"
#import "ChooseRegionalOptionViewModel.h"
#import "ChooseRegionalOptionViewModel.h"
#import "RegionalOptionDataModel.h"
#import "ChooseItemView.h"

@interface ChooseLanguageViewController ()

@end

@implementation ChooseLanguageViewController

@synthesize selectedRegionalOption = _selectedRegionalOption;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectedRegionalOption = nil;
    [self enableNextButton:self.selectedRegionalOption != nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


#pragma mark - Fetch Options

- (void)fetchOptions
{
    self.rightBarButtonItem.enabled = NO;
    [self showLoader];
    weakify(self);
    [self.optionsService getLanguagesListWithComplition:^(NSArray<LanguageDataModel *> * _Nonnull languagesList) {
        strongify(self);
        [self hideLoader];
        NSMutableArray *viewModelsArray = [[NSMutableArray alloc] init];
        for (LanguageDataModel *languageData in languagesList) {
            ChooseLanguageViewModel *viewData = [[ChooseLanguageViewModel alloc] initWithData:(RegionalOptionDataModel *)languageData];
            [viewModelsArray addObject:viewData];
        }
        self.dataSource = [viewModelsArray copy];
        self.rightBarButtonItem.enabled = YES;
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        
    }];
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.submitButtonTitle =  LOC(@"next_key").uppercaseString;
    self.rightBarButtonTitle = LOC(@"next_key");
    self.mainTitle = LOC(@"choose_your_language");
    self.secondaryTitle = LOC(@"choose_the_language_to_continue");
}

#pragma mark - Navigation

- (void)showNextView
{
    // regional options are selected show rest staff
    [self presentIntroductionView];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *welcomeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    [self.navigationController pushViewController:welcomeVC animated:YES];
}

- (void)presentIntroductionView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Introduction" bundle:nil];
    UINavigationController *introductionNVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroductionNavigationController"];
    introductionNVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:introductionNVC animated:YES completion:nil];
}

#pragma mark - Setter

- (void)setSelectedRegionalOption:(LanguageDataModel *)selectedRegionalOption
{
    _selectedRegionalOption = selectedRegionalOption;
    [[Settings sharedInstance]  setSelectedLanguage:selectedRegionalOption];
    [self enableNextButton:self.selectedRegionalOption != nil];
}

@end
