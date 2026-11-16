//
//  SYDesignableCheckBoxButton.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDesignableCheckBoxButton : SYDesignableButton

@property (nonatomic) IBInspectable UIImage *unCheckedImage;
@property (nonatomic) IBInspectable UIImage *checkedImage;

@end

NS_ASSUME_NONNULL_END
