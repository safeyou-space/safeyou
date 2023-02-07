//
//  ChooseRegionalOptionsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseRegionalOptionsViewController.h"
#import "ChooseItemView.h"
#import "UIButton+ArrangeImage.h"
#import "ChooseRegionalOptionViewModel.h"
#import "RegionalOptionsService.h"

@interface ChooseRegionalOptionsViewController () 

@property (weak, nonatomic) IBOutlet UIStackView *optionsStackView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *mainTitleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *secondaryTitleLabel;
@property (weak, nonatomic) IBOutlet SYCorneredButton *nextButton;

- (IBAction)nextButtonPressed:(UIButton *)sender;
- (IBAction)rightBarButtonPressed:(UIBarButtonItem *)sender;

@property (nonatomic) NSArray *allRadioButtons;


@end

@implementation ChooseRegionalOptionsViewController

@synthesize rightBarButtonItem = _rightBarButtonItem;
@synthesize optionsService = _optionsService;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optionsService = [[RegionalOptionsService alloc] init];
    [self fetchOptions];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
    [self configureGradientBackground];
    [self configureOptionsView];
    [self.nextButton arrangeImageToTheRight];
    [self configureRightBarButtonitem];
}

#pragma mark - Interface Methods

- (void)fetchOptions
{
    NSAssert(NO, @"Override method in child classes");
}

- (void)showNextView
{
    NSAssert(NO, @"Override method in child classes");
}

#pragma mark - Bar Button Items

- (void)configureRightBarButtonitem
{
    _rightBarButtonItem = [[SYDesignableBarButtonItem alloc] initWithTitle:LOC(@"next_key") style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed:)];
    _rightBarButtonItem.tintColorType = 9;
    [_rightBarButtonItem setTitle:LOC(@"next_key")];
    self.navigationItem.rightBarButtonItems = @[_rightBarButtonItem];
}

#pragma mark - Setter

- (void)setDataSource:(NSArray<ChooseRegionalOptionViewModel *> *)dataSource
{
    _dataSource = dataSource;
    [self configureOptionsView];
}

- (void)setMainTitle:(NSString *)mainTitle
{
    self.mainTitleLabel.text = mainTitle;
}

- (void)setSecondaryTitle:(NSString *)secondaryTitle
{
    self.secondaryTitleLabel.text = secondaryTitle;
}

- (void)setRightBarButtonTitle:(NSString *)rightBarButtonTitle
{
    self.rightBarButtonItem.title = rightBarButtonTitle;
}

- (void)setSubmitButtonTitle:(NSString *)submitButtonTitle
{
    [self.nextButton setTitle:submitButtonTitle forState:UIControlStateNormal];
}

#pragma mark - DataSource

- (void)cleanStackView
{
    for (UIView *subView in self.optionsStackView.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)configureOptionsView
{
    [self cleanStackView];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (ChooseRegionalOptionViewModel *viewData in self.dataSource) {
        ChooseItemView *itemView = [[ChooseItemView alloc] initWithViewData:viewData];
        if ([self.dataSource indexOfObject:viewData] == 0) {
            itemView.selected = YES;
            self.selectedRegionalOption = itemView.viewData.regionalOptionData;
        }
        itemView.delegate = self;
        [self.optionsStackView addArrangedSubview:itemView];
        [itemView.heightAnchor constraintEqualToConstant:50].active = true;
        [tempArray addObject:itemView];
    }
    
    self.allRadioButtons = [tempArray copy];
}

- (void)deselectAllItemsInsteradOf:(ChooseItemView *)selectedItem
{
    for (ChooseItemView *chooseItemView in self.allRadioButtons) {
        if (chooseItemView != selectedItem) {
            chooseItemView.selected = NO;
        }
    }
}

#pragma mark - ChooseItemViewDelegate
- (void)chooseItemDidPressSelect:(ChooseItemView *)chooseItemView
{
    self.selectedRegionalOption = chooseItemView.viewData.regionalOptionData;
    [self deselectAllItemsInsteradOf:chooseItemView];
}

#pragma mark - Translations

- (void)updateLocalizations
{
    
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithSYColor:SYColorTypeMain1 alpha:1.0]];
    
}

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground {
    self.view.backgroundColor = [UIColor mainTintColor2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self showNextView];
}

- (IBAction)rightBarButtonPressed:(UIBarButtonItem *)sender {
    [self showNextView];
}
@end
