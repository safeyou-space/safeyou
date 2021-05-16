//
//  AvatarTitleView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AvatarTitleViewDelegate <NSObject>

- (void)navTitleButtonPressed;

@end

@interface AvatarTitleView : UIView

@property (weak, nonatomic) id <AvatarTitleViewDelegate> delegate;

+ (instancetype)createAvatarTitleView;

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSURL *imageUrl;


@end

NS_ASSUME_NONNULL_END
