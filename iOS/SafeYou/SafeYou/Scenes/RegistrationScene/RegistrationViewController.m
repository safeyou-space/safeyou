//
//  RegistrationViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RegistrationViewController.h"
#import "SYUIKit.h"
#import "FormDataModel.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "SYAuthenticationService.h"
#import "UIViewController+AlertInterface.h"
#import "RegistrationDataModel.h"
#import "VerifyPhoneNumberViewController.h"
#import "MaritalStatusDataModel.h"
#import "ChooseOptionsViewController.h"
#import "MoreViewTableViewCell.h"
#import "SettingsViewFieldViewModel.h"

@interface RegistrationViewController () <FormTableViewCellDelegate, MoreViewTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet SYDesignableButton *confirmButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *errorString;
@property (nonatomic) SYAuthenticationService *registrationService;
@property (nonatomic) NSArray *maritalStatusList;

@property (nonatomic, strong) RegistrationDataModel *registrationData;

- (IBAction)confirmButtonAction:(id)sender;

// members
@property (nonatomic, weak) FormDataModel *firstNameField;
@property (nonatomic, weak) FormDataModel *lastNameField;
@property (nonatomic, weak) FormDataModel *nickNameField;
@property (nonatomic, weak) FormDataModel *birthDateField;
@property (nonatomic, weak) FormDataModel *mobileNumberField;
@property (nonatomic, weak) FormDataModel *maritalStatusField;
@property (nonatomic, weak) FormDataModel *passwordField;
@property (nonatomic, weak) FormDataModel *confirmPasswordField;

@end

@implementation RegistrationViewController

#pragma mark - Initialize

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.registrationService = [[SYAuthenticationService alloc] init];
        [self configureFormDataSource];
    }
    
    return self;
}

#pragma mark - Controller lificycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self fetchMeritalStatusData];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 0.1;
    self.title = @" ";
    
    self.registrationData = [[RegistrationDataModel alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewSectionHeaderViewWithLabel" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TableViewSectionHeaderViewWithLabel"];
    
    UINib *moreTableViewSwitchCellNib = [UINib nibWithNibName:@"MoreViewTableViewSwitchCell" bundle:nil];
    [self.tableView registerNib:moreTableViewSwitchCellNib forCellReuseIdentifier:@"MoreViewTableViewSwitchCell"];
    
    [self enableKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureGradientBackground];
    [self configureNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super disableKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self calculateFooterSize];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Dynamic sizing for the footer view
    UIView *footerView = self.tableView.tableFooterView;
    if(footerView != nil) {
        CGFloat height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect footerFrame = self.tableView.tableFooterView.frame;
        
        // If we don't have this check, viewDidLayoutSubviews() will get
        // repeatedly, causing the app to hang.
        if(height != footerFrame.size.height) {
            footerFrame.size.height = height;
            footerView.frame = footerFrame;
            self.tableView.tableFooterView = footerView;
        }
    }
}


#pragma mark - Fetch Marital Status
- (void)fetchMeritalStatusData
{
    [self showLoader];
    weakify(self);
    [self.registrationService getMaritalStatusesWithComplition:^(NSArray * _Nonnull response) {
        strongify(self);
        [self hideLoader];
        self.maritalStatusList = response;
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        NSLog(@"Marital status list error");
    }];
}

#pragma mark - Functionality

- (void)showFormErrorAlert
{
    [self showAlertViewWithTitle:LOC(@"error_text_key")
                     withMessage:self.errorString cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
}

#pragma mark - Customization
- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - Select Marital Status

- (void)showSelectMaritalStatus:(NSIndexPath *)indexPath
{
    weakify(self)
    NSArray <NSNumber *>*statusValues = [self.maritalStatusList valueForKeyPath:@"maritalStatusType"];
    NSArray *statusNamesArray = [self.maritalStatusList valueForKeyPath:@"localizedName"];
    
    __block FormDataModel *selectedField = [self fieldForIndexpath:indexPath];
    
    
    NSString *selectedOptionName = selectedField.fieldDisplayValue;
    ChooseOptionsViewController *chooseOptionController = [ChooseOptionsViewController instantiateChooseOptionController];
    chooseOptionController.optionsArray = [statusNamesArray mutableCopy];
    chooseOptionController.optionTitle = LOC(@"select_marital_status_text_key");
    chooseOptionController.selectedOptionName = selectedOptionName;
    chooseOptionController.selectionBlock = ^(NSInteger selectedIndex) {
         strongify(self)
        selectedField.fieldDisplayValue = statusNamesArray[selectedIndex];
        self.registrationData.maritalStatus = statusValues[selectedIndex];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:chooseOptionController animated:YES];
}

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    UIColor *color1 = [UIColor colorWithSYColor:SYGradientColorTypeBottom alpha:1.0];
    UIColor *color2 = [UIColor colorWithSYColor:SYGradientColorTypeTop alpha:1.0];
    gradient.colors = @[(id)color2.CGColor, (id)color1.CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - Layout

- (void)calculateFooterSize
{
    CGSize footerViewSize = [self.tableView.tableFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    if (self.tableView.tableFooterView.frame.size.height != footerViewSize.height) {
        CGRect frame = self.tableView.tableFooterView.frame;
        frame.size.height = footerViewSize.height;
        self.tableView.tableFooterView.frame = frame;
        [self.tableView setNeedsLayout];
        [self.tableView layoutIfNeeded];
    }
}


#pragma mark - View models (DataSource)

- (void)configureFormDataSource
{
    FormDataModel *firstNameField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:LOC(@"first_name_title_key") placeholder:LOC(@"first_name_title_key") value:@"" isRequired:NO];
    self.firstNameField = firstNameField;
    
    FormDataModel *lastNameField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:LOC(@"last_name_text_key") placeholder:LOC(@"last_name_text_key") value:@"" isRequired:NO];
    self.lastNameField = lastNameField;
    
    FormDataModel *nickNameField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:@"nick_name_title_key" placeholder:LOC(@"nickname_placeholder") value:@"" isRequired:NO];
    self.nickNameField = nickNameField;
    
    FormDataModel *birthDateField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePicker dataType:FormFieldDataTypeText title:LOC(@"birth_date_title_key") placeholder:LOC(@"birth_date_title_key") value:@"" isRequired:NO];
    
    self.birthDateField = birthDateField;
    
    FormDataModel *phoneNumberField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePhoneNumber dataType:FormFieldDataTypePhoneNumber title:LOC(@"mobile_number_text_key") placeholder:LOC(@"mobile_number_text_key") value:@"" isRequired:YES];
    phoneNumberField.fieldDisplayValue = [[Settings sharedInstance] countryPhoneCode];
    
    self.mobileNumberField = phoneNumberField;
    
    FormDataModel *maritalStatusField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeChooseOption dataType:FormFieldDataTypeChooseOption title:LOC(@"marital_status_text_key") placeholder:LOC(@"marital_status_text_key") value:@"" isRequired:NO];
    
    self.maritalStatusField = maritalStatusField;
    
    FormDataModel *passwordField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePassword dataType:FormFieldDataTypePassword title:LOC(@"password_text_key") placeholder:LOC(@"password_text_key") value:@"" isRequired:YES];
    self.passwordField = passwordField;
    
    FormDataModel *confirmPasswordField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePassword dataType:FormFieldDataTypePasswordConfirm title:@"confirm_password_text_key" placeholder:LOC(@"confirm_password_text_key") value:@"" isRequired:YES];
    self.confirmPasswordField = confirmPasswordField;
    
    
    self.dataSource =  @[firstNameField, lastNameField, nickNameField, birthDateField, phoneNumberField, maritalStatusField, passwordField, confirmPasswordField];
    
    [self reloadDataSource];
}

- (void)reloadDataSource
{
    [self.tableView reloadData];
}

- (void)reloadTableViewAnimated
{
    [UIView transitionWithView: self.tableView
                      duration: 0.35f
                       options: UIViewAnimationOptionCurveEaseIn
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: nil];
}

#pragma mark - Translate

- (void)updateLocalizations
{
    self.titleLabel.text = LOC(@"sign_up_title_key");
    [self.confirmButton setTitle:[self saveButtonTitle] forState:UIControlStateNormal];
    [self reloadDataSource];
}

- (NSString *)saveButtonTitle
{
    return LOC(@"submit_title_key");
}

- (NSString *)cancelButtonTitle
{
    return LOC(@"cancel");
}



#pragma mark - Interface getter
- (UITableView *)formTableView
{
    return self.tableView;
}


#pragma mark - View model logic

- (FormDataModel *)fieldForIndexpath:(NSIndexPath *)indexPath
{
    FormDataModel *fieldData;
    
    if (indexPath == nil) {
        return nil;
    }
    if (self.dataSource.count - 1 >= indexPath.row) {
        fieldData = self.dataSource[indexPath.row];
    }
    
    return fieldData;
}

- (UIReturnKeyType)returnTypeForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *nextIndexPath;
    
    UIReturnKeyType returnKeyType;
    if ([self isLastSecion:indexPath]) {
        if ([self isLastRowInSection:indexPath]) {
            returnKeyType = UIReturnKeyDone;
        } else {
            nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }
    } else {
        if ([self isLastRowInSection:indexPath]) {
            nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
        } else {
            nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }
    }
    
    FormDataModel *nextFormItem = [self fieldForIndexpath:nextIndexPath];
    
    if (nextFormItem == nil) {
        return UIReturnKeyDone;
    } else if ((nextFormItem.dataType == FormFieldDataTypeText || nextFormItem.dataType == FormFieldDataTypeNumber) && nextFormItem.type != FormFieldTypeChooseOption && nextFormItem.type != FormFieldTypeSwitch && nextFormItem.type != FormFieldTypeAction && nextFormItem.type != FormFieldTypeAdjustment && nextFormItem.type !=FormFieldTypePicker) {
        return  UIReturnKeyNext;
    } else {
        return  UIReturnKeyDone;
    }
    return UIReturnKeyDefault;
}

- (BOOL)isLastSecion:(NSIndexPath *)indexPath
{
    return indexPath.section == [self.tableView numberOfSections] - 1;
}

- (BOOL)isLastRowInSection:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self tableView:self.tableView numberOfRowsInSection:indexPath.section] - 1) {
        return YES;
    }
    return NO;
}

#pragma mark - Submit Form

- (void)submitForm
{
    self.registrationData.firstName  = self.firstNameField.fieldValue;
    self.registrationData.lastName  = self.lastNameField.fieldValue;
    self.registrationData.nickname  = self.nickNameField.fieldValue;
    self.registrationData.birthDay  = self.birthDateField.fieldValue;
    self.registrationData.phoneNumber  = self.mobileNumberField.fieldValue;
    self.registrationData.password  = self.passwordField.fieldValue;
    self.registrationData.confirmPassword  = self.confirmPasswordField.fieldValue;
        
    NSDictionary *registrationDataDict = [self.registrationData toDictionary];
    
    [self showLoader];
    weakify(self);
    [self.registrationService registerUserWithData:registrationDataDict withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        NSLog(@"Uraaaaaa");
        NSString *phoneNumber = self.mobileNumberField.fieldValue;
        [self performSegueWithIdentifier:@"showVerificationView" sender:phoneNumber];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        NSLog(@"Registraion error");
        [self handleRegistrationError:error];
    }];
}

- (void)handleRegistrationError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSDictionary *errorsDict = errorInfo[@"errors"];
    NSString *firstErrorKey = [errorsDict allKeys].firstObject;
    NSArray *errorsArray = errorsDict[firstErrorKey];
    NSString *errorMessage = [self textFromStringsArray:errorsArray];
    
    if (!errorMessage.length) {
        errorMessage = errorInfo[@"message"];
    }
    
    [self showAlertViewWithTitle:LOC(@"registration_error_key") withMessage:errorMessage cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    
}

- (NSString *)textFromStringsArray:(NSArray *)stringsArray
{
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *errorText in stringsArray) {
        [mString appendString:[NSString stringWithFormat: @"%@\n", errorText]];
    }
    
    return [mString copy];
}



#pragma mark - Form Navigation



#pragma mark - Actions

- (IBAction)cancelEditingTapPressed:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)confirmButtonAction:(UIButton *)sender
{
    if ([self isFormCompleted]) {
        [self submitForm];
    } else {
        [self showFormErrorAlert];
    }
}

#pragma mark - Verify form complition

- (BOOL)isFormCompleted
{
    if (![self isSectionDataCompleted:self.dataSource]) {
        return NO;
    }
    return YES;
}

- (BOOL)isSectionDataCompleted:(NSArray *)sectionData
{
    for (FormDataModel *formItem in sectionData) {
        if (formItem.validationRegex && formItem.validationRegex.length > 0) {
            return [formItem isValidWithRegex];
        }
        if (formItem.isRequired && !formItem.fieldValue.length) {
            self.errorString = LOC(@"fill_required_fields_text_key");
            return NO;
        }
    }
    if (![self.passwordField.fieldValue isEqualToString:self.confirmPasswordField.fieldValue]) {
        self.errorString = LOC(@"passwords_not_match_text_key");
        return NO;
    }
    return YES;
}


#pragma mark - FormCellDelegate

- (void)formTableViewCell:(FormTableViewCell *)cell didChangeText:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FormDataModel *formItem = [self fieldForIndexpath:indexPath];
    formItem.fieldValue = text;
    formItem.fieldDisplayValue = text;
}

- (void)formTableViewCellShouldRetrun:(FormTableViewCell *)formCell returnKeyType:(UIReturnKeyType)returnKeyType
{
    [formCell resignFirstResponder];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

#pragma mark - Getter

- (SYColorType)eyeTintColorType
{
    return SYColorTypeMain3;
}

#pragma mark - Setter

- (void)setEditingDisabled:(BOOL)editingDisabled
{
    _editingDisabled = editingDisabled;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    FormDataModel *currentFormItem = self.dataSource[indexPath.row];
    
    if ([currentFormItem isKindOfClass:[SettingsViewFieldViewModel class]]) {
        SettingsViewFieldViewModel *formItem = (SettingsViewFieldViewModel *)currentFormItem;
        if (formItem.accessoryType == FieldAccessoryTypeSwitch) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoreViewTableViewSwitchCell"];
            ((MoreViewTableViewCell *)cell).delegate = self;
            
            [((MoreViewTableViewCell *)cell) configureWithViewData:formItem];
            return cell;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoreViewTableViewCell"];
            ((MoreViewTableViewCell *)cell).delegate = self;
            
            [((MoreViewTableViewCell *)cell) configureWithViewData:formItem];
            return cell;
        }
    }
    
    NSString *cellIdentifier = @"FormTableViewCell";
    if (currentFormItem.type == FormFieldTypePicker) {
        cellIdentifier = @"FormTableViewCellDate";
    }
    
    UIReturnKeyType returnKeyType = [self returnTypeForIndexPath:indexPath];
    
    FormTableViewCell *formTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    formTableViewCell.userInteractionEnabled = !self.editingDisabled;
    formTableViewCell.eyeIconTintColorType = [self eyeTintColorType];
    formTableViewCell.inputLength = currentFormItem.inputLength;
    [formTableViewCell configureWithFieldType:currentFormItem.type dataType:currentFormItem.dataType title:currentFormItem.fieldTitle placeholder:currentFormItem.fieldPlaceholder value:currentFormItem.fieldDisplayValue regex:currentFormItem.inputRegex isRequired:currentFormItem.isRequired returnType:returnKeyType];
    formTableViewCell.formCellDelegate = self;
    cell = formTableViewCell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormDataModel *selectedField = [self fieldForIndexpath:indexPath];
    if (selectedField == self.maritalStatusField) {
        [self showSelectMaritalStatus:indexPath];
    }
}

- (void)formTableViewCellShoulRetrun:(FormTableViewCell *)formCell returnKeyType:(UIReturnKeyType)returnKeyType
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:formCell];
//    FormDataModel *cellField =
    switch (returnKeyType) {
        case UIReturnKeyDone:
            [formCell resignFirstResponder];
            break;
        case UIReturnKeyNext:
            [self activateNextField:cellIndexPath];
            break;
        default:
            [formCell resignFirstResponder];
            break;
    }
}

- (void)activateNextField:(NSIndexPath *)currentIndexPath
{
    NSIndexPath *nextIndexPath;
    FormTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
    if ([self isLastSecion:currentIndexPath]) {
        if ([self isLastRowInSection:currentIndexPath]) {
            [currentCell resignFirstResponder];
        } else {
            nextIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:currentIndexPath.section];
        }
    } else {
        if ([self isLastRowInSection:currentIndexPath]) {
            nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:currentIndexPath.section + 1];
        } else {
            nextIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:currentIndexPath.section];
        }
    }
    
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
    
    [nextCell becomeFirstResponder];
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
    if ([segue.identifier isEqualToString:@"showVerificationView"]) {
        VerifyPhoneNumberViewController *destinationVC = segue.destinationViewController;
        destinationVC.phoneNumber = (NSString *)sender;
        destinationVC.password = self.registrationData.password;
        destinationVC.isFromRegistration = YES;
    }
}

@end
