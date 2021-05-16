//
//  RegionalOptionsListViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "RegionalOptionsListViewController.h"
#import "RegionalOptiontableViewCell.h"
#import "RegionalOptionDataModel.h"
#import "ChooseRegionalOptionViewModel.h"

@interface RegionalOptionsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYCorneredButton *saveButton;
- (IBAction)saveButtonAction:(SYCorneredButton *)sender;

@property (nonatomic) RegionalOptionDataModel *selectedRegionalOption;

@end

@implementation RegionalOptionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UINib *optionCellNib = [UINib nibWithNibName:@"RegionalOptiontableViewCell" bundle:nil];
    [self.tableView registerNib:optionCellNib forCellReuseIdentifier:@"RegionalOptiontableViewCell"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseRegionalOptionViewModel *viewData = self.dataSource[indexPath.row];
    self.selectedRegionalOption = viewData.regionalOptionData;
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
    if ([self.delegate respondsToSelector:@selector(regionalOptionView:didSelectedOption:)]) {
        [self.delegate regionalOptionView:self didSelectedOption:self.selectedRegionalOption];
    }
}
@end
