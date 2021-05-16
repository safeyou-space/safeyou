//
//  FormDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "FormDataModel.h"

@implementation FormDataModel

- (instancetype)initWithFieldType:(FormFieldType)fieldType dataType:(FormFieldDataType)fieldDataType title:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value isRequired:(BOOL)isRequired
{
    self = [super init];
    
    if (self) {
        self.type = fieldType;
        self.dataType = fieldDataType;
        self.fieldTitle = title;
        self.fieldPlaceholder = placeholder;
        self.fieldValue = value;
        self.isRequired = isRequired;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    // TODO Implement
    return nil;
}

- (NSDictionary *)dictionaryRepresantaion
{
    return @{};
}

#pragma mark - Validation

- (BOOL)isValidWithRegex
{
    if (self.validationRegex && self.validationRegex.length > 0) {
        NSPredicate *validationPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.validationRegex];
        
        return [validationPredicate evaluateWithObject:self.fieldValue];
    } else {
        return self.fieldValue.length > 0;
    }
    
    return YES;
}


@end
