//
//  SYDesignableImageView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/1/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface SYDesignableImageView : UIImageView

@property (nonatomic, assign) IBInspectable NSInteger imageColorType;
@property (nonatomic) IBInspectable CGFloat imageColorAlpha;
@property (nonatomic) IBInspectable NSInteger backgroundColorType;
@property (nonatomic) IBInspectable CGFloat backgroundColorAlpha;
@property (nonatomic, strong) IBInspectable UIImage *backgroundImage;
@property (nonatomic) IBInspectable NSInteger borderColorType;
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic) IBInspectable CGFloat cornerRadius;

- (void)configureImageColor;


@end
