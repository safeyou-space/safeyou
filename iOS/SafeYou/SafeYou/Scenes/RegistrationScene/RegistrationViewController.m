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
#import "MaritalStatusDataModel.h"
#import "ChooseOptionsViewController.h"
#import "MoreViewTableViewCell.h"
#import "SettingsViewFieldViewModel.h"
#import "SafeYou-Swift.h"
#import "NicknameService.h"

@interface RegistrationViewController () <FormTableViewCellDelegate, MoreViewTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet SYDesignableButton *confirmButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *errorString;
@property (nonatomic) SYAuthenticationService *registrationService;
@property (nonatomic) NSArray *maritalStatusList;

- (IBAction)confirmButtonAction:(id)sender;

// members
@property (nonatomic, weak) FormDataModel *firstNameField;
@property (nonatomic, weak) FormDataModel *lastNameField;
@property (nonatomic, weak) FormDataModel *nickNameField;
@property (nonatomic, weak) FormDataModel *birthDateField;
@property (nonatomic, weak) FormDataModel *maritalStatusField;

@property (nonatomic) NicknameService *nicknameService;

@end

@implementation RegistrationViewController

#pragma mark - Initialize

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.registrationService = [[SYAuthenticationService alloc] init];
        self.nicknameService = [[NicknameService alloc] init];
        [self configureFormDataSource];
    }
    
    return self;
}

#pragma mark - Controller lificycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self fetchMeritalStatusData];
    


//    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 0.1;
    self.title = @" ";
    
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

- (void)showFormErrorAlert:(nullable NSString *)message
{
    NSString *alertMessage = LOC(@"error_text_key");
    if (message != nil) {
        alertMessage = message;
    }
    [self showAlertViewWithTitle:alertMessage
                     withMessage:self.errorString cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
}

#pragma mark - Customization
- (void)configureNavigationBar
{
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithTransparentBackground];
    appearance.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - Select Marital Status

- (void)showSelectMaritalStatus:(NSIndexPath *)indexPath
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@""
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:LOC(@"marital_status_text_key")];
    [titleText addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blackColor] // Change text color as needed
                      range:NSMakeRange(0, [titleText length])];
    [actionSheet setValue:titleText forKey:@"attributedTitle"];


    // Add options/actions
    FormDataModel *selectedField = [self fieldForIndexpath:indexPath];
    NSArray <NSNumber *>*statusValues = [self.maritalStatusList valueForKeyPath:@"maritalStatusType"];
    NSArray *statusNamesArray = [self.maritalStatusList valueForKeyPath:@"localizedName"];
    for (int i = 0; i < statusNamesArray.count; ++i) {
        UIAlertAction *option = [UIAlertAction actionWithTitle:statusNamesArray[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            selectedField.fieldDisplayValue = statusNamesArray[i];
            self.registrationData.maritalStatus = statusValues[i];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];

        [option setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        [actionSheet addAction:option];
    }

    actionSheet.view.tintColor = [UIColor purpleColor1];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOC(@"cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // Handle cancel action
                                                         }];
    [actionSheet addAction:cancelAction];

    // Present the action sheet
    [self presentViewController:actionSheet animated:YES completion:nil];
}

// @FIXME: Dublicate code need refactor
- (void)configureGradientBackground
{
    self.view.backgroundColor = [UIColor mainTintColor2];
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
    FormDataModel *firstNameField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:LOC(@"first_name_title_key") placeholder:LOC(@"first_name_title_key") value:@"" isRequired:YES];
    self.firstNameField = firstNameField;
    
    FormDataModel *lastNameField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:LOC(@"last_name_title_key") placeholder:LOC(@"last_name_title_key") value:@"" isRequired:YES];
    self.lastNameField = lastNameField;
    
    FormDataModel *nickNameField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:LOC(@"nick_name_title_key") placeholder:LOC(@"nickname_placeholder") value:@"" isRequired:NO];
    self.nickNameField = nickNameField;
    
    FormDataModel *birthDateField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePicker dataType:FormFieldDataTypeText title:LOC(@"birth_date_title_key") placeholder:LOC(@"birth_date_title_key") value:@"" isRequired:YES];
    
    self.birthDateField = birthDateField;

    
    FormDataModel *maritalStatusField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeChooseOption dataType:FormFieldDataTypeChooseOption title:LOC(@"marital_status_text_key") placeholder:LOC(@"marital_status_text_key") value:@"" isRequired:NO];
    
    self.maritalStatusField = maritalStatusField;

    
    self.dataSource =  @[firstNameField, lastNameField, nickNameField, birthDateField, maritalStatusField];
    
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
    self.mainTitleLabel.text = LOC(@"account_details_text");
    self.secondaryTitleLabel.text = LOC(@"provide_your_information_text");
    [self.confirmButton setTitle:[self saveButtonTitle] forState:UIControlStateNormal];
    [self reloadDataSource];
}

- (NSString *)saveButtonTitle
{
    return LOC(@"next_key");
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

    [self performSegueWithIdentifier:@"showTermsAndConditionsView" sender: self];
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
    [self showLoader];
    weakify(self);
    if ([self isFormCompleted]) {
        [self.nicknameService checkNickname:self.nickNameField.fieldValue success:^(id  _Nonnull response) {
            strongify(self);
            [self hideLoader];
            [self submitForm];
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
            if (error.userInfo[@"message"]) {
                [self showFormErrorAlert:error.userInfo[@"message"]];
            } else {
                [self showFormErrorAlert:LOC(@"something_went_wrong_text_key")];
            }
        }];
    } else {
        [self showFormErrorAlert:nil];
    }


}

- (IBAction)backButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            self.errorString = LOC(@"empty_field");
            return NO;
        }
    }
    if (self.nickNameField.fieldValue.length  > 0 && self.nickNameField.fieldValue.length < 2) {
        self.errorString = LOC(@"min_length_2");
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

- (BOOL)formCell:(FormTableViewCell *)formCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:formCell];
    FormDataModel *currentField = self.dataSource[cellIndexPath.row];
    
    return YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark - Getter

- (SYColorType)eyeTintColorType
{
    return SYColorTypeMain6;
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
    if ([segue.identifier isEqualToString: @"showTermsAndConditionsView"]) {
        TermsAndConditionsViewController *destinationVC = segue.destinationViewController;
        [destinationVC registrationDataDict: [self.registrationData toDictionary]];
    }
}

@end
