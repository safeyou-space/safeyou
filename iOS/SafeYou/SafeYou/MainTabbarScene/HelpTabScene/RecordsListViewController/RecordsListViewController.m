//
//  RecordsListViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordsListViewController.h"
#import "RecordsService.h"
#import "RecordsListDataModel.h"
#import "RecordListItemTableViewCell.h"
#import "RecordDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UnderLineButtonView.h"
#import "RecordSearchResult.h"
#import "MainTabbarController.h"

@interface RecordsListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate>

@property (nonatomic) RecordsService *recordsService;
@property (nonatomic) RecordsListDataModel *recordsDataSource;
@property (nonatomic) NSArray *dataSource;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) BOOL isSearchActive;
@property (weak, nonatomic) IBOutlet UIButton *buttonAll;

@property (weak, nonatomic) IBOutlet UIButton *buttonSent;

@property (weak, nonatomic) IBOutlet UIButton *buttonSaved;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RecordsListViewController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.recordsService = [[RecordsService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self configureTabBar];
    [self configureSearchBar];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self enableKeyboardNotifications];
    [self configureNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainTabbarController] hideTabbar:YES];
    if (self.isSearchActive) {
        [self loadRecordsWithSearch:self.searchBar.text];
    } else {
        [self loadRecords];
    }
}

- (void)updateLocalizations
{
    [self.buttonAll  setTitle:LOC(@"title_all") forState:UIControlStateNormal];
    [self.buttonSaved  setTitle:LOC(@"title_saved_key") forState:UIControlStateNormal];
    [self.buttonSent  setTitle:LOC(@"title_sent_key") forState:UIControlStateNormal];

    [self.searchBar setValue:LOC(@"cancel") forKey:@"cancelButtonText"];
    self.searchBar.placeholder = LOC(@"search");
}

#pragma mark - SearchBar

- (void)configureSearchBar
{
    UIColor *purpleColor = [UIColor purpleColor1];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    self.searchBar.layer.cornerRadius = 15.0;
    self.searchBar.clipsToBounds = YES;
    self.searchBar.tintColor = purpleColor;
    self.searchBar.searchTextField.textColor = purpleColor;
    self.searchBar.searchTextField.leftView.tintColor = purpleColor;
    self.searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchBar.searchTextField.layer.borderColor = purpleColor.CGColor;
    self.searchBar.searchTextField.layer.borderWidth = 1.0;
    self.searchBar.searchTextField.layer.cornerRadius = 15.0;
    [self.searchBar setImage:[[UIImage imageNamed:@"close_icon"] imageWithTintColor:purpleColor] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - TabBar

- (void)configureTabBar
{
    self.buttonAll.selected = YES;
    self.buttonSaved.selected = NO;
    self.buttonSent.selected = NO;
    [self.buttonAll setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.buttonAll.backgroundColor = UIColor.purpleColor1;
    
    self.buttonAll.layer.cornerRadius = 15;
    self.buttonAll.clipsToBounds = YES;
    self.buttonSaved.layer.cornerRadius = 15;
    self.buttonSaved.clipsToBounds = YES;
    self.buttonSent.layer.cornerRadius = 15;
    self.buttonSent.clipsToBounds = YES;
}

#pragma mark - Data

- (void)resetDataSource
{
    self.dataSource = self.recordsDataSource.records;
    [self.tableView reloadData];
}

- (void)loadRecordsWithSearch:(NSString *)searchText
{
    [self showLoader];
    weakify(self);
    [self.recordsService getAllRecordsWithSearch:searchText complition:^(NSArray *searchResult) {
        strongify(self);
        [self hideLoader];
        self.dataSource = searchResult;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

- (void)loadRecords
{
    [self showLoader];
    weakify(self);
    [self.recordsService getAllRecordsWithComplition:^(RecordsListDataModel * _Nonnull records) {
        strongify(self);
        [self hideLoader];
        self.recordsDataSource = records;
        self.dataSource = records.records;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

#pragma mark - UnderlineButtonDelegate

- (void)resetAllButtons
{
    self.buttonAll.selected = NO;
    self.buttonSaved.selected = NO;
    self.buttonSent.selected = NO;
    [self.buttonAll setTitleColor:UIColor.purpleColor1 forState:UIControlStateNormal];
    self.buttonAll.backgroundColor = UIColor.mainTintColor5;
    [self.buttonSaved setTitleColor:UIColor.purpleColor1 forState:UIControlStateNormal];
    self.buttonSaved.backgroundColor = UIColor.mainTintColor5;
    [self.buttonSent setTitleColor:UIColor.purpleColor1 forState:UIControlStateNormal];
    self.buttonSent.backgroundColor = UIColor.mainTintColor5;
}

- (IBAction)allButtonAction:(id)sender {
    if (self.isSearchActive) {
        [self.searchBar resignFirstResponder];
        
    }
    [self resetAllButtons];
    self.buttonAll.selected = YES;
    self.buttonAll.backgroundColor = UIColor.purpleColor1;
    self.dataSource = self.recordsDataSource.records;
    [self.tableView reloadData];
    [self.buttonAll setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

- (IBAction)savedButtonAction:(id)sender {
    if (self.isSearchActive) {
        [self.searchBar resignFirstResponder];
    }
    [self resetAllButtons];
    self.buttonSaved.selected = YES;
    self.buttonSaved.backgroundColor = UIColor.purpleColor1;
    [self.buttonSaved setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSent=%@",@(NO)];
    NSArray *filteredArray = [self.recordsDataSource.records filteredArrayUsingPredicate:predicate];
    self.dataSource = filteredArray;
    [self.tableView reloadData];
}

- (IBAction)sentButtonAction:(id)sender {
    if (self.isSearchActive) {
        [self.searchBar resignFirstResponder];
    }
    [self resetAllButtons];
    self.buttonSent.selected = YES;
    self.buttonSent.backgroundColor = UIColor.purpleColor1;
    [self.buttonSent setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSent=%@",@(YES)];
    NSArray *filteredArray = [self.recordsDataSource.records filteredArrayUsingPredicate:predicate];
    self.dataSource = filteredArray;
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2) {
        [self loadRecordsWithSearch:searchText];
    } else if (searchText.length == 0) {
        self.dataSource = @[];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.isSearchActive = YES;
    self.dataSource = @[];
    [self.tableView reloadData];
    self.navigationItem.hidesBackButton = YES;
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.isSearchActive = NO;
    searchBar.text = @"";
    self.dataSource = self.recordsDataSource.records;
    [self.tableView reloadData];
    
    self.navigationItem.hidesBackButton = NO;
    searchBar.showsCancelButton = NO;
    [self resetDataSource];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
   
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordListItemTableViewCell *recordCell = [tableView dequeueReusableCellWithIdentifier:@"RecordListItemTableViewCell"];
    if (self.isSearchActive) {
        RecordSearchResult *searchResult = self.dataSource[indexPath.row];
        [recordCell configureCellWithRecordName:searchResult.name];
    } else {
        RecordListItemDataModel *recordData = self.dataSource[indexPath.row];

        [recordCell configureCellWithRecordData:recordData];

    }
    
    return recordCell;
}

#pragma mark - UITableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchActive) {
        weakify(self);
        [self showLoader];
        RecordSearchResult *searchResult = self.dataSource[indexPath.row];
        [self.recordsService getRecord:searchResult.serviceId complition:^(id  _Nonnull record) {
            strongify(self)
            [self hideLoader];
            [self performSegueWithIdentifier:@"showRecordFromSearch" sender:record];
        } failure:^(NSError * _Nonnull error) {
            strongify(self)
            [self hideLoader];
        }];
    } else {
        [self performSegueWithIdentifier:@"showRecordDetails" sender:indexPath];
    }
}
     
#pragma mark - EmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *locString = LOC(@"no_records_yet_text_key");
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:locString];
    return aString;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);;
    weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRecordFromSearch"]) {
        RecordDetailsViewController *destinationVC = segue.destinationViewController;
        RecordListItemDataModel *record = (RecordListItemDataModel *)sender;
        destinationVC.recordsList = @[record];
        destinationVC.selectedIndex = 0;
        [self.searchBar resignFirstResponder];
    }
    if ([segue.identifier isEqualToString:@"showRecordDetails"]) {
        NSIndexPath *senderIndexPath = (NSIndexPath *)sender;
        RecordDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.recordsList = self.dataSource;
        destinationVC.selectedIndex = senderIndexPath.row;
    }
}

#pragma mark - UI Customization

- (void)configureNavigationBar
{
    self.navigationController.navigationBar.standardAppearance.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor = [UIColor whiteColor];
}

@end
