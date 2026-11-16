//
//  IntroContentViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/21/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class IntroductionContentViewModel;


NS_ASSUME_NONNULL_BEGIN

@interface IntroContentViewController : SYViewController

@property (nonatomic) IntroductionContentViewModel* viewModel;

@end

NS_ASSUME_NONNULL_END
