//
//  UIColor+UIImage.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/10/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (UIImage)

- (UIImage *)getImageWithPoint:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
