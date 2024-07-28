//
//  LaunchViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/10/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "LaunchViewController.h"
#import "SYProfileService.h"
#import "SYAuthenticationService.h"
#import "Settings.h"

@interface LaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;

@property (nonatomic) BOOL isBackgroundDataReady;

@property (nonatomic) SYProfileService *profileDataService;
@property (nonatomic) SYAuthenticationService *userTokenService;

@property (nonatomic) NSInteger fetchDataAtemptsCount;

@end

@implementation LaunchViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileDataService = [[SYProfileService alloc] init];
        self.userTokenService = [[SYAuthenticationService alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetConnectionDidLost:) name:InternetConnectionDidLost object:nil];

    [self animateImage];
        
    if ([Settings sharedInstance].userAuthToken.length > 0) {
        [self fetchUsertData];
    } else {
        self.isBackgroundDataReady = YES;
        if ([self.delegate respondsToSelector:@selector(startApplicationInitially)]) {
            [self.delegate startApplicationInitially];
        }
    }
}

- (void)animateImage {
    CGFloat viewFrameWidth = self.launchImageView.frame.size.width;
    CGFloat viewFrameHeight = self.launchImageView.frame.size.height;
    [UIView animateWithDuration:1.0f animations:^{
        self.launchImageView.frame = CGRectMake(-viewFrameWidth, 0, viewFrameWidth, viewFrameHeight);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"LaunchViewController: Deallocated");
}

#pragma mark - Observe InternetConnection Notifications

- (void)observeInternetConnectionStatus
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetConnectionDidConnected:) name:InternetConnectionDidConnected object:nil];
}

#pragma mark - Notifications

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self fetchUsertData];
}

- (void)internetConnectionDidConnected:(NSNotification *)notification
{
    [self fetchUsertData];
}

- (void)internetConnectionDidLost:(NSNotification *)notification
{
    [self observeInternetConnectionStatus];
}

#pragma mark - Fetch initial dtaa

- (void)fetchUsertData
{
    if (![Utilities isNetworkAvailable]) {
        [self showInternetConnectionAlert];
        [self observeInternetConnectionStatus];
        return;
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:InternetConnectionDidConnected object:nil];
    }
    weakify(self);
    [self.profileDataService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        
        self.isBackgroundDataReady = YES;
        if ([self.delegate respondsToSelector:@selector(startApplicationInitially)]) {
            [self.delegate startApplicationInitially];
        }
        if ([Settings sharedInstance].updatedFcmToken && [Settings sharedInstance].updatedFcmToken.length != 0) {
            [self saveFcmToken];
        }
    } failure:^(NSError *error) {
        strongify(self);
        if (self.fetchDataAtemptsCount > 0) {
            self.fetchDataAtemptsCount = 0;
            [self resetUserAuthData];
            if ([self.delegate respondsToSelector:@selector(startApplicationInitially)]) {
                [self.delegate startApplicationInitially];
            }
        } else {
            ++self.fetchDataAtemptsCount;
            [self refreshUserToken];
        }
    }];
}

- (void)saveFcmToken
{
    [self.profileDataService updateUserDataField:@"device_token" value:[Settings sharedInstance].updatedFcmToken withComplition:^(id response) {
        [Settings sharedInstance].savedFcmToken = [Settings sharedInstance].updatedFcmToken;
        [Settings sharedInstance].updatedFcmToken = nil;
    } failure:^(NSError *error) {
        // handle Error
    }];
}

- (void)refreshUserToken
{
    NSString *refreshToken = [Settings sharedInstance].userRefreshToken;
    weakify(self);
    [self.userTokenService refreshToken:refreshToken withComplition:^(id  _Nonnull response) {
        strongify(self);
        [self fetchUsertData];
    } failure:^(NSError * _Nonnull error) {
        strongify(self);
        [self resetUserAuthData];
        self.isBackgroundDataReady = YES;
        if ([self.delegate respondsToSelector:@selector(startApplicationInitially)]) {
            [self.delegate startApplicationInitially];
        }
    }];
}

- (void)resetUserAuthData
{
    [Settings sharedInstance].userPin = @"";
    [Settings sharedInstance].userFakePin = @"";
    [Settings sharedInstance].userAuthToken = @"";
    [Settings sharedInstance].userRefreshToken = @"";
}


#pragma mark - Setter
- (void)setDelegate:(id<LaunchViewControllerDelegate>)delegate
{
    _delegate = delegate;
    if (self.isBackgroundDataReady) {
        if ([self.delegate respondsToSelector:@selector(startApplicationInitially)]) {
            [self.delegate startApplicationInitially];
        }
    }
}

@end
