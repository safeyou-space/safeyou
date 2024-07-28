//
//  ForumFiltersViewController.m
//  SafeYou
//
//  Created by MacBook Pro on 31.10.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ForumFiltersViewController.h"
#import "FiltersView.h"
#import "FilterViewModel.h"
#import "RegionalOptionsService.h"
#import "RegionalOptionDataModel.h"
#import "SYForumService.h"
#import "ForumCategoryDataModel.h"

#define EXPAND_ANIMATION_DURATION 0.2
#define RESET_BUTTON_TOP_BOTTOM_SPACE 15.0
#define SEPERATOR_LINE_HEIGHT 1.0

@interface ForumFiltersViewController () <FiltersViewDelegate>

//Categories filters
@property (weak, nonatomic) IBOutlet SYDesignableLabel *categoriesTitleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *categoriesArrowImageView;
@property (weak, nonatomic) IBOutlet FiltersView *categoriesFilterView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *clearCategoriesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoriesFilterViewHeightConstraint;
@property (nonatomic) BOOL isCategoriesExpanded;

//Languages filters
@property (weak, nonatomic) IBOutlet SYDesignableLabel *languagesTitleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *languagesArrowImageView;
@property (weak, nonatomic) IBOutlet FiltersView *languagesFilterView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *resetDefaultLanguagesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *languagesFilterViewHeightConstraint;
@property (nonatomic) BOOL isLanguagesExpanded;

//Countries filters
@property (weak, nonatomic) IBOutlet SYDesignableLabel *countriesTitleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *countriesArrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countriesFilterViewHeightConstraint;
@property (nonatomic) BOOL isCountriesExpanded;

@property (weak, nonatomic) IBOutlet SYDesignableButton *clearAllButton;
@property (weak, nonatomic) IBOutlet SYCorneredButton *showResultsButton;

@property (nonatomic) NSArray *categoriesDataSource;
@property (nonatomic) NSArray *languagesDataSource;
@property (nonatomic) RegionalOptionsService *optionsService;
@property (nonatomic) SYForumService *forumsSrvice;

@end

@implementation ForumFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.optionsService = [[RegionalOptionsService alloc] init];
    self.forumsSrvice = [[SYForumService alloc] init];
    
    [self loadCategories];
    [self loadLanguages];
    
    [self updateLocalizations];
}

#pragma mark - FiltersViewDelegate

- (void)filterView:(FiltersView *)filterView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - IBActions

- (IBAction)closeButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)expandCategoriesButtonAction:(UIButton *)sender
{
    [self expandCategoriesFilters:!self.isCategoriesExpanded];
}

- (IBAction)expandLanguagesButtonAction:(UIButton *)sender
{
    [self expandLanguagesFilters:!self.isLanguagesExpanded];
}

- (IBAction)clearCategoriesButtonAction:(id)sender
{
    [self.categoriesFilterView clearAllSelections];
}

- (IBAction)resetDefaultLanguagesButtonAction:(id)sender
{
    NSLog(@"resetDefaultLanguagesButtonAction");
    [self.languagesFilterView clearAllSelections];
}

- (IBAction)clearAllButtonAction:(id)sender
{
    NSLog(@"clearAllButtonAction");
    [self.categoriesFilterView clearAllSelections];
    [self.languagesFilterView clearAllSelections];
    
}

- (IBAction)showResultsButtonAction:(id)sender
{
    NSArray <NSString *>*selectedCategories = [self.categoriesFilterView getSelectedItems];
    NSArray <NSString *>*selectedLanguages = [self.languagesFilterView getSelectedItems];
    NSString *selectedLanguage = [[NSString alloc] init];
    if (selectedLanguages.count > 0) {
        selectedLanguage = selectedLanguages[0];
    }
    
    if ([self.delegate respondsToSelector:@selector(didForumFilter:withLanguage:andCategories:)]) {
        [self.delegate didForumFilter:self withLanguage:selectedLanguage andCategories:selectedCategories];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.title = LOC(@"filters");
    self.categoriesTitleLabel.text = LOC(@"categories");
    [self.clearCategoriesButton setTitle:LOC(@"clear_categories") forState:UIControlStateNormal];
    self.languagesTitleLabel.text = LOC(@"languages");
    [self.resetDefaultLanguagesButton setTitle:LOC(@"back_to_default_language") forState:UIControlStateNormal];

    [self.clearAllButton setTitle:LOC(@"clear_all_filters") forState:UIControlStateNormal];
    [self.showResultsButton setTitle:LOC(@"show_results") forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)expandCategoriesFilters:(BOOL)expanded
{
    self.isCategoriesExpanded = expanded;
    self.categoriesFilterViewHeightConstraint.constant = self.isCategoriesExpanded ? self.categoriesFilterView.contentSize.height + self.clearCategoriesButton.frame.size.height + 2*RESET_BUTTON_TOP_BOTTOM_SPACE + SEPERATOR_LINE_HEIGHT : SEPERATOR_LINE_HEIGHT;
    
    [UIView animateWithDuration:EXPAND_ANIMATION_DURATION animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self rotate:!self.isCategoriesExpanded imageView:self.categoriesArrowImageView];
}

- (void)expandLanguagesFilters:(BOOL)expanded
{
    self.isLanguagesExpanded = expanded;
    self.languagesFilterViewHeightConstraint.constant = self.isLanguagesExpanded ? self.languagesFilterView.contentSize.height + self.resetDefaultLanguagesButton.frame.size.height + 2*RESET_BUTTON_TOP_BOTTOM_SPACE + SEPERATOR_LINE_HEIGHT : SEPERATOR_LINE_HEIGHT;
    
    [UIView animateWithDuration:EXPAND_ANIMATION_DURATION animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self rotate:!self.isLanguagesExpanded imageView:self.languagesArrowImageView];
}

- (void)rotate:(BOOL)rotate imageView:(UIImageView *)imageView
{
    CGAffineTransform transform = rotate ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    
    [UIView animateWithDuration:EXPAND_ANIMATION_DURATION animations:^{
        imageView.transform = transform;
    }];
}

- (void)loadLanguages
{
    [self showLoader];
    weakify(self);
    NSString *currentCountry = [Settings sharedInstance].selectedCountryCode;
    [self.optionsService getLanguagesListForCountry:currentCountry withComplition:^(NSArray<LanguageDataModel *> * _Nonnull languagesList) {
        strongify(self);
        [self hideLoader];
        self.languagesDataSource = languagesList;
        [self setupLanguagesView];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

- (void)loadCategories
{
    [self showLoader];
    weakify(self);
    [self.forumsSrvice getForumCategoriesWithComplition:^(NSArray * _Nonnull categoriesList) {
        strongify(self);
        [self hideLoader];
        NSLog(@"categoriesList => %@", categoriesList);
        self.categoriesDataSource = categoriesList;
        [self setupCategoriesView];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
}

- (void)setupLanguagesView
{
    NSMutableArray <FilterViewModel *>*filterModelsArray = [[NSMutableArray alloc] init];
    
    FilterViewModel *modelAll = [[FilterViewModel alloc] init];
    modelAll.name = @"All";
    if (!self.selectedLanguage || [self.selectedLanguage isEqualToString:@""]) {
        modelAll.isSelected = YES;
    }
    [filterModelsArray addObject:modelAll];
    
    for (LanguageDataModel *languageData in self.languagesDataSource) {
        FilterViewModel *langModel = [[FilterViewModel alloc] init];
        langModel.name = languageData.name;
        langModel.modelId = languageData.apiServiceCode;
        if ([self.selectedLanguage isEqualToString:langModel.modelId]) {
            langModel.isSelected = YES;
        }
        [filterModelsArray addObject:langModel];
    }
    
    self.languagesFilterView.delegate = self;
    
    self.languagesFilterView.dataSource = filterModelsArray;
    [self.languagesFilterView reloadData];
    [self expandLanguagesFilters:YES];
}

- (void)setupCategoriesView
{
    self.categoriesFilterView.delegate = self;
    self.categoriesFilterView.haveAllSelection = YES;
    self.categoriesFilterView.isMultiSelection = YES;
    
    NSMutableArray <FilterViewModel *>*filterModelsArray = [[NSMutableArray alloc] init];
    
    FilterViewModel *modelAll = [[FilterViewModel alloc] init];
    modelAll.name = @"All";
    if (!self.selectedCategories || self.selectedCategories.count == 0) {
        modelAll.isSelected = YES;
    }
    [filterModelsArray addObject:modelAll];
    
    for (ForumCategoryDataModel *categoryData in self.categoriesDataSource) {
        FilterViewModel *model = [[FilterViewModel alloc] init];
        model.name = categoryData.categoryName;
        model.modelId = categoryData.categoryId;
        if ([self.selectedCategories containsObject:model.modelId]) {
            model.isSelected = YES;
        }
        [filterModelsArray addObject:model];
    }
    
    self.categoriesFilterView.dataSource = filterModelsArray;
    [self.categoriesFilterView reloadData];
    [self expandCategoriesFilters:YES];
}

@end
