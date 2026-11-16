//
//  SYLokaliseLocalizationService.m
//  SafeYou
//

#import "SYLokaliseLocalizationService.h"
#import "SYBundleLocalizationService.h"
#import <Lokalise/Lokalise.h>

@interface SYLokaliseLocalizationService ()

@property (nonatomic) SYBundleLocalizationService *bundleService;

@end

@implementation SYLokaliseLocalizationService

- (instancetype)initWithProjectID:(NSString *)projectID
                            token:(NSString *)token
                    bundleService:(SYBundleLocalizationService *)bundleService
{
    self = [super init];
    if (self) {
        _bundleService = bundleService;
        [[Lokalise sharedObject] setProjectID:projectID token:token];
#if DEBUG
        [Lokalise sharedObject].localizationType = LokaliseLocalizationPrerelease;
#endif
    }
    return self;
}

- (NSLocale *)currentLocale
{
    return self.bundleService.currentLocale;
}

- (void)start
{
    [self applyLocale:self.bundleService.currentLocale];
}

- (void)setLanguageCode:(NSString *)languageCode
{
    [self.bundleService setLanguageCode:languageCode];
    [self applyLocale:self.bundleService.currentLocale];
}

- (NSString *)localizedStringForKey:(NSString *)key
{
    NSString *bundledString = [self.bundleService localizedStringForKey:key];
    return [[Lokalise sharedObject] localizedStringForKey:key value:bundledString table:nil];
}

- (void)checkForUpdates
{
    [[Lokalise sharedObject] checkForUpdatesWithCompletion:^(BOOL updated, NSError * _Nullable error) {
        NSLog(@"Lokalise updated: %d, error: %@", updated, error);
    }];
}

#pragma mark - Helpers

- (void)applyLocale:(NSLocale *)locale
{
    [[Lokalise sharedObject] setLocalizationLocale:locale makeDefault:NO completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Lokalise setLocalizationLocale failed: %@", error);
        }
    }];
}

@end
