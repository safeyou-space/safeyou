//
//  SYServiceAPI.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYServiceAPI : NSObject

@property (nonatomic, copy) void  (^ _Nullable failureBlock)(NSError * _Nullable error);
@property (nonatomic, copy) void (^ _Nullable complitionBlock)(id _Nullable responseData);

- (NSString *)endpoint;

- (SYHTTPSessionManager *)networkManager;

- (SYHTTPSessionManager *)networkManagerWithUrl:(NSString *)urlString;

NS_ASSUME_NONNULL_END

@end
