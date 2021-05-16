//
//  ChooseOptionsViewController.m
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 1/25/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "ChooseOptionsViewController.h"
#import "ChooseOptionsTableViewCell.h"
#import "ChooseOptionsHeaderView.h"

@interface ChooseOptionsViewController () <BaseExtendableTableHeaderCellDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *openedSectionsArray;
@property (nonatomic, strong) UIFont *cellFont;

@property (nonatomic, strong) NSMutableArray *searchOptionsArray;
@property (nonatomic) BOOL isAlreadySeleced;
@property (nonatomic) BOOL isSearchMode;

@end

@implementation ChooseOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cellFont = [UIFont systemFontOfSize:16];
    if(self.showSearchBar) {
        [self.optionsTableView setContentOffset:CGPointMake(0,44) animated:YES];
    } else {
        self.optionsTableView.tableHeaderView = nil;
    }
    
    [self initialSearchOptionsArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLocalizations];
    [_optionsTableView reloadData];
    [self configureView];
    [self configureNavigationBar];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Customization
- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *image = [self imageWithColor:[UIColor mainTintColor1] withPoint:CGSizeMake(1, 1)];
    
//    [[UINavigationBar appearance] setShadowImage:image];
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (UIImage *)imageWithColor:(UIColor *)color withPoint:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isModal]) {
        NSLog(@"is modal");
    } else {
        NSLog(@"isZ modal");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateLocalizations
{
    //self.titleLabel.text = _optionTitle ? _optionTitle : LOC(@"choose_option");
    self.navigationItem.title = _optionTitle ? _optionTitle : LOC(@"choose_option");
    
//    [self.leftBarButton setImage:[UIImage imageNamed:LOC_IMAGES(@"back_button_icon")] forState:UIControlStateNormal];
//    [self.rightBarButton setTitle:self.applyButtonText ? self.applyButtonText : LOC(@"apply") forState:UIControlStateNormal];
}

- (BOOL)isModal
{
    return NO;
}

- (void)configureView
{
    if([self isModal]) {
//        [self.leftBarButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
//        self.leftBarButtonItem.image = [UIImage imageNamed:@"Close"];
    } else {
//        [self.leftBarButton setImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
//        self.leftBarButtonItem.image = [UIImage imageNamed:LOC_IMAGES(@"back_button_icon")];
    }
}

- (void)initialSearchOptionsArray
{
    self.searchOptionsArray = [NSMutableArray arrayWithArray:self.optionsArray];
}

- (BOOL)didOpenSection:(NSInteger)section
{
    return NO;
}

#pragma mark - BaseExtendableTableHeaderCellDelegate.
- (void)didSelectAtSectionAtIndex:(NSInteger)index
{
    BOOL isSectionOpen = ([_optionsTableView numberOfRowsInSection:index] == 0)?NO:YES;
    NSString *optionSectionName = [_extendableOptionsArray objectAtIndex:index];
    if(isSectionOpen) {
        [_openedSectionsArray removeObject:optionSectionName];
    } else {
        [_openedSectionsArray addObject:optionSectionName];
    }
    [_optionsTableView reloadData];
    
}

#pragma mark - UITableViewDataSource delegate

// section row count.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.optionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *optionName;
    
    optionName = [self.searchOptionsArray objectAtIndex:indexPath.row];
    
    
    //ChooseOptionsTableViewCell *chooseOptionsTableViewCell = (ChooseOptionsTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGRect textRect = [optionName boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 63, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.cellFont} context:nil];
    if(textRect.size.height < 26) {
        return 46;
    } else {
        return ceilf(textRect.size.height) + 20;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ChooseOptionsTableViewCell";
    if (self.chooseOptionType == SYChooseOptionTypeRadio) {
        CellIdentifier = @"ChooseOptionsRadioTableViewCell";
    }
    ChooseOptionsTableViewCell *chooseOptionsTableViewCell = (ChooseOptionsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    chooseOptionsTableViewCell.chooseOptionType = self.chooseOptionType;
    if (chooseOptionsTableViewCell == nil) {
        chooseOptionsTableViewCell = [[ChooseOptionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    chooseOptionsTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *optionName;
    
    optionName = [self.optionsArray objectAtIndex:indexPath.row];
    
    [chooseOptionsTableViewCell configureForOptionName:optionName];
    
    
    if ([optionName isEqualToString:_selectedOptionName] && !self.isAlreadySeleced) {
        self.isAlreadySeleced = YES;
        chooseOptionsTableViewCell.isSelect = YES;
    } else {
        chooseOptionsTableViewCell.isSelect = NO;
    }

    
    return chooseOptionsTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *optionName = [self.searchOptionsArray objectAtIndex:indexPath.row];
    self.selectedOptionName = optionName;
    NSUInteger row = [self.optionsArray indexOfObject:optionName];
    
    if([self.delegate respondsToSelector:@selector(optionDidSelect:withRow:)]) {
        [self.delegate optionDidSelect:self.selectedOptionName withRow:row];
    }
    if (self.selectionBlock) {
        self.selectionBlock(row);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [tableView reloadData];
}

#pragma mark - actions
- (IBAction)leftBarButtonPressed:(id)sender
{
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)rightBarButtonPressed:(id)sender
{
    [self apply];
}


#pragma mark -
- (void)apply
{
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
    self.isSearchMode = YES;
    [self.optionsTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    self.isSearchMode = NO;
    [self initialSearchOptionsArray];
    [self.optionsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        
    }
    
    [self handleSearch:searchText];
}

- (void)handleSearch:(NSString *)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    self.searchOptionsArray = [NSMutableArray arrayWithArray:[self.optionsArray filteredArrayUsingPredicate:resultPredicate]];
    [self.optionsTableView reloadData];
}

#pragma mark - Factory

+ (ChooseOptionsViewController *)instantiateChooseOptionController
{
    UIStoryboard *chooseOptionStoryboard = [UIStoryboard storyboardWithName:@"ChooseOptionsViewController" bundle:nil];
    ChooseOptionsViewController *chooseOptionController = [chooseOptionStoryboard instantiateViewControllerWithIdentifier:@"ChooseOptionsViewController"];
    return chooseOptionController;
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
