//
//  RegionalOptionsListViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "LanguagesListViewController.h"
#import "RegionalOptiontableViewCell.h"
#import "RegionalOptionDataModel.h"
#import "ChooseRegionalOptionViewModel.h"
#import "RegionalOptionsService.h"

@interface LanguagesListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYCorneredButton *saveButton;
- (IBAction)saveButtonAction:(SYCorneredButton *)sender;

@property (nonatomic) LanguageDataModel *selectedRegionalOption;
@property (nonatomic) RegionalOptionsService *optionsService;

@end

@implementation LanguagesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.optionsService = [[RegionalOptionsService alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UINib *optionCellNib = [UINib nibWithNibName:@"RegionalOptiontableViewCell" bundle:nil];
    [self.tableView registerNib:optionCellNib forCellReuseIdentifier:@"RegionalOptiontableViewCell"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self fetchOptions];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"language_title_key");
    [self.saveButton setTitle:LOC(@"save_key") forState:UIControlStateNormal];
}

#pragma mark - Fetch Language Options

- (void)fetchOptions
{
    [self showLoader];
    weakify(self);
    if (self.currentSelectedCountry && self.isFromChooseCountry) {
        [self.optionsService getLanguagesListForCountry:self.currentSelectedCountry.shortCode withComplition:^(NSArray<LanguageDataModel *> * _Nonnull languagesList) {
            strongify(self);
            [self hideLoader];
            [self configureViewWithReceivedLanguages:languagesList];
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
        }];
    } else {
        [self.optionsService getLanguagesListWithComplition:^(NSArray<LanguageDataModel *> * _Nonnull languagesList) {
            strongify(self);
            [self hideLoader];
            [self configureViewWithReceivedLanguages:languagesList];
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
        }];
    }
}

- (void)configureViewWithReceivedLanguages:(NSArray *)languagesList
{
    NSMutableArray <ChooseLanguageViewModel *>*viewModelsArray = [[NSMutableArray alloc] init];
    for (LanguageDataModel *languageData in languagesList) {
        ChooseLanguageViewModel *viewData = [[ChooseLanguageViewModel alloc] initWithData:(RegionalOptionDataModel *)languageData];
        if ([languageData.shortCode isEqualToString:[Settings sharedInstance].selectedLanguageCode]) {
            viewData.isSelected = YES;
            self.selectedRegionalOption = (LanguageDataModel *)viewData.regionalOptionData;
        } else {
            viewData.isSelected = NO;
        }
        [viewModelsArray addObject:viewData];
    }
    
    if (self.selectedRegionalOption == nil) {
        self.selectedRegionalOption = languagesList.firstObject;
        viewModelsArray.firstObject.isSelected = YES;
    }
    self.dataSource = [viewModelsArray copy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseLanguageViewModel *selectedViewData = [self viewDataForOption:self.selectedRegionalOption];
    NSInteger previousSelectionIdex = [self.dataSource indexOfObject:selectedViewData];
    NSIndexPath *previousSelectedIndexPath = [NSIndexPath indexPathForRow:previousSelectionIdex inSection:0];
    RegionalOptiontableViewCell *previousSelectedCell = [tableView cellForRowAtIndexPath:previousSelectedIndexPath];
    [previousSelectedCell configureWithViewData:selectedViewData];
    
    ChooseRegionalOptionViewModel *viewData = self.dataSource[indexPath.row];
    self.selectedRegionalOption = (LanguageDataModel *)viewData.regionalOptionData;
}

- (void)setSelectedRegionalOption:(LanguageDataModel *)selectedRegionalOption
{
    _selectedRegionalOption = selectedRegionalOption;
    [self deselectAllOptions];
    ChooseLanguageViewModel *selectedViewData = [self viewDataForOption:self.selectedRegionalOption];
    selectedViewData.isSelected = YES;
    [self.tableView reloadData];
    
}

- (ChooseLanguageViewModel *)viewDataForOption:(LanguageDataModel *)optionData
{
    NSArray *optionsArray = [self.dataSource valueForKeyPath:@"regionalOptionData"];
    NSInteger selectedOptionIdex = [optionsArray indexOfObject:self.selectedRegionalOption];
    return self.dataSource[selectedOptionIdex];
}

- (void)deselectAllOptions
{
    for (ChooseCountryViewModel *viewData in self.dataSource) {
        viewData.isSelected = NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegionalOptiontableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:@"RegionalOptiontableViewCell"];
    ChooseRegionalOptionViewModel *viewData = self.dataSource[indexPath.row];
    [optionCell configureWithViewData:viewData];
    
    return optionCell;
}


#pragma mark - Actions

- (IBAction)saveButtonAction:(SYCorneredButton *)sender {
    if ([self.delegate respondsToSelector:@selector(languagesOptionView:didSelectedOption:)]) {
        [self.delegate languagesOptionView:self didSelectedOption:self.selectedRegionalOption];
    }
}
@end
