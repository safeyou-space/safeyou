//
//  MoreViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyProfileSectionViewModel.h"
#import "ProfileViewFieldViewModel.h"
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
#import "CreateDualPinViewController.h"
#import "AvatarTableViewCell.h"
#import "ProfileViewFieldViewModel.h"
#import "ImageDataModel.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, TableViewCellActionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SYDesignableBarButtonItem *cancelEditingBarButtonItem;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@property (nonatomic) MyProfileSectionViewModel *dataSource;
@property (nonatomic) SYProfileService *profileService;
@property (nonatomic) SYAuthenticationService *maritalStatusService;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIImagePickerControllerSourceType imagePickerSourceType;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) AvatarTableViewCell *avatarCell;

@property (nonatomic) NSArray *maritalStatusList;

@end

@implementation ProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileService = [[SYProfileService alloc] init];
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        [self configureDataSource];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchMeritalStatusData];
    
    UINib *switchCellNib = [UINib nibWithNibName:@"SwitchActionTableViewCell" bundle:nil];
    [self.tableView registerNib:switchCellNib forCellReuseIdentifier:@"SwitchActionTableViewCell"];
    
    UINib *avatarCellNib = [UINib nibWithNibName:@"AvatarTableViewCell" bundle:nil];
    [self.tableView registerNib:avatarCellNib forCellReuseIdentifier:@"AvatarTableViewCell"];
    
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
    [self.tableView reloadData];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Override

- (void)updateLocalizations
{
    self.navigationItem.title = LOC(@"profile_title_key");
    [self refreshUserData:NO];
    [self configureDataSource];
    [self fetchMeritalStatusData];
    [self.tableView reloadData];
}

#pragma mark - DataSource

- (void)configureDataSource
{
    NSArray *sectionOneDataSource = [[Settings sharedInstance].onlineUser othersViewDataSource];
    
    MyProfileSectionViewModel *sectionOneData = [[MyProfileSectionViewModel alloc] initWithRows:sectionOneDataSource];
    self.dataSource = sectionOneData;
    [self.tableView reloadData];
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

- (void)showSelectMaritalStatus:(NSIndexPath *)indexPath
{
    weakify(self)
    NSArray *statusValues = [self.maritalStatusList valueForKeyPath:@"maritalStatusType"];
    NSArray *statusNamesArray = [self.maritalStatusList valueForKeyPath:@"localizedName"];
    
    __block UserDataFieldCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    ProfileViewFieldViewModel *selectedField = selectedCell.fieldData;
    
    
    NSString *selectedOptionName = selectedField.fieldValue;
    ChooseOptionsViewController *chooseOptionController = [ChooseOptionsViewController instantiateChooseOptionController];
    chooseOptionController.chooseOptionType = SYChooseOptionTypeRadio;
    chooseOptionController.optionsArray = [statusNamesArray mutableCopy];
    chooseOptionController.optionTitle = LOC(@"select_marital_status_text_key");
    chooseOptionController.selectedOptionName = selectedOptionName;
    chooseOptionController.selectionBlock = ^(NSInteger selectedIndex) {
         strongify(self)
         NSLog(@"Selected index %@", @(selectedIndex));
         selectedField.fieldValue = statusNamesArray[selectedIndex];
         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self showLoader];
        weakify(self);
        
        NSString *value = statusValues[selectedIndex];
        [self.profileService updateUserDataField:selectedField.fieldName value:value withComplition:^(id response) {
            strongify(self);
            [self doneEditing];
            [self hideLoader];
            [self refreshUserData:YES];
        } failure:^(NSError *error) {
            strongify(self);
            [self hideLoader];
            [self doneEditing];
            [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"something_went_wrong_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
        }];
    };
    [self.navigationController pushViewController:chooseOptionController animated:YES];
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

#pragma mark - Edit cell delegate
- (void)actionCellDidPressEditButton:(id <MyProfileCellInterface>)cell
{
    ProfileViewFieldViewModel *selectedField = cell.fieldData;
    if (selectedField.accessoryType == FieldAccessoryTypeAvatar) {
        // show change password view
        self.avatarCell = (AvatarTableViewCell *)cell;
        [self showUpdatePhotoAlert];
    } else {
        [self showCancelButton:YES];
        [cell becomeFirstResponder];
    }
}

- (void)actionCellDidPressSaveButton:(UserDataFieldCell *)cell withValue:(NSString *)value
{
    ProfileViewFieldViewModel *selectedField = cell.fieldData;
    if (!(selectedField.fieldValue.length > 0)) {
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"value_can_not_be_empty_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
        return;
    }
    
    [self showLoader];
    weakify(self);
    
    [self.profileService updateUserDataField:selectedField.fieldName value:selectedField.fieldValue withComplition:^(id response) {
        strongify(self);
        [self hideLoader];
        [self doneEditing];
        if ([selectedField.fieldName isEqualToString:@"phone"]) {
            [self showVerifyPhoneFlow:selectedField.fieldValue];
        } else {
            [self refreshUserData:YES];
        }
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoader];
        [self doneEditing];
    }];
}


#pragma - mark  Change Phone Number Flow
- (void)showVerifyPhoneFlow:(NSString *)newPhoneNumber
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    VerifyPhoneNumberViewController *verifyVC = [storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneNumberViewController"];
    verifyVC.isFromEditPhoneNumber = YES;
    verifyVC.phoneNumber = newPhoneNumber;
    [self presentViewController:verifyVC animated:YES completion:nil];
}


#pragma mark - User Data

- (void)refreshUserData:(BOOL)withLoader
{
    weakify(self);
    if (!withLoader) {
        [self hideLoader];
    }
    [self.profileService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        [self configureDataSource];
        [self hideLoader];
    } failure:^(NSError *error) {
        strongify(self);
        NSLog(@"Error");
        [self hideLoader];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // handle selection
    if (indexPath.section == 1) {
        // show choose language
        UserDataFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ProfileViewFieldViewModel *fieldData = cell.fieldData;
        if ([fieldData.actionString isEqualToString:@"changeAppLanguage"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            ChooseLanguageVC *chooseLanguageVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseLanguageVC"];
//            [self presentViewController:chooseLanguageVC animated:YES completion:nil];
        }
    } else {
        UserDataFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ProfileViewFieldViewModel *fieldData = cell.fieldData;
        if ([fieldData.actionString isEqualToString:@"chooseMaritalStatus"]) {
            [self showSelectMaritalStatus:indexPath];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewFieldViewModel *viewData = self.dataSource.sectionDataSource[indexPath.row];
    if (viewData.accessoryType == FieldAccessoryTypeAvatar) {
        return 117;
    }
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.sectionDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell <MyProfileCellInterface> *cell;
    
    ProfileViewFieldViewModel *rowData = self.dataSource.sectionDataSource[indexPath.row];
    NSString *cellIdentifier = @"UserDataFieldCell";
    if (rowData.accessoryType == FieldAccessoryTypeArrow) {
        cellIdentifier = @"OtherViewLanguageCell";
    } else if (rowData.accessoryType == FieldAccessoryTypeSwitch) {
        cellIdentifier = @"SwitchActionTableViewCell";
    } else if (rowData.accessoryType == FieldAccessoryTypeAvatar) {
        cellIdentifier = @"AvatarTableViewCell";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    [cell configureCellWithViewModelData:rowData];
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


#pragma mark - Functionality

- (void)doneEditing
{
    [self.tableView resignFirstResponder];
    self.avatarCell = nil;
    [self.cancelEditingBarButtonItem setTitle:@""];
    self.cancelEditingBarButtonItem.enabled = NO;
    [self configureDataSource];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

#pragma mark - Avatart functionality

- (void)showUpdatePhotoAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOC(@"choose_photo_title") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *newPhotoAction = [UIAlertAction
                                     actionWithTitle:LOC(@"take_photo_title_key")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"New photo");
                                         self.imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
                                         [self showImagePicker];
                                     }];
    [alertController addAction:newPhotoAction];
    
    [newPhotoAction setValue:[UIColor mainTintColor1] forKey:@"titleTextColor"];
    
    UIAlertAction *photoFromGalleryAction = [UIAlertAction
                                             actionWithTitle:LOC(@"choose_from_gallery_title_key")
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action)
                                             {
                                                 self.imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                 [self showImagePicker];
                                                 NSLog(@"Photo From Gallery");
                                                 
                                             }];
    [photoFromGalleryAction setValue:[UIColor mainTintColor1] forKey:@"titleTextColor"];
    [alertController addAction:photoFromGalleryAction];
    
    UIAlertAction *removePhotoAction = [UIAlertAction
                                        actionWithTitle:LOC(@"remove_photo_title_key")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            [self removeUserAvatar];
                                            // @TODO: discuss functionality
                                            NSLog(@"Remove Photo");
                                            
                                        }];
    [removePhotoAction setValue:[UIColor mainTintColor1] forKey:@"titleTextColor"];
    [alertController addAction:removePhotoAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:LOC(@"cancel")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
        [self doneEditing];
        NSLog(@"Cancel action");
        
    }];
    [alertController addAction:cancelAction];
    [cancelAction setValue:[UIColor mainTintColor1] forKey:@"titleTextColor"];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)removeUserAvatar
{
    [self showLoader];
    weakify(self);
    [self.profileService removeUserAvatarComplition:^(id response) {
       strongify(self)
        [self hideLoader];
        [self refreshUserData:YES];
    } failure:^(NSError *error) {
        strongify(self)
        [self hideLoader];
    }];
}

- (void)updateUserAvatar
{
    if (self.selectedImage) {
        weakify(self);
        [self showLoader];
        [self.profileService uploadUserAvatar:self.selectedImage params:nil withComplition:^(id response) {
//            [self.avatarCell updatePhotoWithLocalmage:self.selectedImage];
            NSLog(@"Uploaded");
            strongify(self);
            [self hideLoader];
        } failure:^(NSError *error) {
            [self hideLoader];
            self.selectedImage = nil;
            NSLog(@"Avatar update error");
        }];
    }
}

#pragma mark - Image Picker

- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:self.imagePickerSourceType]) {
        self.imagePickerController.sourceType = self.imagePickerSourceType;
        [self presentViewController:self.imagePickerController animated:YES completion:^{
            
        }];
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    // handle picked image
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image  = info[UIImagePickerControllerOriginalImage];
        self.selectedImage = image;
        [self updateUserAvatar];
        [self.avatarCell updatePhotoWithLocalmage:self.selectedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // handle cancel
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Actions

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self doneEditing];
}
@end
