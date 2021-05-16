//
//  CustomPickerView.m
//  Fantasy
//
//  Created by Gevorg Karapetyan on 7/3/15.
//  Copyright (c) 2015 BetConstruct. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView()
{

}

@property (nonatomic) PickerTypes pickerTypes;

@property (nonatomic, strong) NSArray *content;


@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) id selectedItem;

@property (nonatomic) CGFloat width;

@property (nonatomic) BOOL isCustomColor;
@property (nonatomic, strong) UIColor *customColor;

@property (nonatomic) UIDatePickerMode datePickerMode;

@end

@implementation CustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initDatePickerWithPickerMode:(UIDatePickerMode)datePickerMode
                  WithSelectedDate:(NSDate *)selectedDate
                           maxDate:(NSDate *)maxDate
                           minDate:(NSDate *)minDate
                     withReturnKey:(NSString *)returnKeyTitle
                         withWidth:(CGFloat)width
                   withCustomColor:(BOOL)isCustomColor
                       customColor:(UIColor *)customColor
{
    self = [super init];
    if(self) {
        _pickerTypes = DATE_PICKER_TYPE;
        _selectedDate = selectedDate;
        _returnKeyTitle = returnKeyTitle;
        _width = width;
        _isCustomColor = isCustomColor;
        _customColor = customColor;
        _datePickerMode = datePickerMode;
        [self createPicker];
        self.maxDate = maxDate;
        self.minDate = minDate;
    }
    
    return self;
}

- (void)layoutSubviews
{
    if(_pickerTypes == DATE_PICKER_TYPE) {
        if(_isCustomColor && _datePicker) {
            [_datePicker setBackgroundColor:_customColor];
        }
    } else if(_pickerTypes == PICKER_VIEW_TYPE) {
        if(_isCustomColor && _pickerView) {
            [_pickerView setBackgroundColor:_customColor];
        }
    }
}

- (void)selectDataPicker:(NSDate*)selectedDate
{
    if(selectedDate) {
        _selectedDate = selectedDate;
        if(_selectedDate) {
            [_datePicker setDate:_selectedDate];
        }
    }
}


- (id)initPickerViewWithContent:(NSArray*)content withSelectedItem:(id)item withReturnKey:(NSString*)returnKeyTitle withWidth:(CGFloat)width withCustomColor:(BOOL)isCustomColor customColor:(UIColor*)customColor;
{
    self = [super init];
    if(self) {
        _pickerTypes = PICKER_VIEW_TYPE;
        _content = content;
        _selectedItem = item;
        _returnKeyTitle = returnKeyTitle;
        _width = width;
        _isCustomColor = isCustomColor;
        _customColor = customColor;
        [self createPicker];
    }

    return self;
}

- (void)updatePickerViewContent:(NSArray*)content
{
    _content = content;
    [_pickerView reloadAllComponents];
}

- (void)selectPickerItem:(id)item
{
    if(item) {
        _selectedItem = item;
        NSInteger row = [_content indexOfObject:_selectedItem];
        if(NSNotFound != row) {
            [_pickerView selectRow:row inComponent:0 animated:NO];
        }
    }
}

- (void)setMinDate:(NSDate *)minDate
{
    _minDate = minDate;
    _datePicker.minimumDate = _minDate;
}

- (void)setMaxDate:(NSDate *)maxDate
{
    _maxDate = maxDate;
    _datePicker.maximumDate = _maxDate;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
}

- (void)createPicker
{
    if(_pickerTypes == DATE_PICKER_TYPE) {
        _datePicker = [[UIDatePicker alloc] init];
        if(_isCustomColor) {
            [_datePicker setBackgroundColor:_customColor];
        }
        _datePicker.datePickerMode = _datePickerMode;
        [self changeDatePickerDesign:_datePicker];
        _datePicker.maximumDate = _maxDate;
        _datePicker.minimumDate = _minDate;
        if(_selectedDate) {
            [_datePicker setDate:_selectedDate];
        } else {
            [_datePicker setDate:[NSDate date]];
        }
        [_datePicker becomeFirstResponder];
        [_datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
        [_datePicker setFrame:CGRectMake(0, 0, _width, _datePicker.frame.size.height)];
        self.frame = _datePicker.frame;
        [self addSubview:_datePicker];
    } else if(_pickerTypes == PICKER_VIEW_TYPE) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        if(_isCustomColor) {
            [_pickerView setBackgroundColor:_customColor];
        }
        NSInteger row = [_content indexOfObject:_selectedItem];
        if(NSNotFound != row) {
            [_pickerView selectRow:row inComponent:0 animated:NO];
        }
        [_pickerView setFrame:CGRectMake(0, 0, _width, _pickerView.frame.size.height)];
        self.frame = _pickerView.frame;
         [self addSubview:_pickerView];
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc] init];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:_returnKeyTitle style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPrressed)],
                           nil];
    UIColor *tintColor;
    UIColor *barTintColor;
    if(_isCustomColor) {
        tintColor = [UIColor mainTintColor1];
        barTintColor = _customColor;
    } else {
        tintColor = [UIColor blackColor];
        if(_datePicker) {
            barTintColor = [_datePicker backgroundColor];
        } else if(_pickerView) {
            barTintColor = [_pickerView backgroundColor];
        }
    }

    numberToolbar.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    [numberToolbar setTintColor:tintColor];
    [numberToolbar setBarTintColor:barTintColor];
    numberToolbar.backgroundColor = [UIColor redColor];
    [numberToolbar sizeToFit];
//    _inputAccessoryView = numberToolbar;
    [self addSubview:numberToolbar];
}

- (void)doneButtonPrressed
{
    if(_pickerTypes == PICKER_VIEW_TYPE) {
        if(!_selectedItem) {
            if([_content count]) {
                _selectedItem = [_content objectAtIndex:0];
                if([_delegate respondsToSelector:@selector(customPickerView:pickerViewDidSelectItem:)]) {
                    [_delegate customPickerView:self pickerViewDidSelectItem:_selectedItem];
                }
            }
        }
    } else {
        if (!_selectedDate) {
            _selectedDate = _datePicker.maximumDate;
            if([_delegate respondsToSelector:@selector(customPickerView:datePickerValueChanged:)]) {
                [_delegate customPickerView:self datePickerValueChanged:_selectedDate];
            }
//            [self pickerChanged:_datePicker];
        }
    }
    if([_delegate respondsToSelector:@selector(customPickerViewDoneButtonPressed:)]) {
        [_delegate customPickerViewDoneButtonPressed:self];
    }
}

// for changing design
- (void)changeDatePickerDesign:(id)picker
{
    if(_isCustomColor) {

        [picker setValue:[UIColor grayColor] forKeyPath:@"textColor"];
        [picker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
        if ([picker isKindOfClass:[UIDatePicker class]]) {
            if (@available(iOS 13.4, *)) {
                ((UIDatePicker *)picker).preferredDatePickerStyle = UIDatePickerStyleWheels;
            } else {
                // Fallback on earlier versions
            }
        }
        
        SEL selector = NSSelectorFromString( @"setHighlightsToday:" );
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
        BOOL no = NO;
        [invocation setSelector:selector];
        [invocation setArgument:&no atIndex:2];
        [invocation invokeWithTarget:picker];
    }
}

#pragma mark - Date Picker Value Changed
- (void)pickerChanged:(id)sender
{
    _selectedDate = [sender date];
    if([_delegate respondsToSelector:@selector(customPickerView:datePickerValueChanged:)]) {
        [_delegate customPickerView:self datePickerValueChanged:_selectedDate];
    }
}

#pragma mark -

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedItem = [_content objectAtIndex:row];
    if([_delegate respondsToSelector:@selector(customPickerView:pickerViewDidSelectItem:)]) {
        [_delegate customPickerView:self pickerViewDidSelectItem:_selectedItem];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_content count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [_content objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    return attString;
}


@end
