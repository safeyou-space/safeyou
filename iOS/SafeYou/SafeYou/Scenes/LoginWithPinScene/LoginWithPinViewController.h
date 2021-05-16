//
//  LoginWithPinViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"


@class LoginWithPinViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol LoginWithPinViewDelegate <NSObject>

@optional

- (void)loginWithPinViewDidSelectForgotPin:(LoginWithPinViewController *)loginPinView;

@end

@interface LoginWithPinViewController : SYViewController

@property (nonatomic) id<LoginWithPinViewDelegate> delegate;
@property (nonatomic) BOOL isFromSignInFlow;

@end

NS_ASSUME_NONNULL_END
