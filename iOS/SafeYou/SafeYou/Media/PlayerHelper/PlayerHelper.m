//
//  PlayerHelper.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/25/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "PlayerHelper.h"
#import <AVKit/AVKit.h>


@implementation PlayerHelper

+ (PlayerHelper *)sharedPlayer
{
    static PlayerHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[PlayerHelper alloc] init];
    });
    return helper;
}

- (void)stopPlayer
{
    if (player != nil) {
        player = nil;
    }
}

- (void)pausePlayer
{
    [player pause];
}

- (BOOL)playAudio:(NSString*)urlPath
{
    NSURL *URL = [NSURL URLWithString:urlPath];
    NSError *error = nil;
    if (player == nil){
        player = [[AVPlayer alloc] initWithURL:URL];
    }
    if (error == nil) {
        [player play];
        return TRUE;
    }
    NSLog(@"error %@",error);
    return FALSE;
}

- (void)seekTo:(float)time
{
    [player seekToTime:CMTimeMake(time, 1)];
}

- (float)duration
{
    return player.currentTime.value;
    return 0;
}
@end
