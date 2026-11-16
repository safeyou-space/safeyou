//
//  MessageOptionButton.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/29/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageButtonTag) {
    Edit = 0,
    Delete = 1,
    Copy = 2,
    Report = 3,
};

@interface MessageOptionButton : UIButton

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image tag:(MessageButtonTag)tag;

@end

NS_ASSUME_NONNULL_END
