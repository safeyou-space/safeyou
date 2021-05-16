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
    if ([Settings sharedInstance].userAuthToken.length > 0) {
        [self fetchUsertData];
    } else {
        self.isBackgroundDataReady = YES;
        if ([self.delegate respondsToSelector:@selector(applicationIsReadyToStart)]) {
            [self.delegate applicationIsReadyToStart];
        }
    }
}

#pragma mark - Fetch initial dtaa

- (void)fetchUsertData
{
    weakify(self);
    [self.profileDataService getUserDataWithComplition:^(UserDataModel *userData) {
        strongify(self);
        
        [Settings sharedInstance].onlineUser = userData;
        self.isBackgroundDataReady = YES;
        if ([self.delegate respondsToSelector:@selector(applicationIsReadyToStart)]) {
            [self.delegate applicationIsReadyToStart];
        }
        if ([Settings sharedInstance].updatedFcmToken && [Settings sharedInstance].updatedFcmToken.length != 0) {
            [self saveFcmToken];
        }
    } failure:^(NSError *error) {
        strongify(self);
        if (self.fetchDataAtemptsCount > 0) {
            self.fetchDataAtemptsCount = 0;
            [self resetUserAuthData];
            if ([self.delegate respondsToSelector:@selector(applicationIsReadyToStart)]) {
                [self.delegate applicationIsReadyToStart];
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
        if ([self.delegate respondsToSelector:@selector(applicationIsReadyToStart)]) {
            [self.delegate applicationIsReadyToStart];
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
        if ([self.delegate respondsToSelector:@selector(applicationIsReadyToStart)]) {
            [self.delegate applicationIsReadyToStart];
        }
    }
}

@end
