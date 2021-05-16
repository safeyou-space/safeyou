//
//  SoundManager.h
//  LiveCasino
//
//  Created by Admin on 2/20/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioPlayer;
/**
 Sound play functionality
 */
@interface SoundManager : NSObject

// Indicates is bg music is playing
@property (nonatomic, assign) BOOL isBackgroundMusicPlaying;

// Indicates is timeTick is playing
@property (nonatomic, assign) BOOL isTimerThickPlaying;


/**
 Intsance of SoundManager object
 */
+ (SoundManager*)getInstance;

- (void)playFileWithPath:(NSString *)filePath;
- (void)playAudioWithUrl:(NSString *)audioUrl;

@end
