//
//  SYDesignableTextField.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ACFloatingTextField.h"

IB_DESIGNABLE

@interface SYDesignableTextField : ACFloatingTextField

@property (nonatomic) IBInspectable NSInteger backgroundColorType;
@property (nonatomic) IBInspectable CGFloat backgroundColorAlpha;

@property (nonatomic) IBInspectable NSInteger textColorType;
@property (nonatomic) IBInspectable CGFloat textColorTypeAlpha;

@property (nonatomic) IBInspectable NSInteger placeholderColorType;
@property (nonatomic) IBInspectable CGFloat placeholderColorAlpha;

@property (nonatomic) IBInspectable NSInteger selectedPlaceholderColorType;
@property (nonatomic) IBInspectable CGFloat selectedPlaceholderColorAlpha;

@property (nonatomic) IBInspectable NSInteger errorTextColorType;
@property (nonatomic) IBInspectable CGFloat errorTextColorTypeAlpha;


@property (nonatomic) IBInspectable NSInteger lineColorType;
@property (nonatomic) IBInspectable CGFloat lineColorTypeAlpha;

@property (nonatomic) IBInspectable NSInteger selectedLineColorType;
@property (nonatomic) IBInspectable CGFloat selectedLineColorTypeAlpha;

@property (nonatomic) IBInspectable NSInteger errorLineColorType;
@property (nonatomic) IBInspectable CGFloat errorLineColorTypeAlpha;

@property (nonatomic) IBInspectable NSInteger tintColorType;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable NSInteger borderColorType;
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic) IBInspectable CGFloat leftSpace;
@property (nonatomic) IBInspectable CGFloat rightSpace;

@property (nonatomic) IBInspectable CGFloat darkViewAlpha;
@property (nonatomic) IBInspectable CGFloat lightViewAlpha;


//Left view
@property (nonatomic, strong) IBInspectable NSString *leftViewText;
@property (nonatomic) IBInspectable NSInteger leftViewTextColorType;
@property (nonatomic, strong) IBInspectable UIImage *leftViewImage;
@property (nonatomic) IBInspectable NSInteger leftViewImageColorType;
@property (nonatomic) IBInspectable CGFloat leftViewWidth;
@property (nonatomic) IBInspectable NSInteger leftViewBackgroundColorType;
@property (nonatomic) IBInspectable CGFloat leftViewSeparatorWidth;
@property (nonatomic) IBInspectable CGFloat leftViewSeparatorTopOffset;
@property (nonatomic) IBInspectable CGFloat leftViewSeparatorColorType;


//Right view
@property (nonatomic, strong) IBInspectable NSString *rightViewText;
@property (nonatomic) IBInspectable NSInteger rightViewTextColorType;
@property (nonatomic, strong) IBInspectable UIImage *rightViewImage;
@property (nonatomic) IBInspectable NSInteger rightViewImageColorType;
@property (nonatomic) IBInspectable CGFloat rightViewWidth;
@property (nonatomic) IBInspectable NSInteger rightViewBackgroundColorType;
@property (nonatomic) IBInspectable CGFloat rightViewSeparatorWidth;
@property (nonatomic) IBInspectable CGFloat rightViewSeparatorTopOffset;
@property (nonatomic) IBInspectable CGFloat rightViewSeparatorColorType;


@end
