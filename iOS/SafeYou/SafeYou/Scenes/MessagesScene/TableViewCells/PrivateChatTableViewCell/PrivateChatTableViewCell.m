//
//  PrivateChatTableViewCell.m
//  SafeYou
//
//  Created by Crypmoji on 11/28/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "PrivateChatTableViewCell.h"
#import "UIView+Layer.h"
#import "ChatMessageDataModel.h"
#import "MessageFileDataModel.h"
#import <SDWebImage.h>

#define LARGE_CORNER_RADIUS 12.0
#define SMALL_CORNER_RADIUS 4.0

@interface PrivateChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet SYLabelLight *dateLabel;
@property (weak, nonatomic) IBOutlet SYDesignableView *mainContentView;
@property (weak, nonatomic) IBOutlet UIView *repliedMessageView;
@property (weak, nonatomic) IBOutlet SYLabelBold *oponentNameLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *oponentMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageContentImageView;
@property (weak, nonatomic) IBOutlet UIView *messageContentAudio;
@property (weak, nonatomic) IBOutlet UIView *messageContentText;

@property (weak, nonatomic) IBOutlet UIButton *audioPlayButton;
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgressView;
@property (weak, nonatomic) IBOutlet SYLabelLight *audioDurationLabel;

@property (nonatomic) NSTimer *audioRecordTimer;
@property (nonatomic) int audioRecordTime;
@property (nonatomic) int audioRecordDuration;
@property (nonatomic) BOOL isAudioRecordStarted;

@end

@implementation PrivateChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.audioProgressView.progressTintColor = [UIColor mainTintColor3];
//    [self.mainContentView roundCorners:UIRectCornerAllCorners topLeftRadius:LARGE_CORNER_RADIUS topRightRadius:LARGE_CORNER_RADIUS bottomRightRadius:SMALL_CORNER_RADIUS bottomLeftRadius:LARGE_CORNER_RADIUS];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithMessageData:(ChatMessageDataModel *)messageData
{
    _messageData = messageData;
    self.messageTextView.text = self.messageData.messageContent;
    self.dateLabel.text = self.messageData.formattedCreatedDate;
    self.messageContentImageView.hidden = YES;
    self.messageContentAudio.hidden = YES;
    if (messageData.messageFiles.count > 0) {
        self.messageFileDataModel = [MessageFileDataModel modelObjectWithDictionary:messageData.messageFiles[0]];
        if (self.messageFileDataModel.type == FileTypeImage) {
            if([self.messageFileDataModel.mimetype isEqualToString:@"audio/mpeg"] || [self.messageFileDataModel.mimetype isEqualToString:@"audio/wav"]) {
                self.messageContentAudio.hidden = NO;
                self.messageContentText.hidden = YES;
                self.audioDurationLabel.text = self.messageFileDataModel.audioDuration;
            } else {
                self.messageContentImageView.hidden = NO;
                [_messageContentAudio performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)];
                [self.messageContentImageView addGestureRecognizer:tapGesture];
                [self.messageContentImageView sd_setImageWithURL:[self.messageFileDataModel mediaPath] placeholderImage:messageData.messageImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if(image != nil) {
                        messageData.messageImage = image;
                    }
                }];
            }
        }
    } else {
        [_messageContentAudio performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        self.messageContentText.hidden = NO;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.messageContentImageView.image = nil;
}

- (void)startPlayingAudio {
    self.isAudioRecordStarted = YES;
    [self.audioPlayButton setImage:[UIImage imageNamed:@"pause_icon_chat"] forState:UIControlStateNormal];
    self.audioRecordDuration = [self.messageFileDataModel audioDurationSeconds];
    self.audioRecordTime = self.audioRecordDuration;
    [self startAudioRecordTimer];
}

- (void)stopPlayingAudio {
    self.isAudioRecordStarted = NO;
    [self stopAudioRecordTimer];
    [self updateAudioTimerLabelAndProgressView:0];
}

- (void)startAudioRecordTimer {
    if(self.audioRecordTimer != nil) {
        [self.audioRecordTimer invalidate];
    }
    self.audioRecordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decrementAudioTimer) userInfo:nil repeats:YES];
}

- (void)stopAudioRecordTimer {
    [self.audioPlayButton setImage:[UIImage imageNamed:@"play_icon_chat"] forState:UIControlStateNormal];
    [self.audioRecordTimer invalidate];
}

- (void)decrementAudioTimer {
    self.audioRecordTime -= 1;
    if(self.audioRecordTime <= 0) {
        [self stopAudioRecordTimer];
    }
    [self updateAudioTimerLabelAndProgressView:self.audioRecordTime];
}

- (void)updateAudioTimerLabelAndProgressView:(int)audioDuration {
    if(audioDuration > 0) {
        int seconds = audioDuration % 60;
        int minutes = (audioDuration / 60) % 60;
        self.audioDurationLabel.text = [NSString stringWithFormat:@"%d:%.2d", minutes, seconds];
        self.audioProgressView.progress += (double)1/(double)self.audioRecordDuration;
    } else {
        self.audioDurationLabel.text = self.messageFileDataModel.audioDuration;
        self.audioProgressView.progress = 0;
    }
}

#pragma mark - IBActions
- (IBAction)playButtonPressed:(UIButton *)sender {
    if(self.isAudioRecordStarted) {
        [self stopPlayingAudio];
        if ([self.delegate respondsToSelector:@selector(commentCellDidSelectPauseAudio)]) {
            [self.delegate commentCellDidSelectPauseAudio];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(commentCellDidSelectPlayAudio:)]) {
            [self startPlayingAudio];
            [self.delegate commentCellDidSelectPlayAudio:self];
        }
    }
}

- (void)tapOnImageView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectImage:)]) {
        [self.delegate commentCellDidSelectImage:self];
    }
}

@end
