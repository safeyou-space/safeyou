//
//  SYSemiRoundedView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/24/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableView.h"

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@interface SYSemiRoundedView : SYDesignableView

@property (nonatomic) IBInspectable BOOL topLeft;
@property (nonatomic) IBInspectable BOOL topRigth;
@property (nonatomic) IBInspectable BOOL bottomLeft;
@property (nonatomic) IBInspectable BOOL bottomRigth;

@end

NS_ASSUME_NONNULL_END
