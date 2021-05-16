//
//  FormTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYUIKit.h"
#import "FormFieldDefinitions.h"
#import "UIColor+SYColors.h"

NS_ASSUME_NONNULL_BEGIN

@class FormTableViewCell;

@protocol FormTableViewCellDelegate <NSObject>

- (void)formTableViewCell:(FormTableViewCell *)cell didChangeText:(NSString *)text;
- (void)formTableViewCellShouldRetrun:(FormTableViewCell *)formCell returnKeyType:(UIReturnKeyType)returnKeyType;

@optional

- (BOOL)formCell:(FormTableViewCell *)formCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

@interface FormTableViewCell : UITableViewCell

- (void)configureWithFieldType:(FormFieldType)fieldType dataType:(FormFieldDataType)fieldDataType title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value isRequired:(BOOL)isRequired;

- (void)configureWithFieldType:(FormFieldType)fieldType dataType:(FormFieldDataType)fieldDataType title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value regex:(NSString *)regex isRequired:(BOOL)isRequired returnType:(UIReturnKeyType)returnKeyType;

- (void)resetCell;

@property (nonatomic) NSInteger inputLength;
@property (nonatomic, weak) id<FormTableViewCellDelegate> formCellDelegate;
@property (nonatomic) SYColorType eyeIconTintColorType;

@end

NS_ASSUME_NONNULL_END
