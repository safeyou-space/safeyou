//
//  SelectDateField.h
//  VBET
//
//  Created by Garnik Simonyan on 7/7/15.
//  Copyright (c) 2015 BetConstruct. All rights reserved.
//

#import "SYTextField.h"
#import "CustomPickerView.h"

IB_DESIGNABLE

@class SelectDateField;

@protocol DateFieldDelegate <NSObject>

@optional

- (void)selectDateTextFieldDidBeginEditing:(SelectDateField *)dateField;
- (void)selectDateFieldValueChanged:(SelectDateField *)dateField;
- (void)dateFiledShouldReturn:(SelectDateField *)dateField;

@end

@interface SelectDateField : SYTextField

@property (nonatomic, strong) CustomPickerView *pickerView;

@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong, getter=getDateFormat) NSString *dateFormat;

@property (nonatomic) CGFloat width;

@property (nonatomic, strong) IBInspectable NSString *returnButtonTitle;
@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, weak) IBOutlet id<DateFieldDelegate> dateFieldDelegate;

- (void)setupPickerView;

@end
