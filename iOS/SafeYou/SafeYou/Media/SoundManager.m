//
//  SoundManager.m
//  LiveCasino
//
//  Created by Admin on 2/20/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "SoundManager.h"
#import "Settings.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager ()

@property (nonatomic, strong) AVAudioPlayer* winPlayer;
@property (nonatomic, strong) AVAudioPlayer* movePlayer;
@property (nonatomic, strong) AVAudioPlayer* takePlayer;
@property (nonatomic, strong) AVAudioPlayer* tournamentStartedPlayer;
@property (nonatomic, strong) AVAudioPlayer* timerPlayer;

@end

@implementation SoundManager

#pragma mark - Special methods

+ (SoundManager*)getInstance {
    static SoundManager* _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SoundManager alloc] init];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - Public intarface

- (void)playFileWithPath:(NSString *)filePath
{
    
}

- (void)playAudioWithUrl:(NSString *)audioUrl
{
    
}

#pragma mark - Private API

- (AVAudioPlayer*)initializePlayerWithSound:(NSString*) sound isInfinite:(BOOL) isInfinite {
    AVAudioPlayer* player = nil;
    if(nil == player) {
        NSString* soundPath = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"];
        NSURL* url = [NSURL fileURLWithPath:soundPath];
        if (url) {
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [player prepareToPlay];
            if(isInfinite) {
                player.numberOfLoops = -1;
            }
        }
    }
    return player;
}

- (void)startPlaybackWithPlayer:(AVAudioPlayer*) player {
	if(![player isPlaying]) {
		[player stop];
        [player play];
    }
}

- (void)stopTimer
{
    if (self.timerPlayer.isPlaying) {
        [self.timerPlayer stop];
    }
}

- (void)stopTournamentSound
{
    if (self.tournamentStartedPlayer.isPlaying) {
        [self.tournamentStartedPlayer stop];
    }
}

- (void)stopPlayer:(AVAudioPlayer *)player
{
    if (player.isPlaying) {
        [player stop];
    }
}

@end
