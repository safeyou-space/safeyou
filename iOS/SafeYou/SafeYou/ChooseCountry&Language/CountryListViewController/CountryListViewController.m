//
//  RegionalOptionsListViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "CountryListViewController.h"
#import "RegionalOptiontableViewCell.h"
#import "RegionalOptionDataModel.h"
#import "ChooseRegionalOptionViewModel.h"
#import "RegionalOptionsService.h"

@interface CountryListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYCorneredButton *saveButton;
- (IBAction)saveButtonAction:(SYCorneredButton *)sender;

@property (nonatomic) CountryDataModel *selectedRegionalOption;
@property (nonatomic) RegionalOptionsService *optionsService;

@property (nonatomic) NSArray <ChooseCountryViewModel *>*dataSource;

@end

@implementation CountryListViewController

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
    self.navigationItem.title = LOC(@"country_title_key");
    [self.saveButton setTitle:LOC(@"save_key") forState:UIControlStateNormal];
}

#pragma mark - Fetch Country Options

- (void)fetchOptions
{
    [self showLoader];
    weakify(self);
    [self.optionsService getCountryListWithComplition:^(NSArray<CountryDataModel *> * _Nonnull counrtyList) {
        strongify(self);
        [self hideLoader];
        [self configureViewWithReceivedOptions:counrtyList];
        
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        
    }];
}

- (void)configureViewWithReceivedOptions:(NSArray <CountryDataModel *> *)optionsList
{
    NSMutableArray *viewModelsArray = [[NSMutableArray alloc] init];
    for (CountryDataModel *countryData in optionsList) {
        ChooseRegionalOptionViewModel *viewData = [[ChooseCountryViewModel alloc] initWithData:(RegionalOptionDataModel *)countryData];
        [viewModelsArray addObject:viewData];
        if ([countryData.shortCode isEqualToString:[Settings sharedInstance].selectedCountryCode]) {
            viewData.isSelected = YES;
            self.selectedRegionalOption = (CountryDataModel *)viewData.regionalOptionData;
        } else {
            viewData.isSelected = NO;
        }
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
    ChooseCountryViewModel *selectedViewData = [self viewDataForOption:self.selectedRegionalOption];
    NSInteger previousSelectionIdex = [self.dataSource indexOfObject:selectedViewData];
    NSIndexPath *previousSelectedIndexPath = [NSIndexPath indexPathForRow:previousSelectionIdex inSection:0];
    RegionalOptiontableViewCell *previousSelectedCell = [tableView cellForRowAtIndexPath:previousSelectedIndexPath];
    [previousSelectedCell configureWithViewData:selectedViewData];
    
    ChooseRegionalOptionViewModel *viewData = self.dataSource[indexPath.row];
    self.selectedRegionalOption = (CountryDataModel *)viewData.regionalOptionData;
}

- (void)setSelectedRegionalOption:(CountryDataModel *)selectedRegionalOption
{
    _selectedRegionalOption = selectedRegionalOption;
    [self deselectAllOptions];
    ChooseCountryViewModel *selectedViewData = [self viewDataForOption:self.selectedRegionalOption];
    selectedViewData.isSelected = YES;
    [self.tableView reloadData];
}

- (ChooseCountryViewModel *)viewDataForOption:(CountryDataModel *)optionData
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
    if ([self.delegate respondsToSelector:@selector(countryOptionsView:didSelectedOption:)]) {
        [self.delegate countryOptionsView:self didSelectedOption:self.selectedRegionalOption];
    }
}
@end
