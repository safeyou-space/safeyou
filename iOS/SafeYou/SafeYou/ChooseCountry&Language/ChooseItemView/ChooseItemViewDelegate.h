//
//  ChooseItemViewDelegate.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/30/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChooseItemView;

NS_ASSUME_NONNULL_BEGIN


@protocol ChooseItemViewDelegate <NSObject>

- (void)chooseItemDidPressSelect:(ChooseItemView *)chooseItemView;

@end

NS_ASSUME_NONNULL_END
