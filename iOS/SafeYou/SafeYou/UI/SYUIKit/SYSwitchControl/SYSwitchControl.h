//
//  SYSwitchControl.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYUIKit.h"

IB_DESIGNABLE

@interface SYSwitchControl : UISwitch

@property (nonatomic) IBInspectable NSInteger backgroundColorType;
@property (nonatomic) IBInspectable CGFloat backgroundColorAlpha;
@property (nonatomic) IBInspectable NSInteger tintColorType;
@property (nonatomic) IBInspectable CGFloat tintColorAlpha;
@property (nonatomic) IBInspectable NSInteger onTintColorType;
@property (nonatomic) IBInspectable CGFloat onTintColoAlpha;
@property (nonatomic) IBInspectable NSInteger onThumbTintColorType;
@property (nonatomic) IBInspectable CGFloat onThumbTintColorAlpha;
@property (nonatomic) IBInspectable NSInteger offThumbTintColorType;
@property (nonatomic) IBInspectable CGFloat offThumbTintColorAlpha;

@end
