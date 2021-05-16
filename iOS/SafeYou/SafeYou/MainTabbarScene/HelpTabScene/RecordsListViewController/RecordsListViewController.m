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

@interface RecordsListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UnderLineButtonDelegate, UISearchBarDelegate>

@property (nonatomic) RecordsService *recordsService;
@property (nonatomic) RecordsListDataModel *recordsDataSource;
@property (nonatomic) NSArray *dataSource;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) BOOL isSearchActive;

@property (weak, nonatomic) IBOutlet UnderLineButtonView *buttonAll;
@property (weak, nonatomic) IBOutlet UnderLineButtonView *buttonSaved;
@property (weak, nonatomic) IBOutlet UnderLineButtonView *buttonSent;

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
    
    self.buttonAll.selected = YES;
    self.buttonSaved.selected = NO;
    self.buttonSent.selected = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self configureSearchBar];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self enableKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSearchActive) {
        [self loadRecordsWithSearch:self.searchBar.text];
    } else {
        [self loadRecords];
    }
}

- (void)updateLocalizations
{
    [self.buttonAll setTitle:LOC(@"title_all")];
    [self.buttonSaved setTitle:LOC(@"title_saved_key")];
    [self.buttonSent setTitle:LOC(@"title_sent_key")];
}

#pragma mark - SearchBar

- (void)configureSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UIColor *tint = [UIColor colorWithSYColor:SYColorTypeMain2 alpha:1.0];
    self.searchBar.tintColor = tint;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    self.searchBar.layer.cornerRadius = 15.0;
    self.searchBar.clipsToBounds = YES;
    self.searchBar.tintColor = [UIColor mainTintColor2];
    self.searchBar.placeholder = @"Search by date/time/place";
    self.navigationItem.titleView = self.searchBar;
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
}

- (void)underlineButtonAction:(UnderLineButtonView *)sender
{
    if (self.isSearchActive) {
        [self.searchBar resignFirstResponder];
    }
    [self resetAllButtons];
    sender.selected = YES;
    [self applyFilter:sender];
}
     

- (void)applyFilter:(UnderLineButtonView *)selectedButton
{
    if (selectedButton == self.buttonAll) {
        self.dataSource = self.recordsDataSource.records;
    }
    
    if (selectedButton == self.buttonSaved) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSent=%@",@(NO)];
        NSArray *filteredArray = [self.recordsDataSource.records filteredArrayUsingPredicate:predicate];
        self.dataSource = filteredArray;
    }
    
    if (selectedButton == self.buttonSent) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSent=%@",@(YES)];
        NSArray *filteredArray = [self.recordsDataSource.records filteredArrayUsingPredicate:predicate];
        self.dataSource = filteredArray;
    }
    
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

@end
