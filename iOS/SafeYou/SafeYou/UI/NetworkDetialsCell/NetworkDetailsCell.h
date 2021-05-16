//
//  NetworkDetailsCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/9/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceContactViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkDetailsCell : UITableViewCell

- (void)configureWithImage:(UIImage *)image title:(NSString *)title value:(NSString *)value;

- (void)configureWithViewModel:(ServiceContactViewModel *)viewData;

@end

NS_ASSUME_NONNULL_END
