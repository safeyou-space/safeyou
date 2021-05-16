//
//  WebContentViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebContentViewController : SYViewController

+ (instancetype)initializeWebContentView;

@property (nonatomic) SYRemotContentType contentType;


@end

NS_ASSUME_NONNULL_END
