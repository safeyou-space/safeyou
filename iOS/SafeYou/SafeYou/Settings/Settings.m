//
//  Settings.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/29/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "Settings.h"
#import <GoogleMaps/GMSGeocoder.h>
#import "RegionalOptionDataModel.h"

static NSString * const kUserDefaultsIsFirstLogin = @"isFirsLogin";
static NSString * const kUserDefaultsIsFirstLaunch = @"isFirsLaunch";
static NSString * const kUserDefaultsUserPin = @"userPin";
static NSString * const kUserDefaultsUserFakePin = @"userFakePin";
static NSString * const kUserDefaultsSelectedLanguage = @"userSelectedAppLanguage";
static NSString * const kUserDeafultsAuthToken = @"userAuthToken";
static NSString * const kUserDefaultsAuthRefreshToken = @"userAuthRefreshToken";
static NSString * const kUserDefaultsLocationGranted = @"userLocationIsGrantedKey";
static NSString * const kUserDefaultsUserLocationName = @"userLocationNameKey";
static NSString * const kUserDefaultsIsPopupShown = @"userIsPopupShownKey";
static NSString * const kUserDefaultsIsDualPinEnabled = @"appSettingsIsDualPinEnabled";
static NSString * const kUserDefaultsTermsAreAccepted = @"appLaunchTermsAreAccepted";
static NSString * const kUserDefaultsIsCamouflageIconEnabled = @"appSettingsIsCamouflageIconEnabled";
static NSString * const kUserDefaultsCamouflageIconName = @"appSettingsIsCamouflageIconName";

static NSString * const kUserDefaultsSelectedCountryData = @"appSettingsSelectedCountryData";
static NSString * const kUserDefaultsSelectedLanguageData = @"appSettingsSelectedLanguageData";

static NSString * const kUserDefaultsSavedFcmToken = @"appSettingsSavedFcmToken";

@implementation Settings

@synthesize isDualPinEnabled = _isDualPinEnabled;
@synthesize selectedCountry = _selectedCountry;
@synthesize selectedLanguage = _selectedLanguage;


@synthesize selectedLanguageCode = _selectedLanguageCode;
@synthesize selectedCountryCode = _selectedCountryCode;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self retreive];
    }
    
    return self;
}

#pragma Reset user Data (Logout)

- (void)resetUserData
{
    self.userPin = nil;
    self.userFakePin = nil;
    self.userAuthToken = nil;
    self.userRefreshToken = nil;
}

#pragma mark - User Location

- (void)setUserLocation:(CLLocation *)userLocation
{
    _userLocation = userLocation;
    [self saveUserAddress];
}

- (void)setUserLocationName:(NSString *)userLocationName
{
    _userLocationName = userLocationName;
    [[NSUserDefaults standardUserDefaults] setValue:_userLocationName forKey:kUserDefaultsUserLocationName];
}

- (void)setIsPopupShown:(BOOL)isPopupShown
{
    _isPopupShown = isPopupShown;
    [[NSUserDefaults standardUserDefaults] setObject:@(_isPopupShown) forKey:kUserDefaultsIsPopupShown];
    
}

- (void)saveUserAddress
{
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    
    [geocoder reverseGeocodeCoordinate:self.userLocation.coordinate completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
        if (!error) {
            GMSAddress *userAddress = response.firstResult;
            NSMutableString *userLocation = [[NSMutableString alloc] init];
            
            if (userAddress.lines && userAddress.lines.count > 0) {
                self.userLocationName = userAddress.lines.firstObject;
            } else {
                if (userAddress.locality) {
                    [userLocation appendString:userAddress.locality];
                }
                if (userAddress.subLocality) {
                    if (userLocation.length > 0) {
                        [userLocation appendString:[NSString stringWithFormat:@" %@", userAddress.subLocality]];
                    }
                }
                if (userLocation.length > 0) {
                    self.userLocationName = userLocation;
                }
            }
        }
    }];
}

- (void)activateUsingDualPin:(BOOL)activate
{
    _isDualPinEnabled = activate;
    if (!_isDualPinEnabled) {
        self.userFakePin = nil;
        self.userPin = nil;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_isDualPinEnabled forKey:kUserDefaultsIsDualPinEnabled];
}

- (void)activateUsingCamouflageIcon:(BOOL)activate iconName:(NSString *)iconName;
{
    _isCamouflageIconEnabled = activate;
    _camouflageIconName = iconName;
    [[NSUserDefaults standardUserDefaults] setBool:_isCamouflageIconEnabled forKey:kUserDefaultsIsCamouflageIconEnabled];
    [[NSUserDefaults standardUserDefaults] setValue:_camouflageIconName forKey:kUserDefaultsCamouflageIconName];
}

#pragma mark - Setter

- (void)setOnlineUser:(UserDataModel *)onlineUser
{
    _onlineUser = onlineUser;
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDataDidUpdateNotificationName object:nil];
}

- (void)setUserAuthToken:(NSString *)userAuthToken
{
    _userAuthToken = userAuthToken;
    if (_userAuthToken == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDeafultsAuthToken];
    } else {
    [[NSUserDefaults standardUserDefaults] setValue:self.userAuthToken forKey:kUserDeafultsAuthToken];
    }
}

- (void)setUserRefreshToken:(NSString *)userRefreshToken
{
    _userRefreshToken = userRefreshToken;
    if (_userRefreshToken == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsAuthRefreshToken];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:self.userRefreshToken forKey:kUserDefaultsAuthRefreshToken];
    }
    
}

- (void)setIsFirstLogin:(BOOL)isFirstLogin
{
    _isFirstLogin = isFirstLogin;
    [[NSUserDefaults standardUserDefaults] setValue:@(self.isFirstLogin) forKey:kUserDefaultsIsFirstLogin];
}

- (void)setSelectedLanguageCode:(NSString *)language
{
    _selectedLanguageCode = language;
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationLanguageDidChangeNotificationName object:nil];
    [[NSUserDefaults standardUserDefaults] setValue:self.selectedLanguageCode forKey:kUserDefaultsSelectedLanguage];
}

- (void)setSelectedCountryCode:(NSString *)selectedCountryCode
{
    _selectedCountryCode = selectedCountryCode;
    
}

- (void)setSelectedLanguage:(LanguageDataModel *)selectedLanguage
{
    _selectedLanguage = selectedLanguage;
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_selectedLanguage];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kUserDefaultsSelectedLanguageData];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationLanguageDidChangeNotificationName object:nil];
}

- (void)setSelectedCountry:(CountryDataModel *)selectedCountry
{
    _selectedCountry = selectedCountry;
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_selectedCountry];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kUserDefaultsSelectedCountryData];
    [defaults synchronize];
}

- (void)setSavedFcmToken:(NSString *)savedFcmToken
{
    _savedFcmToken = savedFcmToken;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_savedFcmToken forKey:kUserDefaultsSavedFcmToken];
    [defaults synchronize];
}

#pragma mark - Getter
/**

 */
- (NSString *)socketIOURL
{
    BOOL debug = NO;
#ifdef DEBUG
    debug = DEBUG;
#endif
    if ([self.selectedCountry.shortCode isEqualToString:@"arm"]) {
        if (debug) {
            return @"https://localhost:3333/";
        } else {
            return @"https://localhost:333";
        }
    }
    
    if ([self.selectedCountry.shortCode isEqualToString:@"geo"]) {
        if (debug) {
            return @"https://localhost:3334/";
        } else {
            return @"https://localhost:334";
        }
    }
    
    if (debug) {
        return @"http://localhost:2222";
    }
    return @"https://localhost:222";
}

- (NSString *)selectedCountryCode
{
    if (self.selectedCountry) {
        return self.selectedCountry.shortCode;
    }
    return @"arm";
}

- (NSString *)selectedLanguageCode
{
    if (self.selectedLanguage) {
        return self.selectedLanguage.shortCode;
    }
    return @"en";
}

- (void)setUserPin:(NSString *)userPin
{
    BOOL isUpdate = _userPin.length > 0;
    _userPin = userPin;
    if (_userPin == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserPin];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.userPin forKey:kUserDefaultsUserPin];
    }
    
    if (isUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserPinChangedNotificationName object:nil];
    }
}

- (void)setUserFakePin:(NSString *)userFakePin
{
    _userFakePin = userFakePin;
    if (_userFakePin == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserFakePin];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:_userFakePin forKey:kUserDefaultsUserFakePin];
    }
    
}

- (void)setTermsAreAccepted:(BOOL)termsAreAccepted
{
    _termsAreAccepted = termsAreAccepted;
    [[NSUserDefaults standardUserDefaults] setBool:_termsAreAccepted forKey:kUserDefaultsTermsAreAccepted];
}

#pragma mark - NSUserDefaults

- (void)retreive
{
//    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsSelectedLanguage];
//    self.selectedLanguageCode = language;
    
    self.userAuthToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDeafultsAuthToken];
    
    self.userRefreshToken = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsAuthRefreshToken];
    
    self.isFirstLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsIsFirstLogin] boolValue];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsIsFirstLaunch]) {
        _isFirstLaunch = NO;
    } else {
        _isFirstLaunch = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:kUserDefaultsIsFirstLaunch];
    }
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsIsPopupShown]) {
        _isPopupShown = NO;
    } else {
        _isPopupShown = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsIsPopupShown];
    }
    
    self.userFakePin = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsUserFakePin];
    
    self.userPin = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsUserPin];
    
    self.userLocationName = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsUserLocationName];
    
    _isDualPinEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsIsDualPinEnabled];
    
    _isCamouflageIconEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsIsCamouflageIconEnabled];
    _camouflageIconName = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsCamouflageIconName];
    
    _termsAreAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsTermsAreAccepted];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedCountryData = [defaults objectForKey:kUserDefaultsSelectedCountryData];
    CountryDataModel *decodedCountry = [NSKeyedUnarchiver unarchiveObjectWithData:encodedCountryData];
    _selectedCountry = decodedCountry;
    
    
    NSData *encodedLanguageData = [defaults objectForKey:kUserDefaultsSelectedLanguageData];
    LanguageDataModel *decodedLanguage = [NSKeyedUnarchiver unarchiveObjectWithData:encodedLanguageData];
    _selectedLanguage = decodedLanguage;
    
    _savedFcmToken = [defaults objectForKey:kUserDefaultsSavedFcmToken];
}

- (void)setIsLocationGranted:(BOOL)isLocationGranted
{
    _isLocationGranted = isLocationGranted;
    [[NSUserDefaults standardUserDefaults] setValue:@(_isLocationGranted) forKey:kUserDefaultsLocationGranted];
}

+ (instancetype)sharedInstance
{
    static Settings* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Settings alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)countryPhoneCode
{
    if ([self.selectedCountryCode isEqualToString:@"arm"]) {
        return @"+374";
    }
    
    if ([self.selectedCountryCode isEqualToString:@"geo"]) {
        return @"+995";
    }
    
    return @"+374";
}

- (NSString *)countryPhoneCodeWhtoutPlusSign
{
    if ([self.selectedCountryCode isEqualToString:@"arm"]) {
        return @"374";
    }
    
    if ([self.selectedCountryCode isEqualToString:@"geo"]) {
        return @"995";
    }
    
    return @"374";
}


@end
