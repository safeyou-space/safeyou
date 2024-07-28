//
//  RecordButton.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/15/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableButton.h"

@class RecordButton;

typedef NS_ENUM(NSUInteger, RecordButtonState) {
    RecordButtonStateUnknown,
    RecordButtonStateNormal,
    RecordButtonStateWaiting,
    RecordButtonStateRecording,
    RecordButtonStateFinished,
    RecordButtonStateStateLast
};

NS_ASSUME_NONNULL_BEGIN

@protocol RecordButtonDelegate <NSObject>

@optional

- (void)recordButtonDidStartRecording:(RecordButton *)recordButton;
- (void)recordButtonDidStopRecording:(RecordButton *)recordButton;

@end

@interface RecordButton : SYDesignableButton

@property (nonatomic) IBOutlet id <RecordButtonDelegate> delegate;

- (void)reset;
- (void)updateLocalizations;
- (void)recordButtonDidStartPressed:(RecordButton *)recordButton;
- (void)recordButtonDidStopPressed:(RecordButton *)recordButton;

@end

NS_ASSUME_NONNULL_END
