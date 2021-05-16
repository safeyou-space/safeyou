//
//  SYDesignableButton.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface SYDesignableButton : UIButton

@property (nonatomic) IBInspectable NSInteger backgroundColorType;
@property (nonatomic) IBInspectable CGFloat backgroundColorAlpha;
@property (nonatomic) IBInspectable NSInteger titleColorType;
@property (nonatomic) IBInspectable CGFloat titleColorTypeAlpha;
@property (nonatomic) IBInspectable NSInteger imageColorType;
@property (nonatomic) IBInspectable NSInteger selectedImageColorType;
@property (nonatomic) IBInspectable NSInteger borderColorType;
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
