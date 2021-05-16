//
//  ProfileViewFieldViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewFieldViewModel : NSObject

@property (nonatomic) NSString *fieldName;
@property (nonatomic) NSString *fieldTitle;
@property (nonatomic) NSString *fieldValue;
@property (nonatomic) NSString *fieldKey;
@property (nonatomic) NSString *iconImageName;
@property (nonatomic) BOOL isSecureField;
@property (nonatomic) FieldAccessoryType accessoryType;
@property (nonatomic) NSString *actionString;
@property (nonatomic) BOOL isStateOn;; // if type is FieldAccessoryTypeSwitch


@end

NS_ASSUME_NONNULL_END
