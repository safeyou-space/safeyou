//
//  SYTextField.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYTextField.h"
#import "Validator.h"
#import "UIColor+SyColors.h"

@interface SYTextField()

@property (nonatomic, strong) Validator *validator;

@end

@implementation SYTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
        self.rightViewMode = UITextFieldViewModeAlways;
        self.tintColor = [UIColor purpleColor1];
    }

    return self;
}

#pragma mark - Properties
- (void)setFieldType:(SYTextFieldType)fieldtype {
    
    _fieldType = fieldtype;
    
    switch (_fieldType) {
        case LTFT_EmailType:
        {
            _validator = [Validator validatorWithType:kEmailValidator];
            self.keyboardType = UIKeyboardTypeEmailAddress;
        }
            break;
        case LTFT_PhoneNumberType:
        {
            _validator = [Validator validatorWithType:kPhoneNumberValidator];
            self.keyboardType = UIKeyboardTypePhonePad;
            
        }
            break;
        case LTFT_PasswordType:
        {
            _validator = [Validator validatorWithType:kPasswordValidator];
            self.keyboardType = UIKeyboardTypeDefault;
            self.secureTextEntry = YES;
        }
            break;
        case LTFT_SMSCodeType:
        {
            _validator = [Validator validatorWithType:kSMSCodeValidator];
            self.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case LTFT_PinType:
        {
            _validator = [Validator validatorWithType:kPinValidator];
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.secureTextEntry = YES;
        }
            break;
        case LTFT_NumberType:
        {
            _validator = [Validator validatorWithType:kDefaultValidator];
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.secureTextEntry = NO;
        }
            break;
        default:
        {
            _validator = [Validator validatorWithType:kDefaultValidator];
            self.keyboardType = UIKeyboardTypeDefault;
        }
            break;
    }
}

#pragma mark - DEsignables

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self.layer setCornerRadius:_cornerRadius];
}

- (void)setBorderColorType:(NSInteger)borderColorType
{
    _borderColorType = borderColorType;
    self.layer.borderColor = [UIColor colorWithSYColor:_borderColorType alpha:1.0].CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setPlaceholderColorType:(NSInteger)placeholderColorType
{
    _placeholderColorType = placeholderColorType;
    [self configurePlaceholder];
}

- (void)setPlaceholderColorAlpha:(CGFloat)placeholderColorAlpha
{
    _placeholderColorAlpha = placeholderColorAlpha;
    [self configurePlaceholder];
}

- (void)configurePlaceholder
{
    UIColor *placeholderColor;
    if(_placeholderColorType <= SYColorTypeNone || _placeholderColorType > SYColorTypeLast) {
        placeholderColor = [UIColor whiteColor];
    } else {
        UIColor *placeholder_color = [UIColor colorWithSYColor:self.placeholderColorType alpha:self.placeholderColorAlpha];
        if(_placeholderColorAlpha == 1 || _placeholderColorAlpha == -1) {
            placeholderColor = placeholder_color;
        } else {
            placeholderColor = [UIColor getColor:placeholder_color withAlpha:_placeholderColorAlpha];
        }
    }
//    self.placeHolderColor = placeholderColor;
}

#pragma mark - Instance Methods
- (NSError *)validateValue {
    
    NSError *error = nil;
    if (_validator) {
        error = [_validator validateValue:self.text];
    }
    
    return error;
}

- (BOOL)hasInput {
    
    return self.text.length > 0;
}

@end
