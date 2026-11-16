//
//  SYDesignableLabel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@interface SYDesignableLabel : UILabel

@property (nonatomic) IBInspectable NSInteger textColorType;
@property (nonatomic) IBInspectable CGFloat textColorAlpha;
@property (nonatomic) IBInspectable NSInteger backgroundColorType;
@property (nonatomic) IBInspectable CGFloat backgroundColorAlpha;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
