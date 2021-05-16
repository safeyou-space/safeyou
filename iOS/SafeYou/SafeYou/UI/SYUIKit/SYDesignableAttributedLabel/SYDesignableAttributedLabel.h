//
//  SYDesignableAttributedLabel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "TTTAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface SYDesignableAttributedLabel : TTTAttributedLabel

@property (nonatomic) IBInspectable NSInteger linkColorType;
@property (nonatomic) IBInspectable NSInteger textColorType;
@property (nonatomic) IBInspectable NSInteger backgroundColorType;

- (void)configureTextColor;

@end

NS_ASSUME_NONNULL_END
