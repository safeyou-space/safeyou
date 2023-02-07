//
//  CreateDualPinViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "CreateDualPinViewController.h"
#import "FormDataModel.h"
#import "LoginWithPinViewController.h"
#import "SettingsViewFieldViewModel.h"
#import "SwitchActionTableViewCell.h"
#import "DialogViewController.h"
#import "MoreViewTableViewCell.h"

@interface CreateDualPinViewController () <FormTableViewCellDelegate, DialogViewDelegate, UITableViewDelegate, DialogViewDelegate>

@property (nonatomic) FormDataModel *realPinField;
@property (nonatomic) FormDataModel *realPinFieldConfirm;
@property (nonatomic) FormDataModel *fakePinField;
@property (nonatomic) FormDataModel *fakePinFieldConfirm;
@property (nonatomic) BOOL isSwitchEnabled;

@property (nonatomic) DialogViewController *activateCamouflageIconDialogView;

@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;

- (IBAction)cancelButtonAction:(SYDesignableButton *)sender;


@end

@implementation CreateDualPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.formTableView.separatorColor = [UIColor clearColor];
    self.editingDisabled = ![Settings sharedInstance].isDualPinEnabled;
    self.isSwitchEnabled = [Settings sharedInstance].isDualPinEnabled;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.presentingViewController || self.navigationController.presentingViewController) {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOC(@"cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangePin:)];
                
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
}

- (void)updateLocalizations
{
    [super updateLocalizations];
    self.navigationItem.title = LOC(@"dual_pin_title_key");
    [self.cancelButton setTitle:[self cancelButtonTitle] forState:UIControlStateNormal];
    self.titleLabel.text = LOC(@"add_dual_pin_title_key");
    [self configureFormDataSource];
    [self reloadDataSource];
}

- (NSString *)saveButtonTitle
{
    return LOC(@"save_key").uppercaseString;
}

- (NSString *)cancelButtonTitle
{
    return LOC(@"cancel").uppercaseString;
}
#pragma mark - Getter

- (SYColorType)eyeTintColorType
{
    return SYColorTypeLightGray;
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Handle Presentation


#pragma mark - View models (DataSource)

- (void)configureFormDataSource
{
    SettingsViewFieldViewModel *enablePinField = [[SettingsViewFieldViewModel alloc] init];
    enablePinField.mainTitle = self.pinSwitchTitle; //LOC(@"dual_pin_title_key");
    enablePinField.iconImageName = @"pin_icon";
    enablePinField.accessoryType = FieldAccessoryTypeSwitch;
    enablePinField.isStateOn = [Settings sharedInstance].isDualPinEnabled;
    
     FormDataModel *realPinField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePassword dataType:FormFieldDataTypeNumber title:LOC(@"enter_real_pin_text_key") placeholder:LOC(@"enter_real_pin_text_key") value:@"" isRequired:YES];
    realPinField.inputLength = 4;
    self.realPinField = realPinField;
    
    FormDataModel *realPinFieldConfirm = [[FormDataModel alloc] initWithFieldType:FormFieldTypePassword dataType:FormFieldDataTypeNumber title:LOC(@"confirm_real_pin_text_key") placeholder:LOC(@"confirm_real_pin_text_key") value:@"" isRequired:YES];
    realPinFieldConfirm.inputLength = 4;
    self.realPinFieldConfirm = realPinFieldConfirm;
    
    
    FormDataModel *fakePinField = [[FormDataModel alloc] initWithFieldType:FormFieldTypePassword dataType:FormFieldDataTypeNumber title:LOC(@"enter_fake_pin_text_key") placeholder:LOC(@"enter_fake_pin_text_key") value:@"" isRequired:YES];
    fakePinField.inputLength = 4;
    self.fakePinField = fakePinField;
    
    FormDataModel *fakePinFieldConfirm = [[FormDataModel alloc] initWithFieldType:FormFieldTypePassword dataType:FormFieldDataTypeNumber title:LOC(@"confirm_fake_pin_text_key") placeholder:LOC(@"confirm_fake_pin_text_key") value:@"" isRequired:YES];
    fakePinFieldConfirm.inputLength = 4;
    self.fakePinFieldConfirm = fakePinFieldConfirm;
    
    self.dataSource = @[enablePinField, realPinField, realPinFieldConfirm, fakePinField, fakePinFieldConfirm];
    
    [self reloadDataSource];
}

#pragma mark - Confirm Action Dia

- (void)showConfirmActionDialog
{
    self.activateCamouflageIconDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction];
    self.activateCamouflageIconDialogView.showCancelButton = YES;
    self.activateCamouflageIconDialogView.delegate = self;
    self.activateCamouflageIconDialogView.titleText = LOC(@"would_you_activate_camouflage_icon");
    self.activateCamouflageIconDialogView.message = LOC(@"we_recommend_to_activate_camouflage_icon");
    [self addChildViewController:self.activateCamouflageIconDialogView onView:self.view];
}

#pragma mark - Actions

- (void)cancelChangePin:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmButtonAction:(UIButton *)sender
{
    if (self.isSwitchEnabled) {
        if ([self isFormCompleted]) {
            [Settings sharedInstance].userPin = self.realPinField.fieldValue;
            [Settings sharedInstance].userFakePin = self.fakePinField.fieldValue;
            [[Settings sharedInstance] activateUsingDualPin:YES];
            if ([Settings sharedInstance].isCamouflageIconEnabled) {
                UIViewController *destination = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:destination animated:YES];
            } else {
                [self.view endEditing:YES];
                [self showActivateCamouflageIconDialog];
            }
        }
    } else {
        [[Settings sharedInstance] activateUsingDualPin:NO];
        UIViewController *destination = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:destination animated:YES];
    }
}

#pragma mark - Suggest ActivatePin

- (void)showActivateCamouflageIconDialog
{
    self.activateCamouflageIconDialogView = [DialogViewController instansiateDialogViewWithType:DialogViewTypeButtonAction];
    self.activateCamouflageIconDialogView.showCancelButton = YES;
    self.activateCamouflageIconDialogView.delegate = self;
    self.activateCamouflageIconDialogView.titleText = LOC(@"would_you_activate_camouflage_icon");
    self.activateCamouflageIconDialogView.message = LOC(@"we_recommend_to_activate_camouflage_icon");
    [self addChildViewController:self.activateCamouflageIconDialogView onView:self.view];
}

#pragma mark - DialogViewDelegate

- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView
{
    if (dialogView == self.activateCamouflageIconDialogView) {
        UIStoryboard *authStoryboard = [UIStoryboard storyboardWithName:@"MoreTab" bundle:nil];
        CreateDualPinViewController *pinVC = [authStoryboard instantiateViewControllerWithIdentifier:@"ChangeApplicationIconViewController"];
        [self.navigationController pushViewController:pinVC animated:YES];
    }
}

- (void)dialogViewDidCancel:(DialogViewController *)dialogView
{
    if (dialogView == self.activateCamouflageIconDialogView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isFormCompleted
{
    if (self.realPinField.fieldValue.length != 4) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pin_length_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if (![self.realPinField.fieldValue isEqualToString:self.realPinFieldConfirm.fieldValue]) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pins_do_not_match_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if ([self.realPinField.fieldValue isEqualToString:self.fakePinField.fieldValue]) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"real_pin_fake_pin_different") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if (self.fakePinField.fieldValue.length !=4) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pin_length_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    if (![self.fakePinField.fieldValue isEqualToString:self.fakePinFieldConfirm.fieldValue]) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"pins_do_not_match_text_key") cancelButtonTitle:LOC(@"cancel") okButtonTitle:nil cancelAction:nil okAction:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - Override Parent Class methods

- (void)configureGradientBackground
{
    
}

#pragma mark - FormCellDelegate

- (void)formTableViewCell:(FormTableViewCell *)cell didChangeText:(NSString *)text
{
    NSIndexPath *indexPath = [self.formTableView indexPathForCell:cell];
    FormDataModel *formItem = [self fieldForIndexpath:indexPath];
    formItem.fieldValue = text;
    formItem.fieldDisplayValue = text;
}

- (BOOL)formCell:(FormTableViewCell *)formCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 4) {
        return NO;
    }
    return YES;
}

#pragma mark - ReEnterPinCodeViewDelegate

- (void)dialogViewDidEnterCorrectPin:(DialogViewController *)enterPincodeView
{
    [[Settings sharedInstance] activateUsingDualPin:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SwitchCellDelegate
- (void)swithActionCell:(MoreViewTableViewCell *)cell didChangeState:(BOOL)isOn
{
    SettingsViewFieldViewModel *cellData = (SettingsViewFieldViewModel *)cell.viewData;
    cellData.isStateOn = isOn;
    self.editingDisabled = !isOn;
    self.isSwitchEnabled = isOn;
}

- (void)shakeAlertView:(UIAlertController *)alertController
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
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
}

//- (void)createPinViewDidUpdatePin:(ChangePinViewController *)createPinViewController
//{
//    // TODO: handle id needed
//}

- (void)createPinViewDidCancel:(CreateDualPinViewController *)createPinViewController
{
    // TODO: handle if needed
}

#pragma mark - Actions

- (IBAction)cancelButtonAction:(SYDesignableButton *)sender {
    UIViewController *destination = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:destination animated:YES];
}


#pragma mark - Navigatin

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPinLoginViewFromCreatePin"]) {
        LoginWithPinViewController *destination = segue.destinationViewController;
        destination.isFromSignInFlow = YES;
    }
}

@end
