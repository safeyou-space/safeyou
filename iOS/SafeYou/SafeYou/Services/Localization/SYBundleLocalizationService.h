//
//  SYBundleLocalizationService.h
//  SafeYou
//
//  Serves the Localizable.strings files shipped in the app. Looks in the selected
//  language first, then English, then returns the key.
//

#import "SYLocalizationService.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBundleLocalizationService : NSObject <SYLocalizationService>

@end

NS_ASSUME_NONNULL_END
