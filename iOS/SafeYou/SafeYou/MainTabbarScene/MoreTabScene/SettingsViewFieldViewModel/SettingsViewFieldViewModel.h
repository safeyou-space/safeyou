//
//  SettingsViewFieldViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewFieldViewModel : NSObject

@property (nonatomic) NSString *secondaryTitle;
@property (nonatomic) NSString *mainTitle;
@property (nonatomic) NSString *fieldKey;
@property (nonatomic) NSString *iconImageName;
@property (nonatomic) BOOL isIconImageFromURL;
@property (nonatomic) NSString *iconImageUrl;
@property (nonatomic) BOOL isSecureField;
@property (nonatomic) FieldAccessoryType accessoryType;
@property (nonatomic) NSString *actionString;
@property (nonatomic) BOOL isSegue;
@property (nonatomic) BOOL isStateOn; // if type is FieldAccessoryTypeSwitch


@end

NS_ASSUME_NONNULL_END
