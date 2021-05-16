//
//  ChooseCountryViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/30/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseCountryViewController.h"
#import "ChooseLanguageViewController.h"
#import "RegionalOptionsService.h"
#import "ChooseRegionalOptionViewModel.h"
#import "ChooseRegionalOptionViewModel.h"
#import "RegionalOptionDataModel.h"
#import "ChooseItemView.h"

@implementation ChooseCountryViewController

@synthesize selectedRegionalOption = _selectedRegionalOption;


- (void)fetchOptions
{
    self.rightBarButtonItem.enabled = NO;
    [self showLoader];
    weakify(self);
    [self.optionsService getCountryListWithComplition:^(NSArray<CountryDataModel *> * _Nonnull counrtyList) {
        strongify(self);
        [self hideLoader];
        NSMutableArray *viewModelsArray = [[NSMutableArray alloc] init];
        for (CountryDataModel *countryData in counrtyList) {
            ChooseRegionalOptionViewModel *viewData = [[ChooseRegionalOptionViewModel alloc] initWithData:(RegionalOptionDataModel *)countryData];
            [viewModelsArray addObject:viewData];
        }
        self.dataSource = [viewModelsArray copy];
        self.rightBarButtonItem.enabled = YES;
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        
    }];
}

#pragma mark - Setter

- (void)setSelectedRegionalOption:(CountryDataModel *)selectedRegionalOption
{
    _selectedRegionalOption = selectedRegionalOption;
    [[Settings sharedInstance] setSelectedCountry:_selectedRegionalOption];
}

#pragma mark - Navigation

- (void)showNextView
{
    ChooseLanguageViewController *chooseLanguageVC = [[ChooseLanguageViewController alloc] initWithNibName:@"ChooseRegionalOptionsViewController" bundle:nil];
    [self.navigationController pushViewController:chooseLanguageVC animated:YES];
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.submitButtonTitle =  LOC(@"next_key").uppercaseString;
    self.rightBarButtonTitle = LOC(@"next_key");
    self.mainTitle = LOC(@"choose_your_country");
    self.secondaryTitle = LOC(@"which_country_to_browse_in");
}

@end
