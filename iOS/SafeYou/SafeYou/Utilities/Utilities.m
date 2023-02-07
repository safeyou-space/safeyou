//
//  Utilities.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <AFNetworking.h>
#import "Utilities.h"
#import "RegionalOptionDataModel.h"


@implementation Utilities

+ (NSString *)fetchTranslationForKey:(NSString *)locKey
{
    return NSLocalizedString(locKey, locKey);
}

+ (BOOL)isNetworkAvailable
{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        return YES;
    } else {
        return  NO;
    }
}

@end
