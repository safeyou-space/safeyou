//
//  BecomeConsultantViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/21/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BecomeConsultantViewController.h"
#import "SYConsultantService.h"
#import "FormDataModel.h"
#import "FormTableViewCell.h"
#import "ConsultantExpertiseFieldDataModel.h"
#import "ChooseOptionsViewControllerWithConfirm.h"
#import "SYDesignableCheckBoxButton.h"
#import "SYDesignableAttributedLabel.h"
#import "WebContentViewController.h"
#import "ConsultantNewRequestDataModel.h"
#import "UserConsultantRequestDataModel.h"
#import "UserDataModel.h"
#import "SYDesignableCheckBoxButton.h"
#import "ConsultantRequestInfoViewModel.h"
#import "ConsultantRequestStatusCell.h"
#import "DialogViewController.h"
#import "SYProfileService.h"

@interface BecomeConsultantViewController () <UITableViewDelegate, UITableViewDataSource, FormTableViewCellDelegate, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate, DialogViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYDesignableButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;
@property (weak, nonatomic) IBOutlet SYDesignableCheckBoxButton *agrrementCheckboxButton;
@property (weak, nonatomic) IBOutlet SYDesignableAttributedLabel *agreementTextLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelEditingTapGesture;
@property (nonatomic) DialogViewController *confirmActionDialogView;

- (IBAction)cancelEditingAction:(UITapGestureRecognizer *)sender;

- (IBAction)sendRequestButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)checkboxButtonAction:(SYDesignableCheckBoxButton *)sender;

@property (nonatomic) SYConsultantService *consultantService;
@property (nonatomic) SYProfileService *profileService;

@property (nonatomic) NSArray <ConsultantExpertiseFieldDataModel *> *consultantCategories;

@property (nonatomic) FormDataModel *experienceField;
@property (nonatomic) FormDataModel *proposalField;
@property (nonatomic) FormDataModel *emailField;
@property (nonatomic) ConsultantRequestInfoViewModel *requestStatusField;

@property (nonatomic) NSArray *dataSource;

@property (nonatomic) BOOL editingDisabled;
@property (nonatomic) UserConsultantRequestDataModel *currentConsultantRequestData;
@property (nonatomic) ConsultantNewRequestDataModel *creatingConsultantRequestData;
@property (nonatomic) BOOL isConsultant;

@end

@implementation BecomeConsultantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.isResubmittingRequest) {
        UserDataModel *onlineUser = [Settings sharedInstance].onlineUser;
        self.isConsultant = onlineUser.isConsultant;
        if (onlineUser.currentConsultantRequest) {
            self.currentConsultantRequestData = onlineUser.currentConsultantRequest;
        } else {
            self.creatingConsultantRequestData = [[ConsultantNewRequestDataModel alloc] init];
        }
    } else {
        self.creatingConsultantRequestData = [[ConsultantNewRequestDataModel alloc] init];
    }
    self.tableView.hidden = YES;
    self.consultantService = [[SYConsultantService alloc] init];
    self.profileService = [[SYProfileService alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self enableKeyboardNotifications];
    [self showLoader];
    weakify(self);
    [self.consultantService getConsultantCategoriesWithComplition:^(NSArray <ConsultantExpertiseFieldDataModel *> *consultantCategories) {
        strongify(self);
        [self hideLoader];
        self.consultantCategories = consultantCategories;
        [self configureConsultantAgreementText];
        [self configureFormDataSource];
        self.tableView.hidden = NO;
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
    }];
    
    self.cancelEditingTapGesture.cancelsTouchesInView = NO;
    self.cancelEditingTapGesture.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.agreementTextLabel sizeToFit];
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.tableView.tableFooterView) {
        CGRect footerFrame = self.tableView.tableFooterView.frame;
        CGFloat calculatedHeight = [self.tableView.tableFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        footerFrame.size.height = calculatedHeight;
        
        self.tableView.tableFooterView.frame = footerFrame;
        
    }
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"become_consultant_title");
    [self configureConsultantAgreementText];
    if (self.currentConsultantRequestData) {
        if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusPending) {
            [self.sendRequestButton setTitle:LOC(@"cancel_request") forState:UIControlStateNormal];
            [self.cancelButton setTitle:LOC(@"back") forState:UIControlStateNormal];
        }
        
        if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusDeclined) {
            [self.sendRequestButton setTitle:LOC(@"new_request_inquiry") forState:UIControlStateNormal];
            [self.cancelButton setTitle:LOC(@"back") forState:UIControlStateNormal];
        }
        
        if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusConfirmed) {
            [self.sendRequestButton setTitle:LOC(@"deactivate") forState:UIControlStateNormal];
            [self.cancelButton setTitle:LOC(@"back") forState:UIControlStateNormal];
        }
    } else {
        [self.sendRequestButton setTitle:LOC(@"continue") forState:UIControlStateNormal];
        [self.cancelButton setTitle:LOC(@"cancel") forState:UIControlStateNormal];
    }
}

#pragma mark - Show Confirm Dialog

- (void)showConfirmActionDiaog
{
    self.confirmActionDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction];
    self.confirmActionDialogView.showCancelButton = YES;
    self.confirmActionDialogView.delegate = self;
    self.confirmActionDialogView.titleText = LOC(@"");
    NSString *message = LOC(@"deactivate_confirm_message");
    if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusPending) {
        message = LOC(@"cancel_request_message");
    } else if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusDeclined) {
        message = LOC(@"new_request_message");
    }
    self.confirmActionDialogView.message = message;
    [self addChildViewController:self.confirmActionDialogView onView:self.view];
}

#pragma mark - DialogViewDelegate

- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView
{
    if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusPending) {
        [self showLoader];
        weakify(self);
        [self.consultantService cancelConsultantRequestWithComplition:^(id  _Nonnull response) {
            strongify(self);
            [self hideLoader];
            [Settings sharedInstance].onlineUser.currentConsultantRequest = nil;
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            [self hideLoader];
            // TODO: Handle Error
        }];
    } else if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusDeclined) {
        [self submitNewConsultantRequest:YES];
    } else if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusConfirmed) {
        weakify(self)
        [self showLoader];
        [self.consultantService deactivateConsultantWithComplition:^(id  _Nonnull response) {
            strongify(self);
            [self hideLoader];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

#pragma mark - Helper

- (void)configureConsultantAgreementText
{
//    "consultant_agreement_text" = "By pressing \"Send Request\" you agree to our \"%@\"";

//    "consultant_terms_and_conditions" = "Consultant terms and conditions";
    if (self.currentConsultantRequestData) {
        self.agreementTextLabel.hidden = YES;
        self.agrrementCheckboxButton.hidden = YES;
    } else {
        NSString *mainText = LOC(@"consultant_agreement_text");
        NSString *urlText = LOC(@"consultant_terms_and_conditions");
        NSString *finalText = [NSString stringWithFormat:mainText, urlText];
        
        self.agreementTextLabel.text = finalText;
        NSRange urlRange = [finalText rangeOfString:urlText];
        [self.agreementTextLabel addLinkToURL:[NSURL URLWithString:@"https://www.google.com/"] withRange:urlRange];
        self.agreementTextLabel.delegate = self;
    }
}

- (ConsultantExpertiseFieldDataModel *)categoryForId:(NSString *)categoryId
{
    NSArray *idsArray = [self.consultantCategories valueForKeyPath:@"categoryId"];
    NSInteger index = [idsArray indexOfObject:categoryId];
    if (index < self.consultantCategories.count) {
        return self.consultantCategories[index];
    }
    return nil;
}

#pragma mark - Configure DataSource

- (void)configureFormDataSource
{
    NSMutableArray *configuringDataSourceArray = [[NSMutableArray alloc] init];
    
    if (self.currentConsultantRequestData) {
        ConsultantRequestInfoViewModel *requestStatusField = [ConsultantRequestInfoViewModel statusInfoDataFromRequestData:self.currentConsultantRequestData];
        self.requestStatusField = requestStatusField;
        [configuringDataSourceArray addObject:requestStatusField];
    }
    
    
    FormDataModel *experienceField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeChooseOption dataType:FormFieldDataTypeChooseOption title:LOC(@"field_of_expertise") placeholder:LOC(@"field_of_expertise") value:self.experienceField.fieldDisplayValue isRequired:NO];
    self.experienceField = experienceField;
    [configuringDataSourceArray addObject:self.experienceField];
    
    
    FormDataModel *proposalField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeLargeText dataType:FormFieldDataTypeText title:LOC(@"why_become_consultant") placeholder:LOC(@"why_would_you_placeholder") value:@"" isRequired:NO];
    self.proposalField = proposalField;
    [configuringDataSourceArray addObject:self.proposalField];
    
    FormDataModel *emailField = [[FormDataModel alloc] initWithFieldType:FormFieldTypeText dataType:FormFieldDataTypeText title:LOC(@"email_address") placeholder:LOC(@"email_address") value:@"" isRequired:NO];
    self.emailField = emailField;
    [configuringDataSourceArray addObject:self.emailField];
    
    if (self.currentConsultantRequestData) {
        ConsultantRequestInfoViewModel *requestDateData = [ConsultantRequestInfoViewModel submissionDateDataFromRequestData:self.currentConsultantRequestData];
        [configuringDataSourceArray addObject:requestDateData];
    }
    
    if (self.currentConsultantRequestData) {
        self.creatingConsultantRequestData.emailAddress = self.currentConsultantRequestData.email;
        self.creatingConsultantRequestData.promotionalText = self.currentConsultantRequestData.message;
        ConsultantExpertiseFieldDataModel *currentProfession = [self categoryForId:[NSString stringWithFormat:@"%@",self.currentConsultantRequestData.professionCategoryId]];
        self.experienceField.fieldPlaceholder = @"";
        self.experienceField.fieldDisplayValue = currentProfession.categoryName;
        self.experienceField.fieldValue = currentProfession.categoryId;
        
        self.emailField.fieldDisplayValue = self.currentConsultantRequestData.email;
        self.emailField.fieldValue = self.currentConsultantRequestData.email;
        
        self.proposalField.fieldDisplayValue = self.currentConsultantRequestData.message;
        self.proposalField.fieldValue = self.currentConsultantRequestData.message;
    }
    
    self.dataSource =  [configuringDataSourceArray copy];
    
    [self reloadDataSource];
}

- (void)reloadDataSource
{
    [self configureConsultantAgreementText];
    [self updateLocalizations];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormDataModel *currentFormItem = self.dataSource[indexPath.row];
    if ([currentFormItem isKindOfClass:[ConsultantRequestInfoViewModel class]]) {
        return 70.0;
    }
    if (currentFormItem.type == FormFieldTypeLargeText) {
        return 173.0;
    }
    
    return 44.0;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormDataModel *currentFormItem = self.dataSource[indexPath.row];
    if (currentFormItem == self.experienceField) {
        [self showSelectConsultantExprience:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentItem = self.dataSource[indexPath.row];
    
    NSString *cellIdentifier = @"FormTableViewCell";
    if ([currentItem isKindOfClass:[ConsultantRequestInfoViewModel class]]) {
        cellIdentifier = @"ConsultantRequestStatusCell";
        ConsultantRequestStatusCell *statusCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [statusCell configureWithRequestInfoData:currentItem];
        return statusCell;
    }
    
    FormDataModel *currentFormItem = (FormDataModel *)currentItem;
    if (currentFormItem.type == FormFieldTypeLargeText) {
        cellIdentifier = @"FormTableViewCellTextView";
    }
    
    
    
    UIReturnKeyType returnKeyType = UIReturnKeyDone;
    FormTableViewCell *formTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    formTableViewCell.userInteractionEnabled = !self.editingDisabled;
    formTableViewCell.inputLength = currentFormItem.inputLength;
    [formTableViewCell configureWithFieldType:currentFormItem.type dataType:currentFormItem.dataType title:currentFormItem.fieldTitle placeholder:currentFormItem.fieldPlaceholder value:currentFormItem.fieldDisplayValue regex:currentFormItem.inputRegex isRequired:currentFormItem.isRequired returnType:returnKeyType];
    formTableViewCell.formCellDelegate = self;
    
    if (self.currentConsultantRequestData) {
        formTableViewCell.userInteractionEnabled = NO;
    } else {
        formTableViewCell.userInteractionEnabled = YES;
    }
    
    
    return formTableViewCell;
}

#pragma mark - Choose Options

- (void)showSelectConsultantExprience:(NSIndexPath *)indexPath
{
    weakify(self)
    NSArray <NSNumber *>*categoryIdsArray = [self.consultantCategories valueForKeyPath:@"categoryId"];
    NSArray *categoryNamesArray = [self.consultantCategories valueForKeyPath:@"categoryName"];
    
    __block FormDataModel *selectedField = self.dataSource[indexPath.row];
    
    NSString *selectedOptionName = selectedField.fieldDisplayValue;
    ChooseOptionsViewControllerWithConfirm *chooseOptionController = [ChooseOptionsViewControllerWithConfirm instantiateChooseOptionController];
    chooseOptionController.chooseOptionType = SYChooseOptionTypeRadio;
    chooseOptionController.optionsArray = [categoryNamesArray mutableCopy];
    chooseOptionController.optionTitle = LOC(@"field_of_expertise");
    chooseOptionController.selectedOptionName = selectedOptionName;
    chooseOptionController.hasCustomInput = YES;
    chooseOptionController.customInputTitle = LOC(@"other_title");
    chooseOptionController.customInputPlaceholder = LOC(@"add_your_experience");
    [self.navigationController pushViewController:chooseOptionController animated:YES];
    
    chooseOptionController.selectionBlock = ^(NSInteger selectedIndex) {
         strongify(self)
        self.creatingConsultantRequestData.isNewExpertiseFieldSuggested = NO;
        selectedField.fieldDisplayValue = categoryNamesArray[selectedIndex];
        selectedField.fieldValue = [NSString stringWithFormat:@"%@",categoryIdsArray[selectedIndex]];
        self.creatingConsultantRequestData.expertiseFieldDataModel = [[ConsultantExpertiseFieldDataModel alloc] initWithId:selectedField.fieldValue name:selectedField.fieldDisplayValue];
        self.creatingConsultantRequestData.suggestedExpertiseField = @"";
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    chooseOptionController.customInputSelectionblock = ^(NSString * _Nonnull customSelectedValue) {
        strongify(self);
        self.creatingConsultantRequestData.isNewExpertiseFieldSuggested = YES;
        self.creatingConsultantRequestData.suggestedExpertiseField = customSelectedValue;
        self.creatingConsultantRequestData.expertiseFieldDataModel = nil;
        selectedField.fieldDisplayValue = customSelectedValue;
        selectedField.fieldValue = customSelectedValue;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    chooseOptionController.cancelBlock = ^{
        // handle cancel selection
    };
}

#pragma mark - TTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if (label == self.agreementTextLabel) {
        [self performSegueWithIdentifier:@"showWebContentViewFromConsultantView" sender:nil];
    }
}

#pragma mark - Actions

- (IBAction)checkboxButtonAction:(SYDesignableCheckBoxButton *)sender {
    
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendRequestButtonAction:(UIButton *)sender {
    if (self.currentConsultantRequestData) {
        if (self.currentConsultantRequestData.requestStatus == ConsultantRequestStatusDeclined) {
            [self showNewRequestView];
        } else {
            [self showConfirmActionDiaog];
        }
    } else {
        [self submitNewConsultantRequest:NO];
    }
}

- (void)showNewRequestView
{
    BecomeConsultantViewController *newRequestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BecomeConsultantViewController"];
    newRequestVC.isResubmittingRequest = YES;
    [self.navigationController pushViewController:newRequestVC animated:YES];
    
    NSMutableArray *viewControllersCopy = [self.navigationController.viewControllers mutableCopy];
    NSInteger count = viewControllersCopy.count;
    [viewControllersCopy removeObjectAtIndex:count -2];
    self.navigationController.viewControllers = [viewControllersCopy copy];
}

- (void)submitNewConsultantRequest:(BOOL)fromCurrentrequest
{
    NSDictionary *requestParams;
    
    if ([self isFormCompleted]) {
        self.creatingConsultantRequestData = [[ConsultantNewRequestDataModel alloc] init];
        self.creatingConsultantRequestData.emailAddress = self.emailField.fieldValue;
        self.creatingConsultantRequestData.promotionalText = self.proposalField.fieldValue;
        self.creatingConsultantRequestData.expertiseFieldDataModel = [[ConsultantExpertiseFieldDataModel alloc] initWithId:self.experienceField.fieldValue name:self.experienceField.fieldDisplayValue];
        requestParams = [self.creatingConsultantRequestData dictionaryRepresentation];
        [self showLoader];
        weakify(self);
        [self.consultantService requestForBecomingConsultantWithParams:requestParams complition:^(id  _Nonnull response) {
            NSLog(@"Consultant request completed");
            strongify(self);
            [self hideLoader];
            NSString *message = LOC(@"consultant_request_success_message");
            [self showAlertViewWithTitle:nil withMessage:message cancelButtonTitle:nil okButtonTitle:LOC(@"ok") cancelAction:nil okAction:^{
                strongify(self);
                NSLog(@"Ok pressed");
                [self fetchUserDataAndReload];
            }];
        } failure:^(NSError * _Nonnull error) {
            strongify(self);
            NSString *message = @"";
            NSDictionary *errorDict = error.userInfo[@"message"][@"email"];
            if ([errorDict isKindOfClass:[NSArray class]]) {
                message = ((NSArray *)errorDict).firstObject;
            }
            [self hideLoader];
            
            [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:message cancelButtonTitle:nil okButtonTitle:LOC(@"ok") cancelAction:nil okAction:nil];
            
            NSLog(@"Consultant Request failed");
        }];
    } else {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"fill_required_fields_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }
}

- (IBAction)cancelEditingAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Validation

- (BOOL)isFormCompleted
{
    if (self.proposalField.fieldValue.length == 0) {
        return NO;
    }
    
    if (![self isValidEmail:self.emailField.fieldValue]) {
        return NO;
    }
    
    if (self.experienceField.fieldValue.length == 0) {
        return NO;
    }
    
    if (self.currentConsultantRequestData == nil) {
        if (!self.agrrementCheckboxButton.selected) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isValidEmail:(NSString *)checkingEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkingEmail];
}

#pragma mark - RefreshUserData

- (void)fetchUserDataAndReload
{
    [self showLoader];
    weakify(self);
    [self.profileService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        [Settings sharedInstance].onlineUser = userData;
        self.currentConsultantRequestData = userData.currentConsultantRequest;
        [self configureFormDataSource];
        [self hideLoader];
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoader];
    }];
}

#pragma mark - FormCellDelegate

- (void)formTableViewCell:(FormTableViewCell *)cell didChangeText:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FormDataModel *currentField = self.dataSource[indexPath.row];
    if (currentField == self.emailField) {
        self.emailField.fieldValue = text;
        self.creatingConsultantRequestData.emailAddress = text;
    }
    
    if (currentField == self.proposalField) {
        self.proposalField.fieldValue = text;
        self.creatingConsultantRequestData.promotionalText = text;
    }
}

- (void)formTableViewCellShouldRetrun:(FormTableViewCell *)formCell returnKeyType:(UIReturnKeyType)returnKeyType
{
    [self.view endEditing:YES];
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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);;
    weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showWebContentViewFromConsultantView"]) {
        WebContentViewController *destination = (WebContentViewController *)segue.destinationViewController;
        destination.contentType = SYRemotContentTypeConsultantTermsAndConditions;
    }
}
@end
