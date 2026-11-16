//
//  PlayerHelper.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayer;
NS_ASSUME_NONNULL_BEGIN

@interface PlayerHelper : NSObject
{
    AVPlayer *player;
}

+ (PlayerHelper *)sharedPlayer;

- (BOOL)playAudio:(NSString*)urlPath;

- (void)stopPlayer;

- (void)pausePlayer;

- (void)seekTo:(float)time;

- (float)duration;

@end

NS_ASSUME_NONNULL_END
