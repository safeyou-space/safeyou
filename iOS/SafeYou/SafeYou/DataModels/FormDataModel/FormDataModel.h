//
//  FormDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormFieldDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormDataModel : NSObject

/*
 {
 "type":1,
 "field_type": "text",
 "field_title": "First name",
 "field_placeholder": "First name placeholder",
 "field_default_value": "Default value",
 "field_user_provided_value": "Filled value",
 "field_info_text": "This is text about this field",
 "field_service_key" : "backend_service_key"
 },
 */

@property (nonatomic) FormFieldType type;
@property (nonatomic) FormFieldDataType dataType;
@property (nonatomic) BOOL isRequired;
@property (nonatomic) NSString *fieldTitle;
@property (nonatomic) NSString *fieldPlaceholder;
@property (nonatomic) NSString *fieldDefaultValue;
@property (nonatomic) NSString *fieldValue;
@property (nonatomic) NSString *fieldDisplayValue;
@property (nonatomic) NSString *fieldServiceKey;
@property (nonatomic) NSString *fieldInfoText;
@property (nonatomic) NSString *errorTextString;
@property (nonatomic) NSString *inputRegex;
@property (nonatomic) NSString *validationRegex;

@property (nonatomic) NSInteger inputLength;

@property (nonatomic, strong) NSString *cellDataKey;

@property (nonatomic, getter=fieldBackendValue) NSString *fieldBackendValue;

// for adjustments
@property (nonatomic) BOOL adjustmentValue;
@property (nonatomic, readonly) BOOL isAdjustmentValueSet;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresantaion;

- (instancetype)initWithFieldType:(FormFieldType)fieldType dataType:(FormFieldDataType)fieldDataType title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value isRequired:(BOOL)isRequired;

- (BOOL)isValidWithRegex;

@end

NS_ASSUME_NONNULL_END
