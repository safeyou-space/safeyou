//
//  ReportCategoriesViewController.m
//  SafeYou
//
//  Created by Edgar on 23.07.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "ReportCategoriesViewController.h"
#import "MainTabbarController.h"
#import "SYForumService.h"
#import "ReportCategoryListDataModel.h"
#import "ReportCategoryDataModel.h"
#import "ReportCategoryTableViewCell.h"

@interface ReportCategoriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) SYForumService *forumService;
@property (nonatomic) NSArray <ReportCategoryDataModel *> *items;

@end

@implementation ReportCategoriesViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.forumService = [[SYForumService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLocalizations];
    [self configureNibsForUsing];
    [self getCategories];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
}

#pragma mark - Private Methods

- (void)configureView
{
    [self showNotificationsBarButtonitem:NO];
    [[self mainTabbarController] hideTabbar:YES];
    self.navigationItem.title = LOC(@"categories");
}

- (void)configureNibsForUsing
{
    UINib *commentCellNib = [UINib nibWithNibName:@"ReportCategoryTableViewCell" bundle:nil];
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"ReportCategoryTableViewCell"];
}

- (void)getCategories
{
    weakify(self);
    [self showLoader];
    [self.forumService getReportCategories:^(ReportCategoryListDataModel * _Nonnull categoryList) {
        strongify(self);
        [self hideLoader];
        self.items = categoryList.items;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportCategoryTableViewCell *cell = (ReportCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ReportCategoryTableViewCell" forIndexPath:indexPath];
    ReportCategoryDataModel *viewData = [self.items objectAtIndex:indexPath.row];
    [cell configureWithViewData:viewData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(reportCategory:)]) {
        ReportCategoryDataModel *viewData = [self.items objectAtIndex:indexPath.row];
        [self.delegate reportCategory:viewData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Translations

- (void)updateLocalizations
{
    self.title = LOC(@"categories");
}

@end
