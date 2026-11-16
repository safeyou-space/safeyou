//
//  ChangePinViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/10/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"
@class ChangePinViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol CreateDualPinViewDelegate <NSObject>

- (void)createPinViewDidCreatePin:(ChangePinViewController *)createPinViewController;
- (void)createPinViewDidUpdatePin:(ChangePinViewController *)createPinViewController;
- (void)createPinViewDidCancel:(ChangePinViewController *)createPinViewController;

@end

@interface ChangePinViewController : SYViewController

@property (nonatomic, weak) id <CreateDualPinViewDelegate> delegate;
@property (nonatomic) BOOL isUpdating;

@end

NS_ASSUME_NONNULL_END
