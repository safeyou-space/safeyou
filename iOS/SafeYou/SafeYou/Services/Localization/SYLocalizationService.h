//
//  SYLocalizationService.h
//  SafeYou
//
//  The single entry point for translated strings. The rest of the app depends
//  on this protocol, never on a localization vendor.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYLocalizationService <NSObject>

@property (nonatomic, readonly) NSLocale *currentLocale;

- (void)start;
- (NSString *)localizedStringForKey:(NSString *)key;
- (void)setLanguageCode:(NSString *)languageCode;
- (void)checkForUpdates;

@end

@interface SYLocalization : NSObject

/// Uses Lokalise when build credentials are present, otherwise bundled strings only.
@property (class, nonatomic, readonly) id<SYLocalizationService> sharedService;

@end

NS_ASSUME_NONNULL_END
