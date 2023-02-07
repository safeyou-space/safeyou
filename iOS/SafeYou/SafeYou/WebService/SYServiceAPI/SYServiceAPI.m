//
//  SYServiceAPI.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
#import "Settings.h"
#import "UserDataModel.h"

@implementation SYServiceAPI

- (NSString *)endpoint
{
    return nil;
}

- (SYHTTPSessionManager *)networkManagerWithUrl:(NSString *)urlString
{
    Settings *settings = [Settings sharedInstance];
        NSString *token = settings.userAuthToken;
        NSDictionary *headerParams;
    
        SYHTTPSessionManager *manager = [SYHTTPSessionManager sessionManagerWithBaseURL:urlString headerParams:headerParams configuration:nil];
        return manager;
}

- (SYHTTPSessionManager *)networkManager
{
    Settings *settings = [Settings sharedInstance];
    NSString *token = settings.userAuthToken;
    NSDictionary *headerParams;
    
    NSString *baseURL = [NSString stringWithFormat:BASE_API_URL, settings.selectedCountryCode, settings.selectedLanguageCode];
    
    if (settings.selectedCountryCode.length > 0 && settings.selectedLanguageCode.length > 0) {
        baseURL = [NSString stringWithFormat:BASE_API_URL, settings.selectedCountryCode, settings.selectedLanguageCode];
    }
    
    SYHTTPSessionManager *manager = [SYHTTPSessionManager sessionManagerWithBaseURL:baseURL headerParams:headerParams configuration:nil];
    return manager;
}

@end
