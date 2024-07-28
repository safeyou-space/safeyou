//
//  LegalViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "LegalViewController.h"

#import "SettingsViewFieldViewModel.h"
#import "MoreViewTableViewCell.h"
#import "WebContentViewController.h"
#import "MainTabbarController.h"
#import "UserDataModel.h"
#import "SafeYou-Swift.h"

@interface LegalViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *dataSource;

@end

@implementation LegalViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
        [self configureDataSource];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *moreTableViewCellNib = [UINib nibWithNibName:@"MoreViewTableViewCell" bundle:nil];
    [self.tableView registerNib:moreTableViewCellNib forCellReuseIdentifier:@"MoreViewTableViewCell"];
    [self.tableView setSeparatorColor:[UIColor mainTintColor3]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor1];
    [[self mainTabbarController] hideTabbar:YES];
    [self.tableView reloadData];
}

#pragma mark - Override

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"title_legal");
    [self configureDataSource];
    [self.tableView reloadData];
}

#pragma mark - DataSource

- (void)configureDataSource
{
    NSMutableArray *dataSourceTemp = [[NSMutableArray alloc] init];
    
    SettingsViewFieldViewModel *termsAndConditionsViewModel = [[SettingsViewFieldViewModel alloc] init];
    termsAndConditionsViewModel.mainTitle =  LOC(@"terms_and_conditions");
    termsAndConditionsViewModel.accessoryType = FieldAccessoryTypeArrow;
    termsAndConditionsViewModel.actionString = @"showTermsAndConditions";
    [dataSourceTemp addObject:termsAndConditionsViewModel];
    
    SettingsViewFieldViewModel *privacyPolicyViewModel = [[SettingsViewFieldViewModel alloc] init];
    privacyPolicyViewModel.mainTitle =  LOC(@"privacy_policy");
    privacyPolicyViewModel.accessoryType = FieldAccessoryTypeArrow;
    privacyPolicyViewModel.actionString = @"showPrivacyPolicy";
    [dataSourceTemp addObject:privacyPolicyViewModel];
    
    SettingsViewFieldViewModel *consultantTermsViewModel = [[SettingsViewFieldViewModel alloc] init];
    consultantTermsViewModel.mainTitle =  LOC(@"consultant_terms_and_conditions");
    consultantTermsViewModel.accessoryType = FieldAccessoryTypeArrow;
    consultantTermsViewModel.actionString = @"showConsultantTerms";
    [dataSourceTemp addObject:consultantTermsViewModel];
    
    

    
    self.dataSource = dataSourceTemp;
    [self.tableView reloadData];
}

- (NSString *)languageNameForLanguageCode:(NSString *)languageCode
{
    if ([languageCode isEqualToString:@"en"]) {
        return @"English";
    }
    if ([languageCode isEqualToString:@"hy"]) {
        return @"Armenian";
    }
    
    return @"English";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SettingsViewFieldViewModel *viewData = cell.viewData;
    [self handleSelection:viewData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        SYLabelBold *titleLabel = [[SYLabelBold alloc] init];
        titleLabel.textColorType = SYColorTypeBlack;
        titleLabel.textColorAlpha = 1.0;
        titleLabel.frame = CGRectMake(20, 8, 320, 20);
        [UIFont fontWithName:@"HayRoboto-Bold" size:17];
        titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
        
        UIView *headerView = [[UIView alloc] init];
        [headerView addSubview:titleLabel];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - Actions From DataSource

- (void)handleSelection:(SettingsViewFieldViewModel *)viewData
{
    if (viewData.actionString.length) {
        SEL selector = NSSelectorFromString(viewData.actionString);
        IMP imp = [self methodForSelector:selector];
        if (imp) {
            void (*func)(id, SEL, id arg) = (void *)imp;
            func(self, selector, nil);
        }
    }
}

#pragma mark - Functionality
- (void)showTermsAndConditions
{
    WebContentViewController *webContentView = [WebContentViewController initializeWebContentView];
    NSString *userBirthday = [Settings sharedInstance].onlineUser.birthday;
    if ([Helper isUserAdultWithBirthday:userBirthday isRegisteration:NO]) {
        webContentView.contentType = SYRemotContentTypeTermsAndConditionsForAdults;
    } else {
        webContentView.contentType = SYRemotContentTypeTermsAndConditionsForMinors;
    }
    [self.navigationController pushViewController:webContentView animated:YES];
}

- (void)showPrivacyPolicy
{
    WebContentViewController *webContentView = [WebContentViewController initializeWebContentView];
    NSString *userBirthday = [Settings sharedInstance].onlineUser.birthday;
    if ([Helper isUserAdultWithBirthday:userBirthday isRegisteration:NO]) {
        webContentView.contentType = SYRemotContentTypePrivacyPolicyForAdults;
    } else {
        webContentView.contentType = SYRemotContentTypePrivacyPolicyForMinors;
    }
    [self.navigationController pushViewController:webContentView animated:YES];
}

- (void)showConsultantTerms
{
    WebContentViewController *webContentView = [WebContentViewController initializeWebContentView];
    webContentView.contentType = SYRemotContentTypeConsultantTermsAndConditions;
    [self.navigationController pushViewController:webContentView animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreViewTableViewCell *cell;
    
    SettingsViewFieldViewModel *rowData = self.dataSource[indexPath.row];
    NSString *cellIdentifier = @"MoreViewTableViewCell";
    if (rowData.accessoryType == FieldAccessoryTypeArrow) {
        cellIdentifier = @"MoreViewTableViewCell";
    } else if (rowData.accessoryType == FieldAccessoryTypeSwitch) {
        cellIdentifier = @"MoreViewTableViewSwitchCell";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell configureWithViewData:rowData];
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
