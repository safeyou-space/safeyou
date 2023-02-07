//
//  Settings.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/29/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@class UserDataModel, CountryDataModel, LanguageDataModel;

@interface Settings : NSObject

+ (instancetype)sharedInstance;

- (void)resetUserData;

@property (nonatomic, readonly) BOOL isFirstLaunch;
@property (nonatomic) BOOL isFirstLogin;
@property (nonatomic) NSString *userPin;
@property (nonatomic) NSString *userFakePin;

@property (nonatomic) NSString *userAuthToken;
@property (nonatomic) NSString *userRefreshToken;

@property (nonatomic) BOOL isLocationGranted;
@property (nonatomic) CLLocation *userLocation;
@property (nonatomic) NSString *userLocationName;

@property (nonatomic) BOOL isPopupShown;
@property (nonatomic, readonly) BOOL isDualPinEnabled;
@property (nonatomic, readonly) BOOL isCamouflageIconEnabled;
@property (nonatomic, readonly) NSString *camouflageIconName;

@property (nonatomic) UserDataModel *onlineUser;

@property (nonatomic, readonly) CountryDataModel *selectedCountry;
@property (nonatomic, readonly) LanguageDataModel *selectedLanguage;

- (void)setSelectedCountry:(CountryDataModel *)selectedCountry;
- (void)setSelectedLanguage:(LanguageDataModel *)selectedLanguage;

@property (nonatomic, readonly) NSString *selectedCountryCode;
@property (nonatomic, readonly) NSString *selectedLanguageCode;
@property (nonatomic, readonly) NSString *localizationsLanguageCode;

@property (nonatomic, readonly) NSString *socketIOURL;
@property (nonatomic, readonly) NSString *socketAPIURL;

@property (nonatomic) BOOL termsAreAccepted;

@property (nonatomic) NSString *baseAPIURL;

@property (nonatomic) NSString *savedFcmToken;
@property (nonatomic) NSString *updatedFcmToken;

@property (nonatomic) NSDictionary *receivedRemoteNotification;
@property (nonatomic) NSURL *dynamicLinkUrl;

- (BOOL)isLanguageRTL;

- (void)saveUserAddress;
- (void)activateUsingDualPin:(BOOL)activate;
- (void)activateUsingCamouflageIcon:(BOOL)activate iconName:(NSString *)iconName;

- (NSString *)countryPhoneCode;
- (NSString *)countryPhoneCodeWhtoutPlusSign;

@end

