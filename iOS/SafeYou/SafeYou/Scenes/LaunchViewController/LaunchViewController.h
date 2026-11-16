//
//  LaunchViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/10/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LaunchViewControllerDelegate <NSObject>

- (void)startApplicationInitially;

@end

@interface LaunchViewController : SYViewController

@property (weak, nonatomic) id<LaunchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
