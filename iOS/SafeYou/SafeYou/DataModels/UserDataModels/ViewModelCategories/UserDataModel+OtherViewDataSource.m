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
#import "ProfileQuestionsAnswersDataModel.h"

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
    
    ProfileViewFieldViewModel *userIdField = [[ProfileViewFieldViewModel alloc] init];
    
    userIdField.fieldName =  @"userId";
    userIdField.fieldTitle = LOC(@"user_id");
    userIdField.fieldValue = self.uId;
    userIdField.isSecureField = NO;
    userIdField.accessoryType = FieldAccessoryTypeEdit;
    userIdField.actionString = @"edit";
    
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
    
    NSMutableArray *fieldList = [NSMutableArray arrayWithArray:@[avatarField, nickNameField, userIdField, firstNameField, lastNameField, maritalStatusField, mobileNumberField]];
    
    NSDictionary<NSString *, QuestionsAnswersDataModel *> *profileAnswers = self.profileQuestionsAnswers.answers;

    for(id key in profileAnswers) {
        if(![key isEqualToString:@"specify_settlement_type"] && ![[Settings sharedInstance].selectedCountryCode isEqualToString:@"irq"]) {
            
            ProfileViewFieldViewModel *locationField = [[ProfileViewFieldViewModel alloc] init];
            NSString *actionString = @"chooseChildrenCount";
            NSInteger fieldAccessoryTypeValue = FieldAccessoryTypeEditInNewPage;
            FieldAccessoryType fieldAccessoryType = (FieldAccessoryType)fieldAccessoryTypeValue;
            
            QuestionsAnswersDataModel *dataModel = profileAnswers[key];
            NSString *answer = dataModel.answer;
            
            if([dataModel.questionType isEqualToString:@"basic"]) {
                if ([key isEqualToString:@"do_you_have_children"]) {
                    fieldAccessoryType = FieldAccessoryTypeEditInNewPage;
                    actionString = @"chooseChildrenCount";
                } else {
                    fieldAccessoryType = FieldAccessoryTypeArrow;
                    actionString = @"chooseCurrentOcupation";
                }
            }
            else {
                actionString = @"chooseRegion";
            }
            
            locationField.fieldName =  key;
            locationField.fieldTitle = LOC(key);
            locationField.fieldValue = answer;
            locationField.isSecureField = NO;
            locationField.accessoryType = fieldAccessoryType;
            locationField.actionString = actionString;
            
            [fieldList addObject: locationField];
        }
    }
    NSArray *immutableArray = [fieldList copy];
   
    return immutableArray;
}

@end
