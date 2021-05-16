//
//  UserDataModel+OtherViewDataSource.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UserDataModel+OtherViewDataSource.h"
#import "ProfileViewFieldViewModel.h"
#import "ImageDataModel.h"

@implementation UserDataModel (OtherViewDataSource)

- (NSArray <ProfileViewFieldViewModel *>*)othersViewDataSource
{
    
    ProfileViewFieldViewModel *avatarField = [[ProfileViewFieldViewModel alloc] init];
    
    avatarField.fieldName =  @"image";
    avatarField.fieldTitle = LOC(@"profile_picture_title_key");
    avatarField.fieldValue = self.image.url;
    avatarField.isSecureField = NO;
    avatarField.accessoryType = FieldAccessoryTypeAvatar;
    avatarField.actionString = @"avatar";
    
    ProfileViewFieldViewModel *nickNameField = [[ProfileViewFieldViewModel alloc] init];
    
    nickNameField.fieldName =  @"nickname";
    nickNameField.fieldTitle = LOC(@"nickname_placeholder");
    nickNameField.fieldValue = self.nickname;
    nickNameField.isSecureField = NO;
    nickNameField.accessoryType = FieldAccessoryTypeEdit;
    nickNameField.actionString = @"edit";
    
    ProfileViewFieldViewModel *firstNameField = [[ProfileViewFieldViewModel alloc] init];
    
    firstNameField.fieldName =  @"first_name";
    firstNameField.fieldTitle = LOC(@"first_name_title_key");
    firstNameField.fieldValue = self.firstName;
    firstNameField.isSecureField = NO;
    firstNameField.accessoryType = FieldAccessoryTypeEdit;
    firstNameField.actionString = @"edit";
    
    ProfileViewFieldViewModel *lastNameField = [[ProfileViewFieldViewModel alloc] init];
    
    lastNameField.fieldName =  @"last_name";
    lastNameField.fieldTitle = LOC(@"last_name_title_key");
    lastNameField.fieldValue = self.lastName;
    lastNameField.isSecureField = NO;
    lastNameField.accessoryType = FieldAccessoryTypeEdit;
    lastNameField.actionString = @"edit";
    
    ProfileViewFieldViewModel *maritalStatusField = [[ProfileViewFieldViewModel alloc] init];
    
    maritalStatusField.fieldName =  @"marital_status";
    maritalStatusField.fieldTitle = LOC(@"marital_status_text_key");
    maritalStatusField.fieldValue = self.maritalStatus;
    maritalStatusField.isSecureField = NO;
    maritalStatusField.accessoryType = FieldAccessoryTypeArrow;
    maritalStatusField.actionString = @"chooseMaritalStatus";
    
    ProfileViewFieldViewModel *mobileNumberField = [[ProfileViewFieldViewModel alloc] init];
    
    mobileNumberField.fieldName =  @"phone";
    mobileNumberField.fieldTitle = LOC(@"mobile_number_text_key");
    mobileNumberField.fieldValue = self.phone;
    mobileNumberField.isSecureField = NO;
    mobileNumberField.accessoryType = FieldAccessoryTypeEdit;
    mobileNumberField.actionString = @"edit";
    
    NSArray *fieldList = @[avatarField, nickNameField,firstNameField, lastNameField, maritalStatusField, mobileNumberField];
    return fieldList;
}

@end
