//
//  RoundButtonView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoundButtonView;

@protocol RoundButtonAction <NSObject>

- (void)roundButtonPressed:(RoundButtonView *)sender;

@end

IB_DESIGNABLE

@interface RoundButtonView : UIView

@property (nonatomic) IBInspectable UIImage *image;
@property (nonatomic) IBInspectable UIImage *selectedImage;

@property (nonatomic) NSInteger selectedTitleColorType;
@property (nonatomic) IBInspectable NSString *title;

@property (weak, nonatomic) IBOutlet id<RoundButtonAction> roundButtonAction;

@end

NS_ASSUME_NONNULL_END
