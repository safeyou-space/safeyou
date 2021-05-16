//
//  UnderLineButtonView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/13/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnderLineButtonView;

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@protocol UnderLineButtonDelegate <NSObject>

- (void)underlineButtonAction:(UnderLineButtonView *)underlineButton;

@end

@interface UnderLineButtonView : UIView

@property (weak, nonatomic) IBOutlet id <UnderLineButtonDelegate> delegate;

@property (nonatomic) IBInspectable NSString *title;
@property (nonatomic) IBInspectable BOOL selected;

@end

NS_ASSUME_NONNULL_END
