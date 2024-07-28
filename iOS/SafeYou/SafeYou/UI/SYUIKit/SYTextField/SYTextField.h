//
//  SYTextField.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SYTextFieldType) {
    LTFT_DefaultType,
    LTFT_EmailType,
    LTFT_PhoneNumberType,
    LTFT_LoginType,
    LTFT_PasswordType,
    LTFT_SMSCodeType,
    LTFT_PinType,
    LTFT_NumberType
};

IB_DESIGNABLE

@interface SYTextField : UITextField

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable NSInteger borderColorType;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable NSInteger placeholderColorType;
@property (nonatomic) IBInspectable CGFloat placeholderColorAlpha;

@property (nonatomic, assign) SYTextFieldType fieldType;

#pragma mark - Instance Methods
- (NSError *)validateValue;
- (BOOL)hasInput;

@end
