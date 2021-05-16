//
//  SocketIOManager.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/27/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SocketIO;

NS_ASSUME_NONNULL_BEGIN

@interface SocketIOManager : NSObject

+ (instancetype)sharedInstance;

- (void)connect;
@property (nonatomic, readonly) SocketIOClient *socketClient;

@end

NS_ASSUME_NONNULL_END
