//
//  IntroDetailsContentView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/24/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntrodutionDescriptionViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface IntroDetailsContentView : UIView

- (instancetype)initWithViewModel:(IntrodutionDescriptionViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
