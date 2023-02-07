//
//  RecordDetailsViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordDetailsViewController.h"
#import "RecordListItemDataModel.h"
#import "RecordsService.h"
#import <AVKit/AVKit.h>
#import "CCAudioPlayer.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SYViewController+StyledAlerts.h"

#define kUseBlockAPIToTrackPlayerStatus     1

@interface RecordDetailsViewController () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *recordNameLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *recordTimerLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *recordDateLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *recordDurationLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *currentProgress;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *durationLabel;
@property (weak, nonatomic) IBOutlet HyRobotoButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;

- (IBAction)nextButtonAction:(id)sender;
- (IBAction)playButtonAction:(id)sender;
- (IBAction)previousButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;
- (IBAction)sendButtonAction:(id)sender;

- (IBAction)volumeControl:(id)sender;

@property (nonatomic) RecordsService *recordsService;
@property (nonatomic) CCAudioPlayer *audioPlayer;
@property (nonatomic) RecordListItemDataModel *currentRecord;

@property (nonatomic) BOOL isPlayingFromButton;

@end

@implementation RecordDetailsViewController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.recordsService = [[RecordsService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressBar.progress = 0.0;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self _resetStreamer];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configurePlacesOnMap];
}

- (void)updateLocalizations
{
    self.navigationItem.title  = LOC(@"recording_title_key");
    [self.deleteButton setTitle:LOC(@"delete_key") forState:UIControlStateNormal];
    NSString *timeString = LOC(@"time_text_key");
    self.recordTimerLabel.text = [NSString stringWithFormat:@"%@ %@",timeString, self.currentRecord.time];
}

#pragma mark - CusotmizeViews

- (void)configurePlacesOnMap
{
    CGFloat latitude = [self.currentRecord.latitude floatValue];
    CGFloat longitude = [self.currentRecord.longitude floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:9];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude,longitude);
    marker.map = self.gMapView;
    
    [self.gMapView setCamera:camera];
}

#pragma mark - Player

- (void)_resetStreamer
{
    if (_audioPlayer) {
        [_audioPlayer dispose];
        _audioPlayer = nil;
    }
    self.progressBar.progress = 0.0;
    self.isPlayingFromButton = NO;
    if (self.recordsList.count != 0) {
        self.currentRecord = [self.recordsList objectAtIndex:self.selectedIndex];
        
        if (self.currentRecord.isSent) {
            self.sendButton.enabled = NO;
            [self.sendButton setImage:[UIImage imageNamed:@"send_inactive"] forState:UIControlStateNormal];
        } else {
            self.sendButton.enabled = YES;
            [self.sendButton setImage:[UIImage imageNamed:@"send_icon"] forState:UIControlStateNormal];
        }
        self.recordNameLabel.text = self.currentRecord.location;
        NSString *timeString = LOC(@"time_text_key");
        self.recordTimerLabel.text = [NSString stringWithFormat:@"%@ %@",timeString, self.currentRecord.time];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, self.currentRecord.url];
        
        NSURL *audioUrl = [NSURL URLWithString:urlString];
        
        _audioPlayer = [CCAudioPlayer audioPlayerWithContentsOfURL:audioUrl];
        weakify(self);
        [self showLoader];
        [_audioPlayer trackPlayerProgress:^(NSTimeInterval progress) {
            strongify(self);
            NSInteger duration = self.audioPlayer.duration;
            self.durationLabel.text = self.recordDurationLabel.text  = [NSString stringWithFormat:@"00:%02ld", (long)duration];
            self.recordDurationLabel.text  = [NSString stringWithFormat:@"00:%02ld", (long)duration];
            
            NSInteger progressInt = progress;
            self.currentProgress.text = [NSString stringWithFormat:@"00:%02ld", (long)progressInt];
            CGFloat currentProgress = self.audioPlayer.progress/self.audioPlayer.duration;
            

            [UIView animateWithDuration:1.0 animations:^{
                [self.progressBar setProgress:currentProgress animated:YES];
            }];
            
        } playerState:^(CCAudioPlayerState playerState) {
            strongify(self)
            if (playerState == CCAudioPlayerStatePlaying) {
                [self hideLoader];
                [self.playButton setImage:[UIImage imageNamed:@"pause_icon"] forState:UIControlStateNormal];
                if (!self.isPlayingFromButton) {
                    [self.audioPlayer pause];
                }
            }
            if (playerState == CCAudioPlayerStateStopped) {
                [self hideLoader];
                [self.playButton setImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
                self.progressBar.progress = 1.0;
            }
            
            if (playerState == CCAudioPlayerStateError) {
                [self hideLoader];
                [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:LOC(@"something_went_wrong_text_key") cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
            }
            if (playerState == CCAudioPlayerStatePaused) {
                [self.playButton setImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
            }
        }];
        
        [_audioPlayer play];
    }
}

#pragma mark - Actions

- (IBAction)nextButtonAction:(id)sender {
    if (++self.selectedIndex >= [self.recordsList count]) {
        self.selectedIndex = 0;
    }
    
    [self _resetStreamer];
}

- (IBAction)playButtonAction:(id)sender {
    self.isPlayingFromButton = YES;
    if (self.audioPlayer.playerState == CCAudioPlayerStatePlaying) {
        [self.audioPlayer pause];
    } else if (self.audioPlayer.playerState == CCAudioPlayerStatePaused) {
        [self.audioPlayer play];
    } else {
        [self _resetStreamer];
    }
}

- (IBAction)previousButtonAction:(id)sender {
    if (!(--self.selectedIndex <= self.recordsList.count)) {
        self.selectedIndex = [self.recordsList count] - 1;
    }
    
    [self _resetStreamer];
}

- (IBAction)deleteButtonAction:(id)sender
{
    weakify(self)
    [self showLoader];
    [self.recordsService deleteRecord:[NSString stringWithFormat:@"%@",self.currentRecord.recordId] complition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [self hideLoader];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)sendButtonAction:(id)sender
{
    weakify(self)
    [self showLoader];
    NSString *latitude = [NSString stringWithFormat:@"%@", @([Settings sharedInstance].userLocation.coordinate.latitude)];
    NSString *longitude =  [NSString stringWithFormat:@"%@", @([Settings sharedInstance].userLocation.coordinate.longitude)];
    NSDictionary *params = @{@"latitude":latitude,
                             @"longitude": longitude};
    [self.audioPlayer pause];
    [self.recordsService sendEmergencyRecord:[NSString stringWithFormat:@"%@",self.currentRecord.recordId] params:params complition:^(id  _Nonnull response) {
        strongify(self);
        [self hideLoader];
        [self showReocrdSentAlert:self.currentRecord.location recordDate:self.currentRecord.createdAt];
        self.sendButton.enabled = NO;
        [self.sendButton setImage:[UIImage imageNamed:@"send_inactive"] forState:UIControlStateNormal];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self hideLoader];
        [self handleSendingError:error];
    }];
}

- (void)handleSendingError:(NSError *)error
{
    NSDictionary *userInfo = error.userInfo;
    NSString *message = userInfo[@"message"];
    [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:message cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
}

- (IBAction)volumeControl:(UISlider *)sender {
    self.audioPlayer.volume = sender.value;
}

@end
