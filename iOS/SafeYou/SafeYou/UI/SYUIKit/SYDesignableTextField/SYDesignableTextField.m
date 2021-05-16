//
//  SYDesignableTextField.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableTextField.h"
#import "UIColor+SYColors.h"
#import "SYDesignableView.h"

#define BOTTOM_LINE_VIEW_TAG 15151

static void *BackgroundContext = &BackgroundContext;
static void *LeftViewContext = &LeftViewContext;
static void *RightViewContext = &RightViewContext;

@interface SYDesignableTextField () <UITextFieldDelegate>

@property (nonatomic) CGFloat textFontSize;

@property (nonatomic) NSMutableSet *observerKeyPaths;

@end

@implementation SYDesignableTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _placeholderColorAlpha = -1;
        self.textColorTypeAlpha = 1;
        self.lineColorTypeAlpha = 1;
        self.selectedLineColorTypeAlpha = 1;
        [self configureBackgroundObserving];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderColorAlpha = -1;
        self.textColorTypeAlpha = 1;
        self.lineColorTypeAlpha = 1;
        self.selectedLineColorTypeAlpha = 1;
        [self configureBackgroundObserving];
    }
    return self;
}

- (void)dealloc
{
    [self removeAllObservers];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)prepareForInterfaceBuilder
{
    [self setupUI];
}

#pragma mark - Overridden methods

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x += _leftSpace;
    rect.size.width -= (_leftSpace + self.rightSpace);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x += _leftSpace;
    rect.size.width -= (_leftSpace + self.rightSpace);
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    rect.size.height = self.font.lineHeight;
    rect.origin.y = ((self.frame.size.height - self->bottomLineView.frame.size.height) - self.font.lineHeight )/2;
    [super drawTextInRect:rect];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.y = 0;
    return rect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.y = 0;
    return rect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self setupUIRelatedToFrame];
//}

//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    rect.origin.y = (rect.size.height - self.font.lineHeight)/2;
//    UIFont *font = self.font;
//
//    Settings *settings = [Settings sharedInstance];
//    UIColor *placeholderColor;
//    if(_placeholderColorType <= COLORS_CONFIG_MIN_TYPE || _placeholderColorType > COLORS_CONFIG_MAX_TYPE) {
//        placeholderColor = settings.colorsConfig.white;
//    } else {
//        UIColor *placeholder_color = [settings.colorsConfig.colorsDictionary objectForKey:[NSNumber numberWithInteger:_placeholderColorType]];
//        if(_placeholderColorAlpha == 1 || self.placeholderColorAlpha == -1) {
//            placeholderColor = placeholder_color;
//        } else {
//            placeholderColor = [UIColor getColor:placeholder_color withAlpha:_placeholderColorAlpha];
//        }
//    }
//
//    NSDictionary *attrs = @{ NSForegroundColorAttributeName : placeholderColor,
//                             NSFontAttributeName : font,
//                             };
//    [[self placeholder] drawInRect:rect withAttributes:attrs];
//
//}

- (void)setHidden:(BOOL)hidden
{
    //TODO:DAVID SHAHNAZARYAN need to improve
    [super setHidden:hidden];
    [self setupUIRelatedToFrame];
}
#pragma mark - custom setters
- (void)setBackgroundColorType:(NSInteger)backgroundColorType
{
    _backgroundColorType = backgroundColorType;
    [self configureBackgroundColor];
}

- (void)setBackgroundColorAlpha:(CGFloat)backgroundColorAlpha
{
    _backgroundColorAlpha = backgroundColorAlpha;
    [self configureBackgroundColor];
}

- (void)configureBackgroundColor
{
    
    NSInteger backgroundColorType = _backgroundColorType;
    
    if(backgroundColorType <= SYColorTypeNone || _backgroundColorType > SYColorTypeLast) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        UIColor *backgroundColor = [UIColor colorWithSYColor:self.backgroundColorType alpha:self.backgroundColorAlpha];
        if(_backgroundColorAlpha == 1) {
            self.backgroundColor = backgroundColor;
        } else {
            self.backgroundColor = [UIColor getColor:backgroundColor withAlpha:_backgroundColorAlpha];
        }
    }
}

-(void)setTextColorType:(NSInteger)textColorType
{
    _textColorType = textColorType;
    [self configureTextColor];
}

- (void)setTextColorTypeAlpha:(CGFloat)textColorTypeAlpha
{
    _textColorTypeAlpha = textColorTypeAlpha;
    [self configureTextColor];
}

- (void)configureTextColor
{
    
    NSInteger textColorType = _textColorType;
    
    if(textColorType <= SYColorTypeNone || textColorType > SYColorTypeLast) {
        self.textColor = [UIColor whiteColor];
    } else {
        UIColor *textColor = [UIColor colorWithSYColor:self.textColorType alpha:self.textColorTypeAlpha];
        if(_textColorTypeAlpha == 1) {
            self.textColor = textColor;
        } else {
            self.textColor = [UIColor getColor:textColor withAlpha:_textColorTypeAlpha];
        }
    }
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

//- (void)setPlaceholder:(NSString *)placeholder
//{
//    [super setPlaceholder:placeholder];
//    [self configurePlaceholder];
//    //[self configureSelectedPlaceholderColor];
//}

- (void)configurePlaceholder
{
    //    if(self.placeholder) {
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
    self.placeHolderColor = placeholderColor;
    //        NSString *placeholderString = self.placeholder;
    //        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderString attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    //    }
}

- (void)setSelectedPlaceholderColorType:(NSInteger)selectedPlaceholderColorType
{
    _selectedPlaceholderColorType = selectedPlaceholderColorType;
    [self configureSelectedPlaceholderColor];
}

- (void)setSelectedPlaceholderColorAlpha:(CGFloat)selectedPlaceholderColorAlpha
{
    _selectedPlaceholderColorAlpha = selectedPlaceholderColorAlpha;
    [self configureSelectedPlaceholderColor];
}

- (void)configureSelectedPlaceholderColor
{
    NSInteger selectedPlaceholderColorType = _selectedPlaceholderColorType;
    
    if(selectedPlaceholderColorType <= SYColorTypeNone || selectedPlaceholderColorType > SYColorTypeLast) {
        self.selectedPlaceHolderColor = [UIColor whiteColor];
    } else {
        UIColor *selectedPlaceholderColor = [UIColor colorWithSYColor:self.selectedPlaceholderColorType alpha:self.selectedPlaceholderColorAlpha];
        if(_selectedPlaceholderColorAlpha == 1) {
            self.selectedPlaceHolderColor = selectedPlaceholderColor;
        } else {
            self.selectedPlaceHolderColor = [UIColor getColor:selectedPlaceholderColor withAlpha:_selectedPlaceholderColorAlpha];
        }
    }
}

- (void)setErrorTextColorType:(NSInteger)errorTextColorType
{
    _errorTextColorType = errorTextColorType;
    [self configureErrorTextColor];
}

- (void)setErrorTextColorTypeAlpha:(CGFloat)errorTextColorTypeAlpha
{
    _errorTextColorTypeAlpha = errorTextColorTypeAlpha;
    [self configureErrorTextColor];
}

- (void)configureErrorTextColor
{
    NSInteger errorTextColorType = _errorTextColorType;
    
    if(errorTextColorType <= SYColorTypeNone || errorTextColorType > SYColorTypeLast) {
        self.errorTextColor = [UIColor whiteColor];
    } else {
        UIColor *errorTextColor = [UIColor colorWithSYColor:self.errorTextColorType alpha:self.errorTextColorTypeAlpha];
        if(_errorTextColorTypeAlpha == 1) {
            self.errorTextColor = errorTextColor;
        } else {
            self.errorTextColor = [UIColor getColor:errorTextColor withAlpha:_errorTextColorTypeAlpha];
        }
    }
}

-(void)setLineColorType:(NSInteger)lineColorType
{
    _lineColorType = lineColorType;
    [self configureLineColor];
}

- (void)setLineColorTypeAlpha:(CGFloat)lineColorTypeAlpha
{
    _lineColorTypeAlpha = lineColorTypeAlpha;
    [self configureLineColor];
}

- (void)configureLineColor
{
    NSInteger lineColorType = _lineColorType;
    
    if(lineColorType <= SYColorTypeNone || lineColorType > SYColorTypeLast) {
        self.lineColor = [UIColor whiteColor];
    } else {
        UIColor *lineColor = [UIColor colorWithSYColor:self.lineColorType alpha:self.lineColorTypeAlpha];
        if(_lineColorTypeAlpha == 1) {
            self.lineColor = lineColor;
        } else {
            self.lineColor = [UIColor getColor:lineColor withAlpha:_lineColorTypeAlpha];
        }
    }
}

- (void)setSelectedLineColorType:(NSInteger)selectedLineColorType
{
    _selectedLineColorType = selectedLineColorType;
    [self configureSelectedLineColorType];
}

- (void)setSelectedLineColorTypeAlpha:(CGFloat)selectedLineColorTypeAlpha
{
    _selectedLineColorTypeAlpha = selectedLineColorTypeAlpha;
    [self configureSelectedLineColorType];
}

- (void)configureSelectedLineColorType
{
    NSInteger selectedLineColorType = _selectedLineColorType;
    
    if(selectedLineColorType <= SYColorTypeNone || selectedLineColorType > SYColorTypeLast) {
        self.selectedLineColor = [UIColor whiteColor];
    } else {
        UIColor *selectedLineColor = [UIColor colorWithSYColor:self.selectedLineColorType alpha:self.selectedLineColorTypeAlpha];
        if(_selectedLineColorTypeAlpha == 1) {
            self.selectedLineColor = selectedLineColor;
        } else {
            self.selectedLineColor = [UIColor getColor:selectedLineColor withAlpha:_selectedLineColorTypeAlpha];
        }
    }
}

- (void)setTintColorType:(NSInteger)tintColorType
{
    _tintColorType = tintColorType;
    if(_tintColorType < SYColorTypeNone || _tintColorType > SYColorTypeLast) {
        
    } else {
        UIColor *tintColor = [UIColor colorWithSYColor:self.tintColorType alpha:1.0];
        self.tintColor = tintColor;
    }
}

-(void)setErrorLineColorType:(NSInteger)errorLineColorType
{
    _errorLineColorType = errorLineColorType;
    [self configureErrorLineColor];
}

- (void)setErrorLineColorTypeAlpha:(CGFloat)errorLineColorTypeAlpha
{
    _errorLineColorTypeAlpha = errorLineColorTypeAlpha;
    [self configureErrorLineColor];
}

- (void)configureErrorLineColor
{
    NSInteger errorLineColorType = _errorLineColorType;
    
    if(errorLineColorType <= SYColorTypeNone || errorLineColorType > SYColorTypeLast) {
        self.errorLineColor = [UIColor whiteColor];
    } else {
        UIColor *errorLineColor = [UIColor colorWithSYColor:self.errorLineColorType alpha:self.errorTextColorTypeAlpha];
        if(_errorTextColorTypeAlpha == 1) {
            self.errorLineColor = errorLineColor;
        } else {
            self.errorLineColor = [UIColor getColor:errorLineColor withAlpha:_errorTextColorTypeAlpha];
        }
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self.layer setCornerRadius:_cornerRadius];
}

- (void)setBorderColorType:(NSInteger)borderColorType
{
    _borderColorType = borderColorType;
    self.layer.borderColor = [self getBackgroundColorFromColorType:_borderColorType].CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

#pragma mark - Private method

- (void)setupUI
{
    self.clipsToBounds = YES;
    self.minimumFontSize = self.self.font.pointSize;
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
}

- (void)setupBackground
{
    if (self.backgroundColorType && (self.darkViewAlpha || self.lightViewAlpha)) {
        
        UIColor *backgroundColor = [UIColor colorWithSYColor:self.backgroundColorType alpha:self.backgroundColorAlpha];
        
        self.backgroundColor = backgroundColor;
    }
}

- (void)setupLeftView
{
    UIView *leftView;
    UITextField *leftViewLabel;
    UIImageView *leftImageView;
    CGFloat leftViewWidth;
    
    if (_leftViewImage) {
        leftImageView = [[UIImageView alloc] initWithImage:_leftViewImage];
        if(_leftViewImageColorType) {
            leftImageView.image = [_leftViewImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            leftImageView.tintColor = [self getBackgroundColorFromColorType:_leftViewImageColorType];
        } else {
            leftImageView.image = [_leftViewImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
        }
    }
    
    if (_leftViewText) {
        leftViewLabel = [[UITextField alloc] init];
        [leftViewLabel setUserInteractionEnabled:NO];
        leftViewLabel.text = _leftViewText;
        [leftViewLabel setBackgroundColor:[UIColor clearColor]];
        [leftViewLabel setTextColor:[self getTextColorFromColorType:_leftViewTextColorType?:_textColorType isPlaceolder:NO]];
        [leftViewLabel setTextAlignment:NSTextAlignmentCenter];
        [leftViewLabel setFont:self.font ];
        CGSize stringSize = [_leftViewText sizeWithAttributes:@{NSFontAttributeName:self.font}];
        
        CGFloat width = stringSize.width;
        [leftViewLabel setFrame:CGRectMake(0, 0, width, self.font.lineHeight)];
    }
    
    leftViewWidth = MAX(_leftViewWidth, MAX(leftViewLabel.frame.size.width, leftImageView.frame.size.width));
    leftViewWidth += _leftViewSeparatorWidth;
    
    if (leftViewWidth) {
        self.leftSpace = leftViewWidth;
        leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftViewWidth, self.frame.size.height - self->bottomLineView.frame.size.height)];
        [leftView setUserInteractionEnabled:NO];
        [leftView setBackgroundColor:[self getBackgroundColorFromColorType:_leftViewBackgroundColorType]];
        
        if (leftImageView) {
            [leftView addSubview:leftImageView];
            [leftImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:leftImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(-1) * _leftViewSeparatorWidth/2];
            
            NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:leftImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            [leftView addConstraints:@[xCenterConstraint, yCenterConstraint]];
        }
        
        if (leftViewLabel) {
            [leftView addSubview:leftViewLabel];
            [leftViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:leftViewLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(-1) * _leftViewSeparatorWidth/2];
            [leftView addConstraint:xCenterConstraint];
        }
        
        if (_leftViewSeparatorWidth && _leftViewSeparatorColorType) {
            CGFloat separatorX = leftView.frame.size.width - _leftViewSeparatorWidth;
            CGFloat separatorY = 0;
            CGFloat separatorWidth = _leftViewSeparatorWidth;
            CGFloat separatorHeight = leftView.frame.size.height - _leftViewSeparatorTopOffset;
            SYDesignableView *separatorView = [[SYDesignableView alloc] initWithFrame:CGRectMake(separatorX, separatorY, separatorWidth, separatorHeight )];
            separatorView.backgroundColorType = _leftViewSeparatorColorType;
            separatorView.backgroundColorAlpha = 1;
            
            [leftView addSubview:separatorView];
        }
    }
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    self.leftView = leftView;
    [self.leftView setUserInteractionEnabled:NO];
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    if ([subview isEqual:self.leftView]) {
        for (id subV in self.leftView.subviews) {
            if ([subV isKindOfClass:[UITextField class]]) {
                if (self.leftView.superview) {
                    NSLayoutConstraint *lastBaseline =[NSLayoutConstraint
                                                       constraintWithItem:subV
                                                       attribute:NSLayoutAttributeBaseline
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeBaseline
                                                       multiplier:1.0f
                                                       constant:0.f];
                    
                    [self addConstraint:lastBaseline];
                }
            }
        }
    }
}

- (void)setupRightView
{
    UIView *rightView;
    UITextField *rightViewLabel;
    UIImageView *rightImageView;
    CGFloat rightViewWidth;
    
    if (_rightViewImage) {
        rightImageView = [[UIImageView alloc] initWithImage:_rightViewImage];
        if(_rightViewImageColorType) {
            rightImageView.image = [_rightViewImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            rightImageView.tintColor = [self getBackgroundColorFromColorType:_rightViewImageColorType];
        } else {
            rightImageView.image = [_rightViewImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
        }
    }
    
    if (_rightViewText) {
        rightViewLabel = [[UITextField alloc] init];
        [rightViewLabel setUserInteractionEnabled:NO];
        rightViewLabel.text = _rightViewText;
        [rightViewLabel setBackgroundColor:[UIColor clearColor]];
        [rightViewLabel setTextColor:[self getTextColorFromColorType:_rightViewTextColorType?:_textColorType isPlaceolder:NO]];
        [rightViewLabel setTextAlignment:NSTextAlignmentCenter];
        [rightViewLabel setFont:self.font ];
        CGSize stringSize = [_rightViewText sizeWithAttributes:@{NSFontAttributeName:self.font}];
        
        CGFloat width = stringSize.width;
        [rightViewLabel setFrame:CGRectMake(0, 0, width, self.font.lineHeight)];
    }
    
    rightViewWidth = MAX(_rightViewWidth, MAX(rightViewLabel.frame.size.width, rightImageView.frame.size.width));
    rightViewWidth += _rightViewSeparatorWidth;
    
    if (rightViewWidth) {
        self.rightSpace = rightViewWidth;
        rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightViewWidth, self.frame.size.height - self->bottomLineView.frame.size.height)];
        [rightView setUserInteractionEnabled:NO];
        [rightView setBackgroundColor:[self getBackgroundColorFromColorType:_rightViewBackgroundColorType]];
        
        if (rightImageView) {
            [rightView addSubview:rightImageView];
            [rightImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:rightImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(-1) * _rightViewSeparatorWidth/2];
            
            NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:rightImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:4];
            [rightView addConstraints:@[xCenterConstraint, yCenterConstraint]];
        }
        
        if (rightViewLabel) {
            [rightView addSubview:rightViewLabel];
            [rightViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:rightViewLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(-1) * _rightViewSeparatorWidth/2];
            
            NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:rightViewLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:4];
            [rightView addConstraints:@[xCenterConstraint, yCenterConstraint]];
        }
        
        if (_rightViewSeparatorWidth && _rightViewSeparatorColorType) {
            CGFloat separatorX = rightView.frame.size.width - _rightViewSeparatorWidth;
            CGFloat separatorY = 0;
            CGFloat separatorWidth = _rightViewSeparatorWidth;
            CGFloat separatorHeight = rightView.frame.size.height - _rightViewSeparatorTopOffset;
            SYDesignableView *separatorView = [[SYDesignableView alloc] initWithFrame:CGRectMake(separatorX, separatorY, separatorWidth, separatorHeight )];
            separatorView.backgroundColorType = _rightViewSeparatorColorType;
            separatorView.backgroundColorAlpha = 1;
            
            [rightView addSubview:separatorView];
        }
    }
    
    [self setRightViewMode:UITextFieldViewModeAlways];
    self.rightView = rightView;
    [self.rightView setUserInteractionEnabled:NO];
}

- (void)setupUIRelatedToFrame
{
    [self setupLeftView];
    [self setupRightView];
    [self configureSideViewsObserving];
}

- (void)configureSideViewsObserving
{
    //LeftViewContext
    [self addChangeObserver:self forKeyPath:@"leftViewText"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewTextColorType"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewImage"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewImageColorType"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewWidth"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewBackgroundColorType"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewSeparatorWidth"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewSeparatorTopOffset"
                    context:LeftViewContext];
    [self addChangeObserver:self forKeyPath:@"leftViewSeparatorColorType"
                    context:LeftViewContext];
    
    //RightViewContext
    [self addChangeObserver:self forKeyPath:@"rightViewText"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewTextColorType"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewImage"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewImageColorType"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewWidth"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewBackgroundColorType"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewSeparatorWidth"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewSeparatorTopOffset"
                    context:RightViewContext];
    [self addChangeObserver:self forKeyPath:@"rightViewSeparatorColorType"
                    context:RightViewContext];
}

- (void)configureBackgroundObserving
{
    //BackgroundContext
    [self addChangeObserver:self forKeyPath:@"backgroundColorType"
                    context:BackgroundContext];
    [self addChangeObserver:self forKeyPath:@"darkViewAlpha"
                    context:BackgroundContext];
    [self addChangeObserver:self forKeyPath:@"lightViewAlpha"
                    context:BackgroundContext];
}

- (void)addChangeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context
{
    if (!self.observerKeyPaths) {
        self.observerKeyPaths = [[NSMutableSet alloc] init];
    }
    
    if (![self.observerKeyPaths containsObject:keyPath]) {
        [self.observerKeyPaths addObject:keyPath];
        [self addObserver:self forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:context];
    }
}

- (void)removeAllObservers
{
    for (NSString* keyPath in self.observerKeyPaths) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (UIColor *)getTextColorFromColorType:(NSInteger)colorType isPlaceolder:(BOOL)isPlaceholder
{
    
    UIColor *color;
    if(colorType <= SYColorTypeNone || colorType >= SYColorTypeLast) {
        if (isPlaceholder) {
            color = [UIColor whiteColor];
        } else {
            color = [UIColor whiteColor];
        }
    } else {
        color = [UIColor colorWithSYColor:colorType alpha:1.0];
    }
    return color;
}

- (UIColor *)getBackgroundColorFromColorType:(NSInteger)colorType
{
    UIColor *color;
    if(colorType <= SYColorTypeNone || colorType > SYColorTypeLast - 1) {
        color = [UIColor clearColor];
    } else {
        color = [UIColor colorWithSYColor:colorType alpha:1.0];
    }
    return color;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == BackgroundContext) {
        [self setupBackground];
    } else if (context == LeftViewContext) {
        [self setupLeftView];
    } else if (context == RightViewContext) {
        [self setupRightView];
    }
}



@end
