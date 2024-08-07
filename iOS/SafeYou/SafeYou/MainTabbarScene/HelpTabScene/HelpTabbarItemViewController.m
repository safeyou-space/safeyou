//
//  HelpTabbarItemViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/15/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RecordViewState) {
    RecordViewStateNormal,
    RecordViewStateRecording,
    RecordViewStateRecordingFinished
};

#import "HelpTabbarItemViewController.h"
#import "RecordButton.h"
#import <AVKit/AVKit.h>
#import "RecordsService.h"
#import "ExtAudioConverter.h"
#import "HelpService.h"
#import "UserDataModel.h"
#import "EmergencyContactDataModel.h"
#import "SYViewController+StyledAlerts.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "RecordDataModel.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define RECORD_MAX_DURATION 60

@interface HelpTabbarItemViewController () <RecordButtonDelegate, AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet SYLabelRegular *timerLabel;

@property (weak, nonatomic) IBOutlet SYDesignableView *helpButtonLargeCircle;
@property (weak, nonatomic) IBOutlet SYDesignableView *helpButtonSmallCircle;
@property (weak, nonatomic) IBOutlet RecordButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *emergencyContactsView;
@property (weak, nonatomic) IBOutlet UIView *recordingsView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *emergencyContactsTapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *reconrdingsTapGesture;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

// icons
@property (weak, nonatomic) IBOutlet SYDesignableImageView *contactsIcon;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *ngosIcon;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *policeIcon;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *recordingsStoreIcon;

@property (weak, nonatomic) IBOutlet SYLabelLight *infoMessageLabel;

@property (weak, nonatomic) IBOutlet SYLabelBold *emergencyContactsLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *recordingsLabel;

- (IBAction)emergencyContactsTapped:(UITapGestureRecognizer *)sender;
- (IBAction)recordingsTapped:(UITapGestureRecognizer *)sender;

@property (nonatomic) RecordViewState recordViewState;
@property (nonatomic) RecordsService *recordsService;

@property (nonatomic) NSUInteger recordMinutes;
@property (nonatomic) NSUInteger recordSeconds;
@property (nonatomic) NSTimer *recordTimer;
@property (nonatomic) NSTimer *recordTimerMax;

@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) NSString *recorderTempFilePath;
@property (nonatomic) NSString *mp3TempFilePath;
@property (nonatomic) NSString *recordsFolderPath;

@property (nonatomic) HelpService *helpService;
@property (nonatomic) NSTimeInterval recordTimeInterval;

@property (weak, nonatomic) AppDelegate *appDelegate;

@property (nonatomic, assign) BOOL isCancelingRecord;
@property (nonatomic, assign) BOOL isQuickSend;
@property (nonatomic, assign) BOOL isRecordPerrmissionGranted;

@end

@implementation HelpTabbarItemViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.recordsService = [[RecordsService alloc] init];
        self.helpService = [[HelpService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    weakify(self);
    [self checkMicrophonePermissions:^(BOOL allowed) {
        strongify(self)
        if (allowed) {
            strongify(self);
            self.isRecordPerrmissionGranted = YES;
        } else {
            self.isRecordPerrmissionGranted = NO;
        }
    }];
    self.recordViewState = RecordViewStateNormal;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.recordingsView.isAccessibilityElement = YES;
    self.recordingsView.accessibilityLabel = LOC(@"my_recordings");
    self.recordingsView.shouldGroupAccessibilityChildren = YES;
    self.recordingsView.accessibilityTraits = UIAccessibilityTraitButton;
    
    self.emergencyContactsView.isAccessibilityElement = YES;
    self.emergencyContactsView.accessibilityLabel = LOC(@"emergency_contacts_title_key");
    self.emergencyContactsView.shouldGroupAccessibilityChildren = YES;
    self.emergencyContactsView.accessibilityTraits = UIAccessibilityTraitButton;
    
    [self configureNavigationBar];
    [self configureNavigationLeftItem];
    [self setWhiteColorTypeOnNotificationIcon];
}

- (void)checkMicrophonePermissions:(void (^)(BOOL allowed))completion {
    AVAudioSessionRecordPermission status = [[AVAudioSession sharedInstance] recordPermission];
    switch (status) {
        case AVAudioSessionRecordPermissionGranted:
            if (completion) {
                completion(YES);
            }
            break;
        case AVAudioSessionRecordPermissionDenied:
        {
            // Optionally show alert with option to go to Settings

            if (completion) {
                completion(NO);
            }
        }
            break;
        case AVAudioSessionRecordPermissionUndetermined:
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted && completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(granted);
                    });
                }
            }];
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureEmergencyIcons];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self configureWingImages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![Settings sharedInstance].isPopupShown) {
        [self showInfoAlert];
        [Settings sharedInstance].isPopupShown = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //Enable Device AutoLock
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    self.helpButtonLargeCircle.cornerRadius = self.helpButtonLargeCircle.frame.size.width/2;
    self.helpButtonSmallCircle.cornerRadius = self.helpButtonSmallCircle.frame.size.width/2;
    [super viewDidLayoutSubviews];
}

#pragma mark - UI Customization

- (void)configureBackgroundColor
{
    // override empty
}

- (void)configureEmergencyIcons
{
    UserDataModel *onlineUser = [Settings sharedInstance].onlineUser;
    if (onlineUser.emergencyContacts.count) {
        self.contactsIcon.imageColorType = SYColorTypeNavyBlue;
    } else {
        self.contactsIcon.imageColorType = SYColorTypeDarkGray;
    }
    
    if (onlineUser.emergencyServices.count) {
        self.ngosIcon.imageColorType = SYColorTypeNavyBlue;
    } else {
        self.ngosIcon.imageColorType = SYColorTypeDarkGray;
    }
    
    if (onlineUser.checkPolice) {
        self.policeIcon.imageColorType = SYColorTypeNavyBlue;
    } else {
        self.policeIcon.imageColorType = SYColorTypeDarkGray;
    }
    
    if (onlineUser.records.recordId) {
        self.recordingsStoreIcon.imageColorType = SYColorTypeNavyBlue;
    } else {
        self.recordingsStoreIcon.imageColorType = SYColorTypeDarkGray;
    }
}

- (void)configureNavigationBar
{
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    appearance.backgroundColor = [UIColor navyBlueColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
}

#pragma Getter

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - UI State

- (void)setRecordViewState:(RecordViewState)recordViewState
{
    _recordViewState = recordViewState;
    [self configureActionButtons];
}

- (void)configureActionButtons
{
    switch (self.recordViewState) {
        case RecordViewStateNormal: {
            self.timerLabel.text = @"00:00";
            self.timerLabel.hidden = YES;
            break;
        }
            
        case RecordViewStateRecording: {
            self.timerLabel.hidden = NO;
            break;
        }
        case RecordViewStateRecordingFinished: {
            self.timerLabel.hidden = YES;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Initializers

- (void)createRecordsFolder
{
    NSError *error;
    NSString *dataPath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"/Records"];
    
    self.recordsFolderPath = dataPath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

- (void)initializeAudioRecorder
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

    NSString *name = @"temp_audio";
    self.recorderTempFilePath = [NSString stringWithFormat:@"%@/%@.aac", DOCUMENTS_FOLDER, name];
    
    NSURL *url = [NSURL fileURLWithPath:self.recorderTempFilePath];
    err = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!self.recorder){
        NSLog(@"recorder: %@ %@ %@", [err domain], @([err code]), [[err userInfo] description]);
        [self showAlertViewWithTitle:@"Warning" withMessage:[err localizedDescription] cancelButtonTitle:@"OK" okButtonTitle:nil cancelAction:nil okAction:nil];
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.isInputAvailable;
    if (! audioHWAvailable) {
        [self showAlertViewWithTitle:@"Warning" withMessage:@"Audio input hardware not available" cancelButtonTitle:@"OK" okButtonTitle:nil cancelAction:nil okAction:nil];
        
        return;
    }
}

#pragma mark - Timer

- (NSString*)getTimeStr:(NSInteger)secondsElapsed {
    
    NSInteger seconds = secondsElapsed % 60;
    NSInteger minutes = secondsElapsed / 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (void)timerController {
    self.recordSeconds++;
    [self.timerLabel setText:[self getTimeStr:self.recordSeconds]];
}

#pragma mark - Record Button Delegate

- (void)startRecordTimer
{
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    }];
}

- (void)recordButtonDidStartRecording:(RecordButton *)sender
{
    if (![Settings sharedInstance].isLocationGranted) {
        [sender reset];
        [self showOpenLocationSettingsAlert];
    } else if (!self.isRecordPerrmissionGranted) {
        [sender reset];
        [self showOpenMicrophoneSettingsAlert];
    } else {
        [self startRecording];
    }
}

- (void)recordButtonDidStopRecording:(RecordButton *)recordButton
{
    [self stopRecording];
    // @TODO: Clarify functionality
}

- (void)convertToMp3AndSave {
    NSString *inputPath = self.recorderTempFilePath;//[[NSBundle mainBundle] pathForResource:@"source" ofType:@"m4a"];
    self.recordTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"record_%@.mp3", @(self.recordTimeInterval)];
    NSURL *outputURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:fileName];
    self.mp3TempFilePath = outputURL.path;

    ExtAudioConverter *converter = [[ExtAudioConverter alloc] init];
    converter.inputFile = inputPath;
    converter.outputFile = self.mp3TempFilePath;
    converter.outputFormatID = kAudioFormatMPEGLayer3;
    if ([converter convert]) {
        [self addRecord:self.mp3TempFilePath];
    } else {
        
    }
}

- (void)cancelRecordAndDelete
{
    self.recordSeconds = 0;
    self.recordMinutes = 0;
    [self.recordTimer invalidate];
    self.recordTimer = nil;
    self.recordViewState = RecordViewStateNormal;
    NSError *removeError;
    [[NSFileManager defaultManager] removeItemAtPath:self.recorderTempFilePath error:&removeError];
    self.recordViewState = RecordViewStateNormal;
}

#pragma mark - Microphone Alert

- (void)showOpenMicrophoneSettingsAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOC(@"Microphone Access") message:LOC(@"Please go to Settings to enable Microphone to record emergency audio") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LOC(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:LOC(@"settings_title") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL options:APPLICATION_URL_DEFAULT_SETTINGS completionHandler:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// @TODO: Dublicate code fast sulotion
- (void)showOpenLocationSettingsAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOC(@"Location Access") message:LOC(@"We need access to yout location to record emergency audio") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LOC(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:LOC(@"settings_title") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL options:APPLICATION_URL_DEFAULT_SETTINGS completionHandler:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Override

- (void)updateLocalizations
{
    self.infoMessageLabel.text = LOC(@"help_section_description_text_key");
    self.recordingsLabel.text = LOC(@"my_recordings");
    self.emergencyContactsLabel.text = LOC(@"emergency_contacts_title_key");
    [self.recordButton updateLocalizations];
}

#pragma mark - Record Audio

- (void)startRecording
{
    [self sendEmergencyMessage];
    // start recording
    self.timerLabel.text = @"00:00";
    self.recordViewState = RecordViewStateRecording;
    [self initializeAudioRecorder];
    [self.recorder recordForDuration:(NSTimeInterval) RECORD_MAX_DURATION];
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(timerController)
                                                      userInfo:nil
                                        	               repeats:YES];
}

- (void)sendEmergencyMessage
{
    if (![Settings sharedInstance].isLocationGranted) {
        return;
    }
    weakify(self);
    [self.helpService sendEmergencyMessgaeComplition:^(id  _Nonnull response) {
        strongify(self);
        [self showMessageSentAlert];
    } failure:^(NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"message"];
        [self showAlertViewWithTitle:LOC(@"error_text_key") withMessage:errorMessage cancelButtonTitle:LOC(@"ok") okButtonTitle:nil cancelAction:nil okAction:nil];
    }];
}

- (void)stopRecording {
    [self.recordButton reset];
    [self.recorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    [self.recordButton reset];
    self.recorder = nil;
    [self.recordTimer invalidate];
    if (self.recordViewState == RecordViewStateRecording) {
        self.recordViewState = RecordViewStateRecordingFinished;
    }
    if (!self.isCancelingRecord) {
        [self convertToMp3AndSave];
    }
    self.recordSeconds = 0;
    self.recordMinutes = 0;
    self.isCancelingRecord = NO;
}


#pragma mark - Actions
- (IBAction)emergencyContactsTapped:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"showemergencyContacts" sender:nil];
}

- (IBAction)recordingsTapped:(UITapGestureRecognizer *)sender {
    if (self.recordViewState == RecordViewStateNormal) {
        [self performSegueWithIdentifier:@"showRecordsList" sender:nil];
    }
    
    if (self.recordViewState == RecordViewStateRecordingFinished) {
        [self performSegueWithIdentifier:@"showRecordsList" sender:nil];
    }
    
    if (self.recordViewState == RecordViewStateRecording) {
        self.isQuickSend = YES;
        [self stopRecording];
    }
}

- (IBAction)sendNewSavedRecord
{

}


#pragma mark - API
- (void)addRecord:(NSString *)filePath
{
    
    NSString *location = [Settings sharedInstance].userLocationName;
    NSString *latitude = @"-1";
    NSString *longitude = @"-1";
    if ([Settings sharedInstance].isLocationGranted) {
        latitude = [NSString stringWithFormat:@"%@",@([Settings sharedInstance].userLocation.coordinate.latitude)];
        longitude = [NSString stringWithFormat:@"%@",@([Settings sharedInstance].userLocation.coordinate.longitude)];
    }
    
    NSString *send = @"false";
    if (self.isQuickSend) {
        send = @"true";
    }
    NSDictionary *recordParams = @{
        @"name"         : [NSString stringWithFormat:@"%@", @(self.recordTimeInterval)],
        @"location"     : location,
        @"latitude"     : latitude,
        @"longitude"    : longitude,
        @"duration"     : [NSString stringWithFormat:@"%@",@(self.recordSeconds)],
        @"date"         : [self dateStreingFormTimeInterval:self.recordTimeInterval],
        @"time"         : [self timeStringFromTimeInterval:self.recordTimeInterval],
        @"send"         : send
    };
    weakify(self);
    [self showLoader];
    [self.recordsService addRecord:filePath params:recordParams complition:^(id response) {
        strongify(self);
        [self hideLoader];
        if (self.isQuickSend) {
            NSString *message = response[@"message"];
            if (message) {
                [self showStyledAlertWithTitle:LOC(@"success_text_key") message:message];
            }
            self.isQuickSend = NO;
        } else {
            [self showReocrdSavedAlert];
        }
    } failure:^(NSError * _Nonnull error) {
        // @TODO: handle error show alert or not
    }];
}

#pragma mark - Helper

- (NSString *)dateStreingFormTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSString *timeString = [dateFormatter stringFromDate:recordDate];
    return timeString;
}

- (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *timeString = [timeFormatter stringFromDate:recordDate];
    return timeString;
}

- (void)helpTabBarButtonPressed {
    [self.recordButton recordButtonDidStartPressed:self.recordButton];
}

- (void)helpTabBarButtonPressedUp {
    [self.recordButton recordButtonDidStopPressed:self.recordButton];
}

- (void)configureNavigationLeftItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo_white_state"] style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)configureWingImages
{
    if ([[Settings sharedInstance] isLanguageRTL]) {
        self.leftImageView.image = [UIImage imageNamed:@"right_wing"];
        self.rightImageView.image = [UIImage imageNamed:@"left_wing"];
    } else {
        self.leftImageView.image = [UIImage imageNamed:@"left_wing"];
        self.rightImageView.image = [UIImage imageNamed:@"right_wing"];
    }
}

@end
