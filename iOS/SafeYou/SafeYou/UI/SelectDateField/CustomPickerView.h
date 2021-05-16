//
//  CustomPickerView.h
//  Fantasy
//
//  Created by Gevorg Karapetyan on 7/3/15.
//  Copyright (c) 2015 BetConstruct. All rights reserved.
//

#import "SYUIKit.h"

typedef enum {
    DATE_PICKER_TYPE = 0,
    PICKER_VIEW_TYPE = 1
} PickerTypes;

@class CustomPickerView;

@protocol CustomPickerViewDelegate <NSObject>

@optional

- (void)customPickerViewDoneButtonPressed:(id)customPickerView;
- (void)customPickerView:(CustomPickerView *)customPickerView datePickerValueChanged:(NSDate*)date;
- (void)customPickerView:(CustomPickerView *)customPickerView pickerViewDidSelectItem:(NSString*)selectedItem;

@end


@interface CustomPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *returnKeyTitle;

@property (nonatomic, weak) id<CustomPickerViewDelegate> delegate;
@property (readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;

//- (id)initDatePickerWithSelectedDate:(NSDate*)selectedDate maxDate:(NSDate *)maxDate minDate:(NSDate*)minDate withReturnKey:(NSString*)returnKeyTitle withWidth:(CGFloat)width withCustomColor:(BOOL)isCustomColor customColor:(UIColor*)customColor;
- (id)initDatePickerWithPickerMode:(UIDatePickerMode)datePickerMode
                  WithSelectedDate:(NSDate *)selectedDate
                           maxDate:(NSDate *)maxDate
                           minDate:(NSDate *)minDate
                     withReturnKey:(NSString *)returnKeyTitle
                         withWidth:(CGFloat)width
                   withCustomColor:(BOOL)isCustomColor
                       customColor:(UIColor *)customColor;

- (void)selectDataPicker:(NSDate *)selectedDate;
- (id)initPickerViewWithContent:(NSArray *)content
               withSelectedItem:(id)item
                  withReturnKey:(NSString *)returnKeyTitle
                      withWidth:(CGFloat)width
                withCustomColor:(BOOL)isCustomColor
                    customColor:(UIColor*)customColor;

- (void)updatePickerViewContent:(NSArray*)content;
- (void)selectPickerItem:(id)item;
- (void)setSelectedDate:(NSDate *)selectedDate;

- (void)createPicker;

@end
