//
//  MoreViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SecurityViewController.h"
#import "MyProfileSectionViewModel.h"
#import "UserDataFieldCell.h"
#import "UserDataModel+OtherViewDataSource.h"
#import "SYProfileService.h"
#import "AppDelegate.h"
#import "ApplicationLaunchCoordinator.h"
#import "MaritalStatusDataModel.h"
#import "SYAuthenticationService.h"
#import "ChooseOptionsViewController.h"
#import "VerifyPhoneNumberViewController.h"
#import "SwitchActionTableViewCell.h"
#import "DialogViewController.h"
#import "CreateDualPinViewController.h"

#import "SettingsViewFieldViewModel.h"
#import "MoreViewTableViewCell.h"
#import "RegionalOptionDataModel.h"
#import "ImageDataModel.h"
#import "CountryListViewController.h"
#import "LanguagesListViewController.h"
#import "ChangePinViewController.h"
#import "WebContentViewController.h"

@interface SecurityViewController () <UITableViewDelegate, UITableViewDataSource, TableViewCellActionDelegate, SwitchActionTableViewCellDelegate, DialogViewDelegate, CreateDualPinViewDelegate, MoreViewTableViewCellDelegate, CountryListViewDelegate, LanguagesListViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *cancelEditingBarButtonItem;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;



@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) SYProfileService *profileService;
@property (nonatomic) SYAuthenticationService *userAuthService;
@property (nonatomic) SYAuthenticationService *maritalStatusService;

@property (nonatomic) NSArray *maritalStatusList;

@property (nonatomic) CountryDataModel *currentSelectedCountry;
@property (nonatomic) LanguageDataModel *currentSelectedLanguage;

// Dialog view

@property (nonatomic) DialogViewController *actionDialogView;
@property (nonatomic) DialogViewController *enterPinDialogView;

@end

@implementation SecurityViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileService = [[SYProfileService alloc] init];
        self.userAuthService = [[SYAuthenticationService alloc] init];
        self.dataSource = [[NSMutableArray alloc] init];
        [self configureDataSource];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchMeritalStatusData];
    
    UINib *switchCellNib = [UINib nibWithNibName:@"SwitchActionTableViewCell" bundle:nil];
    [self.tableView registerNib:switchCellNib forCellReuseIdentifier:@"SwitchActionTableViewCell"];
    
    UINib *moreTableViewCellNib = [UINib nibWithNibName:@"MoreViewTableViewCell" bundle:nil];
    [self.tableView registerNib:moreTableViewCellNib forCellReuseIdentifier:@"MoreViewTableViewCell"];
    
    UINib *moreTableViewSwitchCellNib = [UINib nibWithNibName:@"MoreViewTableViewSwitchCell" bundle:nil];
    [self.tableView registerNib:moreTableViewSwitchCellNib forCellReuseIdentifier:@"MoreViewTableViewSwitchCell"];
    
    [self showCancelButton:NO];
    [self.tableView setSeparatorColor:[UIColor mainTintColor3]];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmergencyMessageFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"EmergencyMessageFooterView"];
    self.tableView.estimatedSectionFooterHeight = 20.0;
    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    [self enableKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

#pragma mark - Override

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"title_security_and_login");
    [self refreshUserData:NO];
    [self configureDataSource];
    [self fetchMeritalStatusData];
    [self.tableView reloadData];
}

#pragma mark - DataSource

- (void)configureDataSource
{
    NSMutableArray *dataSourceTemp = [[NSMutableArray alloc] init];
        
    SettingsViewFieldViewModel *dualPinViewModel = [[SettingsViewFieldViewModel alloc] init];
    dualPinViewModel.mainTitle =  LOC(@"dual_pin_title_key");
    dualPinViewModel.iconImageName = @"pin_icon";
    dualPinViewModel.accessoryType = FieldAccessoryTypeArrow;
    dualPinViewModel.actionString = @"showDualPinViewFromSecurityView";
    [dataSourceTemp addObject:dualPinViewModel];
    
    SettingsViewFieldViewModel *camouflageIconViewModel = [[SettingsViewFieldViewModel alloc] init];
    camouflageIconViewModel.mainTitle =  LOC(@"title_camouflage_icon");
    camouflageIconViewModel.iconImageName = @"dual_pin_icon";
    camouflageIconViewModel.accessoryType = FieldAccessoryTypeArrow;
    camouflageIconViewModel.actionString = @"showCamouflageIconFromSecurityView";
    [dataSourceTemp addObject:camouflageIconViewModel];
    
    SettingsViewFieldViewModel *changePasswordField = [[SettingsViewFieldViewModel alloc] init];
    changePasswordField.mainTitle =  LOC(@"change_password_key");
    changePasswordField.iconImageName = @"password_icon";
    changePasswordField.accessoryType = FieldAccessoryTypeArrow;
    changePasswordField.actionString = @"showChangePasswordFromMoreView";
    [dataSourceTemp addObject:changePasswordField];

    
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

#pragma mark - Select Marital Status

- (void)fetchMeritalStatusData
{
    if (self.maritalStatusService == nil) {
        self.maritalStatusService = [[SYAuthenticationService alloc] init];
    }
    [self showLoader];
    weakify(self);
    [self.maritalStatusService getMaritalStatusesWithComplition:^(NSArray * _Nonnull response) {
        strongify(self);
        [self hideLoader];
        self.maritalStatusList = response;
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        NSLog(@"Marital status list error");
    }];
}

#pragma makr - Handle actions

- (void)showCancelButton:(BOOL)show
{
    if (show) {
        self.cancelEditingBarButtonItem.enabled = YES;
        self.cancelEditingBarButtonItem.title = LOC(@"cancel");
    } else {
        self.cancelEditingBarButtonItem.enabled = NO;
        self.cancelEditingBarButtonItem.title = @"";
    }
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
        HyRobotoLabelBold *titleLabel = [[HyRobotoLabelBold alloc] init];
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

- (void)showProfileViewFromMoreView
{
    [self performSegueWithIdentifier:@"showProfileViewFromMoreView" sender:nil];
}

- (void)showChangePasswordFromMoreView
{
    [self performSegueWithIdentifier:@"showChangePasswordFromMoreView" sender:nil];
}

- (void)showSecurityAndLoginView
{
    // show security and login view
}


- (void)showDualPinViewFromSecurityView
{
    // show dual pin view
    
    if ([Settings sharedInstance].isDualPinEnabled) {
        [self showActionDialogView];
    } else {
        [self performSegueWithIdentifier:@"showCreatePinViewFromSecurityView" sender:nil];
    }
}

- (void)showActionDialogView
{
    self.actionDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction];
    self.actionDialogView.delegate = self;
    self.actionDialogView.titleText = LOC(@"edit_deactivate_dual_pin");
    self.actionDialogView.message = LOC(@"enter_pint_to_deactivate");
    self.actionDialogView.keyboardType = UIKeyboardTypeNumberPad;
    self.actionDialogView.correctValue = [Settings sharedInstance].userPin;
    [self addChildViewController:self.actionDialogView onView:self.view];
}

- (void)showEnterPinDialogView
{
    self.enterPinDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeCreatePin];
    self.enterPinDialogView.delegate = self;
    self.enterPinDialogView.titleText = LOC(@"edit_deactivate_dual_pin");
    self.enterPinDialogView.message = LOC(@"enter_pint_to_deactivate");
    self.enterPinDialogView.keyboardType = UIKeyboardTypeNumberPad;
    self.enterPinDialogView.correctValue = [Settings sharedInstance].userPin;
    [self addChildViewController:self.enterPinDialogView onView:self.view];
}

- (void)showCamouflageIconFromSecurityView
{
    // show camouflage icon view
    [self performSegueWithIdentifier:@"ShowChangeApplicationIconViewController" sender:nil];
}

- (void)showTutorialFromMoreView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *introductionVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
    [self.navigationController pushViewController:introductionVC animated:YES];
}


// TODO: Move this to dual pin editing view
#pragma mark - DialogViewDelegate
- (void)dialogViewDidEnterCorrectPin:(DialogViewController *)enterPincodeView
{
    if (enterPincodeView == self.enterPinDialogView) {
        [self performSegueWithIdentifier:@"showCreatePinViewFromSecurityView" sender:nil];
    }
}

- (void)dialogViewDidPressActionButton:(DialogViewController *)enterPincodeView
{
    if (enterPincodeView == self.actionDialogView) {
        [self showEnterPinDialogView];
    }
}

- (void)dialogViewDidCancel:(DialogViewController *)enterPincodeView
{
    // refresh to set switch to old state
    [self.tableView reloadData];
}

#pragma mark - SwitchCellDelegate

- (void)swithActionCell:(SwitchActionTableViewCell *)cell didChangeState:(BOOL)isOn
{
    if (isOn) {
        // show add dual pin functioanlity
        [self showCreatePinView];
        
    } else {
        // show alert with textfield to disable using pin functionality
        [self showPinAlertToDisablePinFunctionality];
    }
}

- (void)shakeAlertView:(UIAlertController *)alertController
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.07];
    [animation setRepeatCount:1];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([alertController.view center].x - 20.0f, [alertController.view center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([alertController.view center].x + 20.0f, [alertController.view center].y)]];
    [[alertController.view layer] addAnimation:animation forKey:@"position"];
}

- (void)showPinAlertToDisablePinFunctionality
{
    DialogViewController *enterPinController = [DialogViewController instansiateDialogViewWithType:DialogViewTypeCreatePin];
    enterPinController.delegate = self;
    enterPinController.titleText = LOC(@"edit_pin_code_title");
    enterPinController.message = LOC(@"enter_pint_to_deactivate");
    enterPinController.keyboardType = UIKeyboardTypeNumberPad;
    enterPinController.correctValue = [Settings sharedInstance].userPin;
    [self addChildViewController:enterPinController onView:self.view];
}

- (void)showPinAlertToEditPinFunctionality
{
    DialogViewController *enterPinController = [DialogViewController instansiateDialogViewWithType:DialogViewTypeEditPin];
    enterPinController.titleText = LOC(@"edit_pin_code_title");
    enterPinController.message = LOC(@"enter_your_pin_code");
    enterPinController.delegate = self;
    enterPinController.keyboardType = UIKeyboardTypeNumberPad;
    enterPinController.correctValue = [Settings sharedInstance].userPin;
    [self addChildViewController:enterPinController onView:self.view];
}

#pragma mark - CreateDualPinViewDelegate

- (void)createPinViewDidCreatePin:(CreateDualPinViewController *)createPinViewController
{
    [[Settings sharedInstance] activateUsingDualPin:YES];
    [self configureDataSource];
    [self.tableView reloadData];
}

- (void)createPinViewDidUpdatePin:(ChangePinViewController *)createPinViewController
{
    // TODO: handle id needed
}

- (void)createPinViewDidCancel:(CreateDualPinViewController *)createPinViewController
{
    // TODO: handle if needed
}

#pragma mark - Create/UpdtaePin

- (void)showCreatePinView
{
    [self performSegueWithIdentifier:@"showCreatePinViewFromMoreView" sender:nil];

}

- (void)editDualPin
{
    [self showPinAlertToEditPinFunctionality];
}

#pragma mark - Edit cell delegate

- (void)showVerifyPhoneFlow:(NSString *)newPhoneNumber
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    VerifyPhoneNumberViewController *verifyVC = [storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneNumberViewController"];
    verifyVC.isFromEditPhoneNumber = YES;
    verifyVC.phoneNumber = newPhoneNumber;
    [self presentViewController:verifyVC animated:YES completion:nil];
}

- (void)refreshUserData:(BOOL)withLoader
{
    weakify(self);
    [self.profileService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        [self configureDataSource];
        if (withLoader) {
            [self hideLoader];
        }
    } failure:^(NSError *error) {
        strongify(self);
        NSLog(@"Error");
        if (withLoader) {
            [self hideLoader];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
//    MyProfileSectionViewModel *sectionData = self.dataSource[section];
//    return sectionData.sectionDataSource.count;
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
    cell.delegate = self;
    
    [cell configureWithViewData:rowData];
    return cell;
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

- (void)doneEditing
{
    [self.tableView resignFirstResponder];
    [self.cancelEditingBarButtonItem setTitle:@""];
    self.cancelEditingBarButtonItem.enabled = NO;
    [self configureDataSource];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self doneEditing];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showChangePinViewFromSecurityView"]) {
        ChangePinViewController *changePinVC = segue.destinationViewController;
        changePinVC.isUpdating = YES;
        changePinVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"showCreatePinViewFromSecurityView"]) {
        CreateDualPinViewController *changePinVC = segue.destinationViewController;
        if ([Settings sharedInstance].isDualPinEnabled) {
            changePinVC.pinSwitchTitle = LOC(@"edit_deactivate_dual_pin");
        } else {
            changePinVC.pinSwitchTitle = LOC(@"add_dual_pin_title_key");
        }
    }
    
    if ([segue.identifier isEqualToString:@"showAboutUsView"]) {
        WebContentViewController *destination = segue.destinationViewController;
        destination.contentType = SYRemotContentTypeAboutUs;
    }
}


@end
