//
//  SYLocalizationService.m
//  SafeYou
//

#import "SYLocalizationService.h"
#import "SYBundleLocalizationService.h"
#import "SYLokaliseLocalizationService.h"

static NSString * const kLokaliseProjectIDInfoKey = @"LokaliseProjectID";
static NSString * const kLokaliseTokenInfoKey = @"LokaliseToken";

@implementation SYLocalization

+ (id<SYLocalizationService>)sharedService
{
    static id<SYLocalizationService> service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        NSString *projectID = info[kLokaliseProjectIDInfoKey];
        NSString *token = info[kLokaliseTokenInfoKey];
        SYBundleLocalizationService *bundleService = [[SYBundleLocalizationService alloc] init];
        if (projectID.length > 0 && token.length > 0) {
            service = [[SYLokaliseLocalizationService alloc] initWithProjectID:projectID
                                                                         token:token
                                                                 bundleService:bundleService];
        } else {
            service = bundleService;
        }
    });
    return service;
}

@end
