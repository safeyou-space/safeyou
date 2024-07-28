//
//  MoreViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MoreViewController.h"
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
#import "IntroductionViewController.h"
#import "UserConsultantRequestDataModel.h"
#import <UserNotifications/UserNotifications.h>

@interface MoreViewController () <UITableViewDelegate, UITableViewDataSource, TableViewCellActionDelegate, SwitchActionTableViewCellDelegate, DialogViewDelegate, CreateDualPinViewDelegate, MoreViewTableViewCellDelegate, CountryListViewDelegate, LanguagesListViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *cancelEditingBarButtonItem;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) SYProfileService *profileService;
@property (nonatomic) SYAuthenticationService *userAuthService;
@property (nonatomic) SYAuthenticationService *maritalStatusService;
@property (nonatomic) SYProfileService *profileDataService;
@property (nonatomic) BOOL currentNotificationState;

@property (nonatomic) NSArray *maritalStatusList;

@property (nonatomic) CountryDataModel *currentSelectedCountry;
@property (nonatomic) LanguageDataModel *currentSelectedLanguage;

@property (nonatomic) DialogViewController *deleteAccountDialogView;

@end

@implementation MoreViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self notificationState];
        self.profileService = [[SYProfileService alloc] init];
        self.userAuthService = [[SYAuthenticationService alloc] init];
        self.profileDataService = [[SYProfileService alloc] init];
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
    [self configureOpenSurveyActionDialog];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor1];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.tableView reloadData];
}

#pragma mark - Override

- (void)updateLocalizations
{
    [self refreshUserData:NO];
    [self configureDataSource];
    [self fetchMeritalStatusData];
    [self.tableView reloadData];
    self.navigationItem.title = LOC(@"title_menu");
    self.title = LOC(@"title_menu");
}

#pragma mark - DataSource

- (void)configureDataSource
{
    NSMutableArray *dataSourceTemp = [[NSMutableArray alloc] init];
    
    SettingsViewFieldViewModel *profileField = [[SettingsViewFieldViewModel alloc] init];
    profileField.mainTitle = LOC(@"profile_title_key");
    profileField.actionString = @"showProfileViewFromMoreView";
    profileField.iconImageName = @"profile_icon";
    profileField.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:profileField];
    
    SettingsViewFieldViewModel *becomeConsultantField = [[SettingsViewFieldViewModel alloc] init];
    
    becomeConsultantField.mainTitle = LOC(@"become_consultant_title");
    becomeConsultantField.secondaryTitle = @"";
    
    if ([Settings sharedInstance].onlineUser.currentConsultantRequest) {
        // handle consultant texts or consultant request pending
        ConsultantRequestStatus requestStatus = [Settings sharedInstance].onlineUser.currentConsultantRequest.requestStatus;
        if (requestStatus == ConsultantRequestStatusPending) {
            becomeConsultantField.mainTitle = LOC(@"pending");
            becomeConsultantField.secondaryTitle = LOC(@"become_consultant_title");
        } else if (requestStatus == ConsultantRequestStatusConfirmed) {
            becomeConsultantField.mainTitle = LOC(@"approved");
            becomeConsultantField.secondaryTitle = LOC(@"become_consultant_title");
            
        } else if (requestStatus == ConsultantRequestStatusDeclined) {
            becomeConsultantField.mainTitle = LOC(@"declined");
            becomeConsultantField.secondaryTitle = LOC(@"become_consultant_title");
        }
    }
    
    becomeConsultantField.iconImageName = @"consultant_icon";
    becomeConsultantField.actionString = @"showBecomeConsultantFromMoreView";
    becomeConsultantField.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:becomeConsultantField];
    
    //icon_security
    SettingsViewFieldViewModel *emergencyContactsField = [[SettingsViewFieldViewModel alloc] init];
    emergencyContactsField.mainTitle =  LOC(@"emergency_contacts_title_key");
    emergencyContactsField.iconImageName = @"intro_contacts_icon";
    emergencyContactsField.accessoryType = FieldAccessoryTypeArrow;
    emergencyContactsField.actionString = @"showEmergencyContactsView";
    [dataSourceTemp addObject:emergencyContactsField];
    
    //icon-survay
    SettingsViewFieldViewModel *openSurvaysField = [[SettingsViewFieldViewModel alloc] init];
    openSurvaysField.mainTitle =  LOC(@"open_surveys_key");
    openSurvaysField.iconImageName = @"icon-survay";
    openSurvaysField.accessoryType = FieldAccessoryTypeArrow;
    openSurvaysField.actionString = @"showOpenSurvaysView";
    [dataSourceTemp addObject:openSurvaysField];
    
    //icon_notification
    SettingsViewFieldViewModel *notificationField = [[SettingsViewFieldViewModel alloc] init];
    notificationField.mainTitle = LOC(@"notifications_title_key");
    notificationField.iconImageName = @"notification_icon_fill";
    notificationField.actionString = @"notifications";
    notificationField.accessoryType = FieldAccessoryTypeSwitch;
    notificationField.isStateOn = _currentNotificationState;
    [dataSourceTemp addObject:notificationField];
    
    //icon_security
    SettingsViewFieldViewModel *recordingsField = [[SettingsViewFieldViewModel alloc] init];
    recordingsField.mainTitle =  LOC(@"recording_title_key");
    recordingsField.iconImageName = @"recordings";
    recordingsField.accessoryType = FieldAccessoryTypeArrow;
    recordingsField.actionString = @"showRecordingsView";
    [dataSourceTemp addObject:recordingsField];
    
    //icon_security
    SettingsViewFieldViewModel *changePasswordField = [[SettingsViewFieldViewModel alloc] init];
    changePasswordField.mainTitle =  LOC(@"title_security_and_login");
    changePasswordField.iconImageName = @"icon_security";
    changePasswordField.accessoryType = FieldAccessoryTypeArrow;
    changePasswordField.actionString = @"showSecurityAndLoginView";
    [dataSourceTemp addObject:changePasswordField];
    
    SettingsViewFieldViewModel *countryField = [[SettingsViewFieldViewModel alloc] init];
    countryField.secondaryTitle = LOC(@"country_title_key");
    countryField.mainTitle = [Settings sharedInstance].selectedCountry.name;
    countryField.isIconImageFromURL = YES;
    countryField.iconImageUrl = [NSString stringWithFormat:@"%@/%@", BASE_RESOURCE_URL, [Settings sharedInstance].selectedCountry.imageData.url];
    countryField.actionString = @"showChooseCountryFromMoreView";
    countryField.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:countryField];
    
    SettingsViewFieldViewModel *languageField = [[SettingsViewFieldViewModel alloc] init];
    languageField.secondaryTitle = LOC(@"language_title_key");
    languageField.iconImageName = @"globe_icon";
    languageField.mainTitle = [Settings sharedInstance].selectedLanguage.name;
    languageField.actionString = @"showChooseLanguageFromMoreView:";
    languageField.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:languageField];
        
    SettingsViewFieldViewModel *tutorialViewModel = [[SettingsViewFieldViewModel alloc] init];
    tutorialViewModel.mainTitle = LOC(@"title_tutorial");
    tutorialViewModel.iconImageName = @"icon-tutorial";
    tutorialViewModel.actionString = @"showTutorialFromMoreView";
    tutorialViewModel.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:tutorialViewModel];
    
    //
    
    SettingsViewFieldViewModel *legalViewModel = [[SettingsViewFieldViewModel alloc] init];
    legalViewModel.mainTitle = LOC(@"title_legal");
    legalViewModel.iconImageName = @"legal_icon";
    legalViewModel.actionString = @"showLegalViewFromMoreView";
    legalViewModel.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:legalViewModel];
    
    SettingsViewFieldViewModel *aboutUsViewModel = [[SettingsViewFieldViewModel alloc] init];
    aboutUsViewModel.mainTitle = LOC(@"about_us_title_key");
    aboutUsViewModel.iconImageName = @"about_icon";
    aboutUsViewModel.actionString = @"showAboutUsFromMoreView";
    aboutUsViewModel.accessoryType = FieldAccessoryTypeArrow;
    [dataSourceTemp addObject:aboutUsViewModel];
    
    SettingsViewFieldViewModel *logoutField = [[SettingsViewFieldViewModel alloc] init];
    logoutField.mainTitle = LOC(@"log_out_title_key");
    logoutField.iconImageName = @"logout_icon";
    logoutField.actionString = @"logout";
    logoutField.accessoryType = FieldAccessoryTypeUnknown;
    [dataSourceTemp addObject:logoutField];

    SettingsViewFieldViewModel *deleteAccountField = [[SettingsViewFieldViewModel alloc] init];
    deleteAccountField.mainTitle = LOC(@"delete_account_title_key");
    deleteAccountField.iconImageName = @"delete_recycle_icon";
    deleteAccountField.actionString = @"deleteAccountAction";
    deleteAccountField.accessoryType = FieldAccessoryTypeUnknown;
    [dataSourceTemp addObject:deleteAccountField];
    
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
    [self performSegueWithIdentifier:@"showSecurityViewFromMoreView" sender:nil];
}

- (void)showBecomeConsultantFromMoreView
{
    [self performSegueWithIdentifier:@"showBecomeConsultantView" sender:nil];
}

- (void)showEmergencyContactsView
{
    [self performSegueWithIdentifier:@"showEmergencyContactsView" sender:nil];
}

- (void)showOpenSurvaysView
{
    [self performSegueWithIdentifier:OPEN_SURVEY_STORYBOARD_SEGUE sender:nil];
}

- (void)showRecordingsView
{
    [self performSegueWithIdentifier:@"showRecordingsView" sender:nil];
}

- (void)showChooseCountryFromMoreView
{
    CountryListViewController *countryListVC = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" bundle:nil];
    countryListVC.delegate = self;
    [self.navigationController pushViewController:countryListVC animated:YES];
}

- (void)showChooseLanguageFromMoreView:(BOOL)isFromCountryView
{
    LanguagesListViewController *languagesVC = [[LanguagesListViewController alloc] initWithNibName:@"LanguagesListViewController" bundle:nil];
    languagesVC.isFromChooseCountry = isFromCountryView;
    if (isFromCountryView) {
        languagesVC.currentSelectedCountry = self.currentSelectedCountry;
    }
    languagesVC.delegate = self;
    [self.navigationController pushViewController:languagesVC animated:YES];
}

- (void)showAboutUsFromMoreView
{
    [self performSegueWithIdentifier:@"showAboutUsView" sender:nil];
}

- (void)showTutorialFromMoreView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Introduction" bundle:nil];
    IntroductionViewController *introductionVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
    introductionVC.isFromMenu = YES;
    [self.navigationController pushViewController:introductionVC animated:YES];
}

- (void)showLegalViewFromMoreView
{
    [self performSegueWithIdentifier:@"showLegalView" sender:nil];
}

- (void)logout
{
    weakify(self)
    [self showAlertViewWithTitle:@"" withMessage:LOC(@"want_logout_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:LOC(@"log_out_title_key") cancelAction:^{
        // cancel action
    } okAction:^{
        strongify(self)
        [self.userAuthService logoutUserWithComplition:^(id  _Nonnull response) {
            [Settings sharedInstance].isPopupShown = NO;
            [[Settings sharedInstance] resetUserData];
            [ApplicationLaunchCoordinator showWelcomeScreenAfterLogout];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Logout error");
            [ApplicationLaunchCoordinator showWelcomeScreenAfterLogout];
        }];
    }];
}

- (void)notifications
{
    
}

- (void)showRegionalOptionsDialogAndLogout
{
    weakify(self)
    if (![self.currentSelectedCountry.apiServiceCode isEqualToString:[Settings sharedInstance].selectedCountryCode]) {
        [self showAlertViewWithTitle:@"" withMessage:LOC(@"confirm_change_country") cancelButtonTitle:LOC(@"cancel") okButtonTitle:LOC(@"apply_title_key") cancelAction:^{
            // cancel action
            self.currentSelectedCountry = nil;
            self.currentSelectedLanguage = nil;
        } okAction:^{
            strongify(self)
            [self.userAuthService logoutUserWithComplition:^(id  _Nonnull response) {
                [Settings sharedInstance].selectedCountry = self.currentSelectedCountry;
                [Settings sharedInstance].selectedLanguage = self.currentSelectedLanguage;
                [Settings sharedInstance].isPopupShown = NO;
                [[Settings sharedInstance] resetUserData];
                [ApplicationLaunchCoordinator showWelcomeScreenAfterLogout];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"Logout error");
            }];
        }];
    } else if (![self.currentSelectedLanguage.apiServiceCode isEqualToString:[Settings sharedInstance].selectedLanguageCode]) {
        self.currentSelectedCountry = nil;
        self.currentSelectedLanguage = nil;
        [Settings sharedInstance].selectedLanguage = self.currentSelectedLanguage;
    } else {
        self.currentSelectedCountry = nil;
        self.currentSelectedLanguage = nil;
    }
}

- (void)deleteAccountAction
{
    self.deleteAccountDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction title:LOC(@"delete_account_title") message:LOC(@"delete_account_description")];
    self.deleteAccountDialogView.showCancelButton = YES;
    self.deleteAccountDialogView.delegate = self;
    self.deleteAccountDialogView.continueButtonText = LOC(@"delete_key");
    [self addChildViewController:self.deleteAccountDialogView onView:self.view];
}

#pragma mark - Helper

- (ProfileViewFieldViewModel *)fieldForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *fieldsArray = [[Settings sharedInstance].onlineUser othersViewDataSource];
        ProfileViewFieldViewModel *selectedField = fieldsArray[indexPath.row];
        return selectedField;
    }
    return nil;
}

#pragma mark - ReEnterPinCodeViewDelegate

- (void)dialogViewDidEnterCorrectPin:(DialogViewController *)enterPincodeView
{
    // disable pin code fucntionality
    if (enterPincodeView.actionType == DialogViewTypeCreatePin) {
        [[Settings sharedInstance] activateUsingDualPin:NO];
        [self configureDataSource];
        [self.tableView reloadData];
    }
    
    if (enterPincodeView.actionType == DialogViewTypeEditPin) {
        [self performSegueWithIdentifier:@"showEditPinViewFromMoreView" sender:nil];
    }
}

- (void)dialogViewDidCancel:(DialogViewController *)enterPincodeView
{
    // refresh to set switch to old state
    [self.tableView reloadData];
}

- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView
{
    if (dialogView == self.deleteAccountDialogView) {
        [self showLoader];
        weakify(self);
        [self.profileService deleteProfile:^(id response) {
            strongify(self);
            [self hideLoader];
            [Settings sharedInstance].isPopupShown = NO;
            [[Settings sharedInstance] resetUserData];
            [ApplicationLaunchCoordinator showWelcomeScreenAfterLogout];
        } failure:^(NSError *error) {
            strongify(self);
            [self hideLoader];
            NSLog(@"Error on delete profile %@", error);
        }];
    } else if (dialogView.actionType == DialogViewTypeSurveyAction) {
        [self performSegueWithIdentifier:OPEN_SURVEY_STORYBOARD_SEGUE sender:nil];
    }
}

#pragma mark - SwitchCellDelegate

- (void)swithActionCell:(SwitchActionTableViewCell *)cell didChangeState:(BOOL)isOn
{
    if (isOn) {
        self.currentNotificationState = YES;
        NSString *valueToSave = @"enabled";
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"notificationState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self saveFcmToken:[Settings sharedInstance].updatedFcmToken];

    } else {
        self.currentNotificationState = NO;
        NSString *valueToSave = @"disabled";
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"notificationState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self saveFcmToken:@""];
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

- (void)createPinViewDidUpdatePin:(CreateDualPinViewController *)createPinViewController
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

#pragma mark - CountryListViewDelegate

- (void)countryOptionsView:(CountryListViewController *)regionalOptionsView didSelectedOption:(CountryDataModel *)selectedCountryData
{
    self.currentSelectedCountry = selectedCountryData;
    [self showChooseLanguageFromMoreView:YES];
}

#pragma mark - LanguagesListViewDelegate

- (void)languagesOptionView:(LanguagesListViewController *_Nonnull)regionalOptionsView didSelectedOption:(LanguageDataModel *_Nonnull)selectedRegionalOption
{
    if (regionalOptionsView.isFromChooseCountry) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.currentSelectedLanguage = selectedRegionalOption;
        [self showRegionalOptionsDialogAndLogout];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[Settings sharedInstance] setSelectedLanguage:selectedRegionalOption];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showEditPinViewFromMoreView"]) {
        ChangePinViewController *changePinVC = segue.destinationViewController;
        changePinVC.isUpdating = YES;
        changePinVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"showCreatePinViewFromMoreView"]) {
        ChangePinViewController *changePinVC = segue.destinationViewController;
        changePinVC.isUpdating = NO;
        changePinVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"showAboutUsView"]) {
        WebContentViewController *destination = segue.destinationViewController;
        destination.title = LOC(@"about_us_title_key");
        destination.contentType = SYRemotContentTypeAboutUs;
    }
}
- (void)notificationState
{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"notificationState"]  isEqual: @"enabled"]) {
        self.currentNotificationState = YES;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"notificationState"]  isEqual: @"disabled"]) {
        self.currentNotificationState = NO;
    } else  {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                self.currentNotificationState = YES;
                NSString *valueToSave = @"enabled";
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"notificationState"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                self.currentNotificationState = NO;
                NSString *valueToSave = @"disabled";
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"notificationState"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}

- (void)saveFcmToken:(NSString *)deviceToken
{
    NSLog(@"%@", [Settings sharedInstance].updatedFcmToken);
    [self.profileDataService updateUserDataField:@"device_token" value:deviceToken withComplition:^(id response) {
        [Settings sharedInstance].savedFcmToken = [Settings sharedInstance].updatedFcmToken;
        [Settings sharedInstance].updatedFcmToken = nil;
    } failure:^(NSError *error) {
    }];
}

#pragma mark - Confirm Survay Action Dialog

- (void)configureOpenSurveyActionDialog
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_OPEN_SURVEY_NOTIFICATION_SHOWN] && ![Settings sharedInstance].isOpenSurveyPopupShown) {
        [[Settings sharedInstance] setOpenSurveyPopupShown:YES];
        DialogViewController *surveyActionDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeSurveyAction title:LOC(@"survey_notification_popup_title") message:LOC(@"survey_notification_popup_description")];
        surveyActionDialogView.delegate = self;
        surveyActionDialogView.showCancelButton = YES;
        surveyActionDialogView.continueButtonText = LOC(@"take_survey_key");
        [self addChildViewController:surveyActionDialogView onView:self.view];
    }
}

@end
