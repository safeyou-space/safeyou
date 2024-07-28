//
//  SelectDateField.m
//  VBET
//
//  Created by Garnik Simonyan on 7/7/15.
//  Copyright (c) 2015 BetConstruct. All rights reserved.
//

#import "SelectDateField.h"
#import "Settings.h"
#import "UIColor+SYColors.h"


@interface SelectDateField () <CustomPickerViewDelegate, UITextFieldDelegate>

@end


@implementation SelectDateField

@synthesize dateFormat = _dateFormat;

#pragma mark - override

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
    CGFloat pointSize = self.font.pointSize;
    UIFont *font = [UIFont fontWithName:@"HayRoboto-Regular" size:pointSize];
    [self setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.adjustsFontForContentSizeCategory = YES;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    NSString *dateString = @"";
    _selectedDate = selectedDate;
    [_pickerView setSelectedDate:_selectedDate];
    dateString = [self dateStringFromDate:_selectedDate withFormat:self.dateFormat];
    self.text = dateString;
}


#pragma mark - setter/getter

- (NSString *)getDateFormat
{
    if (_dateFormat) {
        return _dateFormat;
    }
    return @"MMMM-YYYY-dd";
}

- (void)setDateFormat:(NSString *)dateFormat
{
    _dateFormat = dateFormat;
}

- (void)setMaxDate:(NSDate *)maxDate
{
    _maxDate = maxDate;
    self.pickerView.maxDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate
{
    _minDate = minDate;
    self.pickerView.minDate = minDate;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self.pickerView setSelectedDate:date];
}

#pragma mark - private

- (NSString*)dateStringFromDate:(NSDate *)date withFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:format];
    NSString* dte=[dateFormatter stringFromDate:date];
    return dte;
}

#pragma mark - customize views

- (void)setupDatePickerView
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setValue:[UIColor blackColor] forKey:@"textColor"];

    datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    datePicker.datePickerMode = UIDatePickerModeDate;

    [datePicker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300);
    self.inputView = datePicker;
    self.inputAccessoryView = datePicker.inputAccessoryView;

        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 50)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButtonClick)]];
        [toolbar sizeToFit];
//        [self.view addSubview:toolbar];
}

- (void)setupPickerView
{
    //@TODO: make with custom and color with IBInspactable proporties
    _pickerView = [[CustomPickerView alloc]
                   initDatePickerWithPickerMode:_datePickerMode
                   WithSelectedDate:self.date
                   maxDate:_maxDate
                   minDate:_minDate
                   withReturnKey:_returnButtonTitle
                   withWidth: [UIScreen mainScreen].bounds.size.width
                   withCustomColor:YES
                   customColor: [UIColor lightGrayColor]];
    _pickerView.clipsToBounds = NO;
    _pickerView.delegate = self;
    self.inputView = _pickerView;
    self.inputAccessoryView = _pickerView.inputAccessoryView;
    UITextInputAssistantItem *item = [self inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
}

- (void)dueDateChanged:(UIDatePicker *)picker
{

}

#pragma mark - CustomPickerViewDelegates

- (void)customPickerView:(CustomPickerView *)customPickerView datePickerValueChanged:(NSDate*)date
{
    self.selectedDate = date;
    if ([self.dateFieldDelegate respondsToSelector:@selector(selectDateFieldValueChanged:)]) {
        [self.dateFieldDelegate selectDateFieldValueChanged:self];
    }
}

- (void)customPickerViewDoneButtonPressed:(id)customPickerView
{
    if ([self.dateFieldDelegate respondsToSelector:@selector(dateFiledShouldReturn:)]) {
        [self.dateFieldDelegate dateFiledShouldReturn:self];
    }
}

#pragma mark - UITexFieldDelegate
- (void)textFieldDidBeginEditing:(SelectDateField *)dateField
{
    self.selectedDate = self.pickerView.datePicker.date;
    if ([self.dateFieldDelegate respondsToSelector:@selector(selectDateTextFieldDidBeginEditing:)]) {
        [self.dateFieldDelegate selectDateTextFieldDidBeginEditing:dateField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // this field can take values only from date picker
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // this field can take values only from date picker
    return NO;
}

@end
