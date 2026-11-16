//
//  SYLokaliseLocalizationService.h
//  SafeYou
//
//  Optional over-the-air translations. This is the only file that uses the Lokalise
//  SDK. Bundled strings remain the fallback for anything Lokalise doesn't have.
//

#import "SYLocalizationService.h"

@class SYBundleLocalizationService;

NS_ASSUME_NONNULL_BEGIN

@interface SYLokaliseLocalizationService : NSObject <SYLocalizationService>

- (instancetype)initWithProjectID:(NSString *)projectID
                            token:(NSString *)token
                    bundleService:(SYBundleLocalizationService *)bundleService NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
