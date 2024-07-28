//
//  EmergencyContactsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/3/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "EmergencyContactsViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "MyProfileSectionViewModel.h"
#import "UserDataModels.h"
#import "MyProfileActionTableViewCell.h"
#import "SwitchActionTableViewCell.h"
#import "MyProfileNavigationTableViewCell.h"
#import "Settings.h"
#import "EmergencyMessageFooterView.h"
#import "AvatarTitleView.h"
#import "SDWebImageManager.h"
#import "SYAuthenticationService.h"
#import "SYProfileService.h"
#import "ApplicationLaunchCoordinator.h"
#import "NetworkListViewController.h"
#import "EmergencyServiceDataModel.h"
#import "WebContentViewController.h"
#import "EmergencyContactTableViewCell.h"
#import "SectionHeaderWithTitleImage.h"
#import "EmergencyMessageTableViewCell.h"
#import "Settings.h"
#import "DialogViewController.h"
#import "MainTabbarController.h"

NSString *const __addEmergnecyContactSelector = @"addEmergencyContact:";
NSString *const __updateEmergnecyContactSelector = @"updateEmergencyContact:";
NSString *const __showSelectServiceSelector = @"showSelectEmergencyService:";

@interface EmergencyContactsViewController () <UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, UITextViewDelegate, EmergencyMessageViewDelegate, MyProfileCellDelegate, NetworkListViewDelegate, TableViewCellActionDelegate, DialogViewDelegate>

@property (nonatomic) CNContactViewController *contactViewController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray <MyProfileSectionViewModel *>*dataSource;

@property (nonatomic) UserDataModel *onlineUser;

@property (nonatomic, weak) UITextView *emergencyTextView;

@property (nonatomic) SYAuthenticationService *userAuthService;

@property (nonatomic) SYProfileService *userProfileService;

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) NSString *updatingEmergencyContactId;

@property (nonatomic) DialogViewController *activateCamouflageIconDialogView;

@property (nonatomic) MyProfileRowViewModel *policeViewModel;

@end

@implementation EmergencyContactsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userProfileService = [[SYProfileService alloc] init];
        self.userAuthService = [[SYAuthenticationService alloc] init];
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    [self enableKeyboardNotifications];
    [self.tableView setSeparatorColor:[UIColor mainTintColor3]];
    self.tableView.estimatedSectionFooterHeight = 20.0;
    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    [self configureNavigationBar];
}

- (void)configureTitleView
{
    AvatarTitleView *titleView = [AvatarTitleView createAvatarTitleView];
    
    titleView.title = self.onlineUser.nickname;
    ImageDataModel *userImageMode = self.onlineUser.image;
    NSString *imageUrlString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, userImageMode.url];
    
    titleView.imageUrl = [NSURL URLWithString:imageUrlString];
    
    self.navigationItem.titleView = titleView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainTabbarController] hideTabbar:YES];
    [self configureDataSource];
}

#pragma mark - Register Nibs

- (void)configureTableView
{
    UINib *emergencyContactCellNib = [UINib nibWithNibName:@"EmergencyContactTableViewCell" bundle:nil];
    [self.tableView registerNib:emergencyContactCellNib forCellReuseIdentifier:@"EmergencyContactTableViewCell"];
    UINib *emergnecyTitleHeaderNib = [UINib nibWithNibName:@"SectionHeaderWithTitleImage" bundle:nil];
    [self.tableView registerNib:emergnecyTitleHeaderNib forHeaderFooterViewReuseIdentifier:@"SectionHeaderWithTitleImage"];
    UINib *emergnecyMessageCellNib = [UINib nibWithNibName:@"EmergencyMessageTableViewCell" bundle:nil];
    [self.tableView registerNib:emergnecyMessageCellNib forCellReuseIdentifier:@"EmergencyMessageTableViewCell"];
    
    UINib *switchCellNib = [UINib nibWithNibName:@"SwitchActionTableViewCell" bundle:nil];
    [self.tableView registerNib:switchCellNib forCellReuseIdentifier:@"SwitchActionTableViewCell"];
    
    UINib *emergnecyDividerLineNib = [UINib nibWithNibName:@"SectionDividerLine" bundle:nil];
    [self.tableView registerNib:emergnecyDividerLineNib forHeaderFooterViewReuseIdentifier:@"SectionDividerLine"];
}

#pragma mark - Getter

- (UserDataModel *)onlineUser
{
    return [Settings sharedInstance].onlineUser;
}

#pragma mark - Override

- (void)updateLocalizations
{
    self.title = LOC(@"support_title_key");
}

#pragma mark - DataSource

- (void)configureDataSource
{
    // @TODO: Implement functionality to take viewmodel data from Online user data
    
    UserDataModel *onlineUser = [Settings sharedInstance].onlineUser;
    NSMutableArray *sectionOneDatasource = [[NSMutableArray alloc] init];
    
    NSInteger contactsCellsCount = 3;
    
    for (int i = 0 ; i < contactsCellsCount; ++i) {
        MyProfileRowViewModel *contactViewModel;
        EmergencyContactDataModel *userContact;
        if (onlineUser.emergencyContacts.count > i) {
            userContact = onlineUser.emergencyContacts[i];
        }
        
        NSString *title;
        NSString *valueText;
        NSString *actionString = __addEmergnecyContactSelector;
        BOOL showClearButton = NO;
        if (userContact) {
            title = [self contactTitleForIndex:i];
            actionString = __updateEmergnecyContactSelector;
            showClearButton = YES;
            valueText = userContact.name;
            
        } else {
            showClearButton = NO;
            title = [self contactTitleForIndex:i];
        }
        
        contactViewModel = [[MyProfileRowViewModel alloc] initWithTitle:title rowType:MyProfileRowTypeAction];
        contactViewModel.dataModel = userContact;
        contactViewModel.actionString = actionString;
        contactViewModel.showClearButton = showClearButton;
        contactViewModel.showEditButton = YES;
        contactViewModel.fieldValue = valueText;
        [sectionOneDatasource addObject:contactViewModel];
    }
    
    MyProfileSectionViewModel *sectionOneData = [[MyProfileSectionViewModel alloc] initWithRows:sectionOneDatasource];
    sectionOneData.sectionTitle = LOC(@"emergency_contacts_title_key");
    sectionOneData.imageName = @"contacts_icon";
    
    
    NSMutableArray *sectionTwoDataSource = [[NSMutableArray alloc] init];
    NSMutableArray *emergencyServicesArray = [[NSMutableArray alloc] init];
    
    [emergencyServicesArray addObjectsFromArray:onlineUser.emergencyServices];
    
    
    NSInteger servicesCellsCount = 3;
    
    for (int i = 0 ; i < servicesCellsCount; ++i) {
        MyProfileRowViewModel *serviceViewModel;
        EmergencyServiceDataModel *serviceContact;
        if (emergencyServicesArray.count > i) {
            serviceContact = emergencyServicesArray[i];
        }
        
        NSString *valueText;
        NSString *actionString = __showSelectServiceSelector;
        NSString *title = [self serviceTitleForIndex:i];
        BOOL showClearButton = NO;
        if (serviceContact) {
            actionString = __showSelectServiceSelector;
            showClearButton = YES;
            valueText = serviceContact.name;
        }
        
        serviceViewModel = [[MyProfileRowViewModel alloc] initWithTitle:title rowType:MyProfileRowTypeAction];
        serviceViewModel.dataModel = serviceContact;
        serviceViewModel.actionString = actionString;
        serviceViewModel.showClearButton = showClearButton;
        serviceViewModel.showEditButton = YES;
        serviceViewModel.fieldValue = valueText;
        [sectionTwoDataSource addObject:serviceViewModel];
    }
    
    MyProfileSectionViewModel *sectionTwoData = [[MyProfileSectionViewModel alloc] initWithRows:sectionTwoDataSource];
    sectionTwoData.sectionTitle = LOC(@"emergency_services_title");
    sectionTwoData.imageName = @"emergency_serivces_icon";
    
    sectionTwoData.footertext = [Settings sharedInstance].onlineUser.emergencyMessage ? [Settings sharedInstance].onlineUser.emergencyMessage : @"";
    
    MyProfileRowViewModel *emergencyMessageViewModel = [[MyProfileRowViewModel alloc] initWithTitle:@"" rowType:MyProfileRowTypeAction];
    emergencyMessageViewModel.showClearButton = NO;
    emergencyMessageViewModel.showEditButton = NO;
    emergencyMessageViewModel.fieldValue = [onlineUser.helpMessagData messageForLanguage:[Settings sharedInstance].selectedLanguageCode];
    
    MyProfileSectionViewModel *sectionThreeData = [[MyProfileSectionViewModel alloc] initWithRows:@[emergencyMessageViewModel]];
    sectionThreeData.sectionTitle = LOC(@"emergency_message_title_key");
    sectionThreeData.imageName = @"sos_icon";
    
    _policeViewModel = [[MyProfileRowViewModel alloc] initWithTitle:LOC(@"police_title_key") rowType:MyProfileRowTypeSwitch];
    _policeViewModel.isStateOn = onlineUser.checkPolice;
    _policeViewModel.iconImageName = @"police_icon";
    MyProfileSectionViewModel *sectionFourData = [[MyProfileSectionViewModel alloc] initWithRows:@[_policeViewModel]];
    
    MyProfileSectionViewModel *sectionDevider = [[MyProfileSectionViewModel alloc] init];
    sectionDevider.sectionTitle = @"SectionDivider";
    
    self.dataSource = @[sectionOneData, sectionDevider, sectionTwoData, sectionDevider, sectionThreeData, sectionDevider, sectionFourData];
    
    [self.tableView reloadData];
}

- (NSString *)serviceTitleForIndex:(int)index
{
    NSString *ngoNumber = @"";
    switch (index) {
        case 0:
            ngoNumber = @"1";
            break;
        case 1:
            ngoNumber = @"2";
            break;
        case 2:
            ngoNumber = @"3";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat: LOC(@"ngo_title_key"), ngoNumber];
}

- (NSString *)contactTitleForIndex:(int)index
{
    NSString *contactNumber = @"";
    switch (index) {
        case 0:
            contactNumber = @"1";
            break;
        case 1:
            contactNumber = @"2";
            break;
        case 2:
            contactNumber = @"3";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat: LOC(@"emergency_contact_title_key"), contactNumber];
}

- (BOOL)entryExistsOnIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - User Actions

- (void)addEmergencyContact:(NSIndexPath *)indexPath
{
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    [self presentViewController:contactPicker animated:YES completion:nil];
}

- (void)updateEmergencyContact:(MyProfileRowViewModel *)viewData
{
    EmergencyContactDataModel *contactData = (EmergencyContactDataModel *)viewData.dataModel;
    self.updatingEmergencyContactId = [NSString stringWithFormat:@"%@",contactData.emergencyContactId];
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    [self presentViewController:contactPicker animated:YES completion:nil];
}

- (void)showSelectEmergencyService:(MyProfileRowViewModel *)viewData
{
    EmergencyServiceDataModel *serviceData = (EmergencyServiceDataModel *)viewData.dataModel;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Network" bundle:nil];
    NetworkListViewController *networkListController = [storyboard instantiateViewControllerWithIdentifier:@"NetworkListViewController"];
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:networkListController];
    networkListController.delegate = self;
    networkListController.isFromMyProfil = YES;
    networkListController.updatedingServiceId = serviceData.userEmergencyServiceId;
    [self presentViewController:nVC animated:YES completion:nil];
}

- (void)networkList:(NetworkListViewController *)networkPicker didSelectService:(EmergencyServiceDataModel *)emergencyService
{
    UserDataModel *onlineUser = [Settings sharedInstance].onlineUser;
    if (onlineUser.emergencyServices.count > self.selectedIndexPath.row) {
        // update selected service
        weakify(self);
        [self showLoader];
        EmergencyServiceDataModel *selectedService = onlineUser.emergencyServices[self.selectedIndexPath.row];
        [self.userProfileService
         updateEmergencyServiceContact:[NSString stringWithFormat:@"%@", selectedService.userEmergencyServiceId]
         withServiceId:[NSString stringWithFormat:@"%@", emergencyService.serviceId]
         withComplition:^(id response) {
            [self refreshUserData:YES];
        } failure:^(NSError *error) {
            strongify(self)
            [self hideLoader];
            NSLog(@"Error update service %@", error.userInfo);
        }];
    } else {
        weakify(self);
        [self showLoader];
        [self.userProfileService addEmergencyService:[NSString stringWithFormat:@"%@", emergencyService.serviceId] withComplition:^(id response) {
            strongify(self);
            [self refreshUserData:YES];
        } failure:^(NSError *error) {
            strongify(self)
            [self hideLoader];
            NSLog(@"Error add service %@", error.userInfo);
        }];
    }
}

- (void)logout
{
    [self showNotificationsBarButtonitem:NO];
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
        }];
    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    MyProfileSectionViewModel *sectionData = self.dataSource[indexPath.section];
    MyProfileRowViewModel *selectedItem = sectionData.sectionDataSource[indexPath.row];
    if (selectedItem.rowType == MyProfileRowTypeSwitch) {
        return;
    }
    
    SEL selector =  NSSelectorFromString(selectedItem.actionString);
    
    self.selectedIndexPath = indexPath;
    
    if ([self respondsToSelector:selector]) {
        if (selectedItem) {
            [self performSelector:selector withObject:selectedItem];
        } else {
            [self performSelector:selector withObject:indexPath];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyProfileSectionViewModel *sectionData = self.dataSource[section];
    if ([sectionData.sectionTitle  isEqual: @"SectionDivider"]) {
        SectionHeaderWithTitleImage *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionDividerLine"];
        return sectionHeader;
    }
    if (sectionData.sectionTitle.length > 0) {
        SectionHeaderWithTitleImage *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionHeaderWithTitleImage"];
        [sectionHeader configureWithImage:sectionData.imageName title:sectionData.sectionTitle];
        return sectionHeader;
    }
    return nil;
}


- (void)emergencyMessageDidUpdate:(NSString *)updatedMessage
{
    if ([updatedMessage isEqualToString:[Settings sharedInstance].onlineUser.emergencyMessage]) {
        return;
    }
    
    [self showLoader];
    weakify(self);
    [self.userProfileService updateUserDataField:@"emergency_message" value:updatedMessage withComplition:^(id response) {
        strongify(self);
        [self hideLoader];
    } failure:^(NSError *error) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"something_went_wrong_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MyProfileSectionViewModel *sectionData = self.dataSource[section];
    if ([sectionData.sectionTitle isEqual: @"SectionDivider"]) {
        return 66;
    }
    if (sectionData.sectionTitle.length > 0) {
        return 32;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - UItextViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyProfileSectionViewModel *sectionData = self.dataSource[section];
    return sectionData.sectionDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyProfileSectionViewModel *sectionData = self.dataSource[indexPath.section];
    MyProfileRowViewModel *rowData = sectionData.sectionDataSource[indexPath.row];
    NSString *cellIdentifier;
    switch (rowData.rowType) {
        case MyProfileRowTypeNone:
            cellIdentifier = @"EmergencyMessageTableViewCell";
            break;
        case MyProfileRowTypeAction:
            cellIdentifier = @"EmergencyContactTableViewCell";
            break;
        case MyProfileRowTypeNavigation:
            cellIdentifier = NSStringFromClass([MyProfileNavigationTableViewCell class]);
            break;
        case MyProfileRowTypeSwitch:
            cellIdentifier = NSStringFromClass([SwitchActionTableViewCell class]);
            break;
            
        default:
            break;
    }
    
    UITableViewCell <MyProfileCellInterface> *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    [cell configureCellWithViewModelData:rowData];
    return cell;
}

#pragma mark - Confirm police Action Dialog

- (void)showConfirmActionDialog
{
    self.activateCamouflageIconDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction];
    self.activateCamouflageIconDialogView.showCancelButton = YES;
    self.activateCamouflageIconDialogView.delegate = self;
    self.activateCamouflageIconDialogView.continueButtonText = LOC(@"i_understand");
    self.activateCamouflageIconDialogView.titleText = LOC(@"police_warning");
    self.activateCamouflageIconDialogView.message = LOC(@"police_warning_message");
    [self addChildViewController:self.activateCamouflageIconDialogView onView:self.view];
}

#pragma mark - DialogViewDelegate

- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView
{
    [self.userProfileService updateUserDataField:@"check_police" value:[NSString stringWithFormat:@"%@",@(1)] withComplition:^(id response) {
        [Settings sharedInstance].onlineUser.checkPolice = 1;
    } failure:^(NSError *error) {
        NSLog(@"Fail set check police");
    }];
}

- (void)dialogViewDidCancel:(DialogViewController *)dialogView
{
    _policeViewModel.isStateOn = 0;
    [self.tableView reloadData];
}

#pragma mark - TableViewCellActionDelegate
- (void)swithActionCell:(SwitchActionTableViewCell *_Nonnull)cell didChangeState:(BOOL)isOn
{
    if ([[Settings sharedInstance].selectedCountryCode isEqualToString:@"geo"]) {
            [self.userProfileService updateUserDataField:@"check_police" value:[NSString stringWithFormat:@"%@",@(isOn)] withComplition:^(id response) {
                [Settings sharedInstance].onlineUser.checkPolice = isOn;
            } failure:^(NSError *error) {
                NSLog(@"Fail set check police");
            }];
        return;
    }
 
    if(isOn) {
        [self showConfirmActionDialog];
    } else {
        [self.userProfileService updateUserDataField:@"check_police" value:[NSString stringWithFormat:@"%@",@(isOn)] withComplition:^(id response) {
            [Settings sharedInstance].onlineUser.checkPolice = isOn;
        } failure:^(NSError *error) {
            NSLog(@"Fail set check police");
        }];
    }
}

- (void)actionCellDidPressEditButton:(EmergencyContactTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedIndexPath = indexPath;
    [self.view endEditing:YES];
    MyProfileRowViewModel *selectedItem = (MyProfileRowViewModel *)cell.fieldData;
    SEL selector =  NSSelectorFromString(selectedItem.actionString);
    
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:selectedItem];
    }
}

- (void)actionCellDidPressClearButton:(EmergencyContactTableViewCell *)cell
{
    UserDataModel *onlineUser = [Settings sharedInstance].onlineUser;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        // delete emergency contact
        if (onlineUser.emergencyContacts.count > indexPath.row) {
            EmergencyContactDataModel *selectedContact = onlineUser.emergencyContacts[indexPath.row];
            [self deleteUserContact:selectedContact];
        }
        
    }
    if (indexPath.section == 2) {
        // delete emergency service
        if (onlineUser.emergencyServices.count > indexPath.row) {
            EmergencyServiceDataModel *selectedService = onlineUser.emergencyServices[indexPath.row];
            [self deleteEmergencyService:selectedService];
        }
    }
}


#pragma mark - Profile cell delegate

- (void)deleteUserContact:(EmergencyContactDataModel *)emergencyContact
{
    [self showLoader];
    weakify(self);
    [self.userProfileService deleteEmergencyContact:[NSString stringWithFormat:@"%@",emergencyContact.emergencyContactId] withComplition:^(id response) {
        strongify(self)
        [self refreshUserData:YES];
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoader];
        NSLog(@"error %@", error.userInfo);
    }];
}

- (void)deleteEmergencyService:(EmergencyServiceDataModel *)service
{
    [self showLoader];
    weakify(self);
    [self.userProfileService deleteEmergencyServiceContact:[NSString stringWithFormat:@"%@",service.userEmergencyServiceId] withComplition:^(id response) {
        strongify(self);
        [self refreshUserData:YES];
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoader];
        NSLog(@"error %@", error.userInfo);
    }];
}

#pragma mark - ContactPicker Delegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact *contact = contactProperty.contact;
    NSString *identify = contactProperty.identifier;
    if (contact.phoneNumbers.count > 0) {
        [self addSelectedEmergencyContact:contact identify:identify];
    } else {
        return;
    }
}

- (void)addSelectedEmergencyContact:(CNContact *)contact identify:(NSString *)identify
{
    NSString *contactName = contact.givenName;
    if (!contactName || contactName.length == 0) {
        contactName = contact.familyName;
    }
    if (!contactName || contactName.length == 0) {
        contactName = contact.organizationName;
    }
    
    CNLabeledValue <CNPhoneNumber*> *phoneNumber = contact.phoneNumbers[0];
    for (CNLabeledValue<CNPhoneNumber *> *number in contact.phoneNumbers) {
        if ([number.identifier isEqualToString:identify]) {
            phoneNumber = number;
            break;
        }
    }
    
    NSString *phoneNumberString = ((CNPhoneNumber *)phoneNumber.value).stringValue;
    NSString *convertedNumber = [self convertPhoneNumberToCorrectFormat:phoneNumberString];
    if (self.updatingEmergencyContactId) {
        [self showLoader];
        weakify(self);
        [self.userProfileService updateEmergencyContact:self.updatingEmergencyContactId withContactName:contactName phoneNumaber:convertedNumber withComplition:^(id response) {
            strongify(self);
            NSLog(@"Successfully Updated");
            [self refreshUserData:YES];
        } failure:^(NSError *error) {
            strongify(self);
            [self hideLoader];
            [self handleError:error];
            NSLog(@"Update contact error %@", error.userInfo);
        }];
        self.updatingEmergencyContactId = nil;
    } else {
        // add new contact
        [self showLoader];
        weakify(self);
        [self.userProfileService addEmergencyContact:contactName phoneNumber:convertedNumber withComplition:^(id response) {
            strongify(self);
            NSLog(@"Successfully added");
            [self refreshUserData:YES];
        } failure:^(NSError *error) {
            strongify(self);
            [self hideLoader];
            [self handleError:error];
            NSLog(@"Add contact error %@", error.userInfo);
        }];
    }
}


- (NSString *)convertPhoneNumberToCorrectFormat:(NSString *)phoneNumber
{
    NSMutableString *convertingString = [[NSMutableString alloc] initWithString:phoneNumber];
    [convertingString replaceOccurrencesOfString:@" " withString:@"" options:NSDiacriticInsensitiveSearch range:NSMakeRange(0, convertingString.length)];
    [convertingString replaceOccurrencesOfString:@"-" withString:@"" options:NSDiacriticInsensitiveSearch range:NSMakeRange(0, convertingString.length)];
    
    if ([convertingString hasPrefix:@"00"]) {
        [convertingString replaceCharactersInRange:NSMakeRange(0, 2) withString:@""];
    } else if ([convertingString hasPrefix:@"0"]) {
        [convertingString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    if ([convertingString hasPrefix:[[Settings sharedInstance] countryPhoneCodeWhtoutPlusSign]]) {
        [convertingString insertString:@"+" atIndex:0];
    }

    if (![convertingString hasPrefix:[[Settings sharedInstance] countryPhoneCode]]) {
        [convertingString insertString:[[Settings sharedInstance] countryPhoneCode] atIndex:0];
    }

    return [convertingString copy];
}


- (void)refreshUserData:(BOOL)withLoader
{
    weakify(self);
    [self.userProfileService getUserDataWithComplition:^(UserDataModel *userData) {
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

#pragma mark - Error Handling

- (void)handleError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    id errorsMessage = errorInfo[@"message"];
    NSArray *errorsArray;
    if ([errorsMessage isKindOfClass:[NSString class]]) {
        errorsArray = @[errorsMessage];
    } else {
        NSString *firstErrorKey = ((NSDictionary *)errorsMessage).allKeys.firstObject;
        errorsArray = errorsMessage[firstErrorKey];
    }
    
    NSString *errorMessage = [self textFromStringsArray:errorsArray];
    if (!errorMessage.length) {
        errorMessage = errorInfo[@"message"];
    }
    
    [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:errorMessage cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    
}

- (NSString *)textFromStringsArray:(NSArray *)stringsArray
{
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *errorText in stringsArray) {
        [mString appendString:[NSString stringWithFormat: @"%@\n", errorText]];
    }
    
    return [mString copy];
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

#pragma mark - UI Customization

- (void)configureNavigationBar
{
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:[UIColor purpleColor1],
                                     NSFontAttributeName:[UIFont boldFontOfSize:16]};
    self.navigationController.navigationBar.standardAppearance.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar.standardAppearance setTitleTextAttributes:textAttributes];
    [self.navigationController.navigationBar.scrollEdgeAppearance setTitleTextAttributes:textAttributes];
}

@end
