//
//  PinNumberView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/1/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class PinNumberView;

@protocol PinNumberViewDelegate <NSObject>


- (void)numberView:(PinNumberView *)numberView didSelectNumber:(NSString *)numberText;
- (void)numberViewDidSelectForgotPin:(PinNumberView *)numberView ;
- (void)numberViewDidSelectBackspace:(PinNumberView *)numberView ;

@end

@interface PinNumberView : SYViewController

@property (nonatomic, weak) IBOutlet id<PinNumberViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
