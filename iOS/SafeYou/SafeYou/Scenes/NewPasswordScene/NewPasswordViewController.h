//
//  NewPasswordViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPasswordViewController : SYViewController

@property (nonatomic) NSString *recoveredPhoneNumber;
@property (nonatomic) NSString *token;

@end

NS_ASSUME_NONNULL_END
