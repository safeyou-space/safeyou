//
//  Utilities.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)fetchTranslationForKey:(NSString *)locKey
{
    NSString *translation;
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([Settings sharedInstance].selectedLanguageCode.length > 0) {
        languageCode = [Settings sharedInstance].selectedLanguageCode;
    }
    NSBundle *currentLanBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"]];
    translation =  NSLocalizedStringFromTableInBundle(locKey, @"Localizable", currentLanBundle, @"");
    if(translation == nil) {
        return locKey;
    } else {
        if (!([translation isEqual:locKey])) {
            return translation;
        } else {
            translation = NSLocalizedStringFromTableInBundle(locKey, @"Module", currentLanBundle, @"");
            if (!([translation isEqual:locKey])) {
                return translation;
            }
        }
    }
    return locKey;
}

@end
