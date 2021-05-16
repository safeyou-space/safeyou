//
//  ChangeApplicationIconViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 12/9/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChangeApplicationIconViewController.h"
#import "ChooseIconCellViewModel.h"
#import "SettingsViewFieldViewModel.h"
#import "MoreViewTableViewCell.h"
#import "AppIconTableViewCell.h"
#import "DialogViewController.h"
#import "CreateDualPinViewController.h"

@interface ChangeApplicationIconViewController () <MoreViewTableViewCellDelegate, DialogViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *saveButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;
- (IBAction)saveButtonAction:(SYDesignableButton *)sender;
- (IBAction)cancelButtonAction:(SYDesignableButton *)sender;

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) BOOL isSwitchEnabled;
@property (nonatomic) ChooseIconCellViewModel *selectedIconData;
@property (nonatomic) DialogViewController *activatePinDialogView;

@end

@implementation ChangeApplicationIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UINib *optionCellNib = [UINib nibWithNibName:@"AppIconTableViewCell" bundle:nil];
    [self.tableView registerNib:optionCellNib forCellReuseIdentifier:@"AppIconTableViewCell"];
    
    UINib *moreTableViewSwitchCellNib = [UINib nibWithNibName:@"MoreViewTableViewSwitchCell" bundle:nil];
    [self.tableView registerNib:moreTableViewSwitchCellNib forCellReuseIdentifier:@"MoreViewTableViewSwitchCell"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.isSwitchEnabled = [Settings sharedInstance].isCamouflageIconEnabled;
    
    [self configureIconsDataSource];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"title_camouflage_icon");
    [self.saveButton setTitle:[LOC(@"save_key") uppercaseString] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[LOC(@"cancel") uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - Fetch Country Options

- (void)configureIconsDataSource
{
    SettingsViewFieldViewModel *enableCamouflageIconField = [[SettingsViewFieldViewModel alloc] init];
    enableCamouflageIconField.mainTitle = LOC(@"choose_your_camouflage_icon");
    enableCamouflageIconField.iconImageName = @"dual_pin_icon";
    enableCamouflageIconField.accessoryType = FieldAccessoryTypeSwitch;
    enableCamouflageIconField.isStateOn = self.isSwitchEnabled;
    
    ChooseIconCellViewModel *icon1 = [[ChooseIconCellViewModel alloc] initWithTitle:LOC(@"art_gallery") imageName:@"AppIconAlternate1"];
    if ([[Settings sharedInstance].camouflageIconName isEqualToString:icon1.iconImageName]) {
        self.selectedIconData = icon1;
    }
    ChooseIconCellViewModel *icon2 = [[ChooseIconCellViewModel alloc] initWithTitle:LOC(@"gallery_editor") imageName:@"AppIconAlternate2"];
    if ([[Settings sharedInstance].camouflageIconName isEqualToString:icon2.iconImageName]) {
        self.selectedIconData = icon2;
    }
    ChooseIconCellViewModel *icon3 = [[ChooseIconCellViewModel alloc] initWithTitle:LOC(@"visual_editor") imageName:@"AppIconAlternate3"];
    if ([[Settings sharedInstance].camouflageIconName isEqualToString:icon3.iconImageName]) {
        self.selectedIconData = icon3;
    }
    self.dataSource = @[enableCamouflageIconField, icon1, icon2, icon3];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        ChooseIconCellViewModel *selectedIcon = self.dataSource[indexPath.row];
        self.selectedIconData = selectedIcon;
    }
}

- (void)setSelectedIconData:(ChooseIconCellViewModel *)selectedIconData
{
    _selectedIconData = selectedIconData;
    [self deselectAllOptions];
    //        ChooseIconCellViewModel *selectedViewData = [self viewDataForOption:self.selectedRegionalOption];
    _selectedIconData.isSelected = YES;
    [self.tableView reloadData];
}

- (void)deselectAllOptions
{
    for (ChooseIconCellViewModel *viewData in self.dataSource) {
        if ([viewData isKindOfClass:[ChooseIconCellViewModel class]]) {
            viewData.isSelected = NO;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id currentItem = self.dataSource[indexPath.row];
    if ([currentItem isKindOfClass:[SettingsViewFieldViewModel class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MoreViewTableViewSwitchCell"];
        ((MoreViewTableViewCell *)cell).delegate = self;
        
        [((MoreViewTableViewCell *)cell) configureWithViewData:currentItem];
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AppIconTableViewCell"];
        cell.userInteractionEnabled = self.isSwitchEnabled;
        [((AppIconTableViewCell *)cell) configureWithViewData:currentItem];
        return cell;
    }
}

- (void)swithActionCell:(MoreViewTableViewCell *_Nonnull)cell didChangeState:(BOOL)isOn
{
    SettingsViewFieldViewModel *switchField = self.dataSource.firstObject;
    switchField.isStateOn = isOn;
    self.isSwitchEnabled = isOn;
    [self.tableView reloadData];
}

#pragma mark - Suggest ActivatePin

- (void)showActivatePinDialog
{
    self.activatePinDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction];
    self.activatePinDialogView.showCancelButton = YES;
    self.activatePinDialogView.delegate = self;
    self.activatePinDialogView.titleText = LOC(@"would_you_activate_dual_pin");
    self.activatePinDialogView.message = LOC(@"we_recommend_to_activate_dual_pin");
    [self addChildViewController:self.activatePinDialogView onView:self.view];
}

#pragma mark - DialogViewDelegate

- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView
{
    if (dialogView == self.activatePinDialogView) {
        UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
        CreateDualPinViewController *pinVC = [authStoryboard instantiateViewControllerWithIdentifier:@"CreateDualPinViewController"];
        [self.navigationController pushViewController:pinVC animated:YES];
    }
}

- (void)dialogViewDidCancel:(DialogViewController *)dialogView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions
- (IBAction)saveButtonAction:(SYCorneredButton *)sender {
    if (self.isSwitchEnabled) {
        if (self.selectedIconData) {
            [[Settings sharedInstance] activateUsingCamouflageIcon:YES iconName:self.selectedIconData.iconImageName];
            NSString *iconName = self.selectedIconData.iconImageName;
            if ([UIApplication sharedApplication].supportsAlternateIcons) {
                [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@"Done");
                        if (![Settings sharedInstance].isDualPinEnabled) {
                            [self showActivatePinDialog];
                        } else {
                            UIViewController *destination = self.navigationController.viewControllers[1];
                            [self.navigationController popToViewController:destination animated:YES];
                        }
                    }
                }];
            }
        }
    } else {
        if ([Settings sharedInstance].isCamouflageIconEnabled) {
            [[Settings sharedInstance] activateUsingCamouflageIcon:NO iconName:nil];
        }
        if ([UIApplication sharedApplication].supportsAlternateIcons) {
            [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    UIViewController *destination = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:destination animated:YES];
                }
            }];
        }
    }
}

- (IBAction)cancelButtonAction:(SYCorneredButton *)sender {
    UIViewController *destination = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:destination animated:YES];
}
@end
