//
//  SYDesignableView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface SYDesignableView : UIView

@property (nonatomic) IBInspectable NSInteger backgroundColorType;
@property (nonatomic) IBInspectable CGFloat backgroundColorAlpha;
@property (nonatomic) IBInspectable NSInteger borderColorType;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable NSInteger shadowColorType;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;

@property (nonatomic) IBInspectable NSInteger gradientTopColorType;
@property (nonatomic) IBInspectable NSInteger gradientBottomColorType;

@property (nonatomic) IBInspectable BOOL isHorizontal;

@end

NS_ASSUME_NONNULL_END
