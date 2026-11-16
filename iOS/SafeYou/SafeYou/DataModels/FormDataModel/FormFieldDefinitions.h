//
//  FormFieldDefinitions.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#ifndef FormFieldDefinitions_h
#define FormFieldDefinitions_h

typedef NS_ENUM(NSInteger, FormFieldType) {
    FormFieldTypeNone,                    // 0
    FormFieldTypeText,                    // 1
    FormFieldTypeLargeText,               // 2
    FormFieldTypePassword,                // 3
    FormFieldTypeEmail,                   // 4
    FormFieldTypeNumber,                  // 5
    FormFieldTypePhoneNumber,             // 6
    FormFieldTypePicker,                  // 7
    FormFieldTypeChooseOption,            // 8
    FormFieldTypeAction,                  // 9
    FormFieldTypeSwitch,                  // 10
    FormFieldTypeAdjustment,              // 11
    FormFieldTypeAll                      // 12
    
};

typedef NS_ENUM(NSInteger, FormFieldDataType) {
    FormFieldDataTypeNone,            // 0
    FormFieldDataTypeText,            // 1
    FormFieldDataTypePassword,        // 2
    FormFieldDataTypeEmail,           // 3
    FormFieldDataTypeNumber,          // 4
    FormFieldDataTypePhoneNumber,     // 5
    FormFieldDataTypeBoolean,         // 6
    FormFieldDataTypePasswordConfirm, // 7
    FormFieldDataTypeChooseOption,    // 8
    FormFieldDataTypeInfo,    // 8
    FormFieldDataTypeAll              // 9
};


#endif /* FormFieldDefinitions_h */
