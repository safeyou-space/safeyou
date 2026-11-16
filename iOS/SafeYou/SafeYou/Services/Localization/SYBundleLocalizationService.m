//
//  SYBundleLocalizationService.m
//  SafeYou
//

#import "SYBundleLocalizationService.h"

static NSString * const kFallbackLanguageCode = @"en";

@interface SYBundleLocalizationService ()

@property (atomic) NSBundle *languageBundle;
@property (atomic) NSBundle *fallbackBundle;
@property (atomic) NSLocale *locale;

@end

@implementation SYBundleLocalizationService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fallbackBundle = [self bundleForLanguageCode:kFallbackLanguageCode] ?: [NSBundle mainBundle];
        // AppleLanguages holds the language chosen in the app, as set by Settings.
        [self setLanguageCode:[NSBundle mainBundle].preferredLocalizations.firstObject ?: kFallbackLanguageCode];
    }
    return self;
}

- (NSLocale *)currentLocale
{
    return self.locale;
}

- (void)start
{
}

- (void)checkForUpdates
{
}

- (void)setLanguageCode:(NSString *)languageCode
{
    self.languageBundle = [self bundleForLanguageCode:languageCode] ?: self.fallbackBundle;
    self.locale = [[NSLocale alloc] initWithLocaleIdentifier:languageCode];
}

- (NSString *)localizedStringForKey:(NSString *)key
{
    NSString *translation = [self.languageBundle localizedStringForKey:key value:@"" table:nil];
    if (translation.length > 0 && ![translation isEqualToString:key]) {
        return translation;
    }
    translation = [self.fallbackBundle localizedStringForKey:key value:@"" table:nil];
    return translation.length > 0 ? translation : key;
}

#pragma mark - Helpers

- (nullable NSBundle *)bundleForLanguageCode:(NSString *)languageCode
{
    NSString *path = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
    if (!path) {
        // For example ka-GE, when only ka.lproj ships.
        NSString *baseCode = [languageCode componentsSeparatedByString:@"-"].firstObject;
        path = [[NSBundle mainBundle] pathForResource:baseCode ofType:@"lproj"];
    }
    return path ? [NSBundle bundleWithPath:path] : nil;
}

@end
