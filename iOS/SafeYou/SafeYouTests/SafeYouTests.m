//
//  SafeYouTests.m
//  SafeYouTests
//
//  Created by Garnik Simonyan on 8/12/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../SafeYou/Services/Localization/SYBundleLocalizationService.h"

@interface SafeYouTests : XCTestCase

@end

@implementation SafeYouTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - Map screens

// These scenes are normally reached through segues after login, so they are
// loaded directly using the identifiers Interface Builder gives to each scene.
- (UIViewController *)sceneWithIdentifier:(NSString *)identifier storyboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (void)assertMapShowsPinInScene:(UIViewController *)scene
                        selector:(SEL)selector
                       configure:(void (^)(UIViewController *scene))configure {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    XCTAssertNoThrow([scene loadViewIfNeeded]);
    UIView *mapHostView = [scene valueForKey:@"mapHostView"];
    XCTAssertEqual(mapHostView.subviews.count, 1u);
    if (configure) {
        configure(scene);
    }
    XCTAssertNoThrow([scene performSelector:selector]);
#pragma clang diagnostic pop
}

- (void)testRecordDetailsMapLoads {
    UIViewController *scene = [self sceneWithIdentifier:@"UIViewController-khR-kg-6Dv" storyboard:@"HelpTab"];
    [self assertMapShowsPinInScene:scene selector:NSSelectorFromString(@"configurePlacesOnMap") configure:nil];
}

- (void)testNGODetailsMapLoads {
    UIViewController *scene = [self sceneWithIdentifier:@"UIViewController-ri9-MC-MFd" storyboard:@"Network"];
    [self assertMapShowsPinInScene:scene selector:NSSelectorFromString(@"configurePlacesOnMap") configure:nil];
}

- (void)testNetworkListMapShowsServices {
    UIViewController *scene = [self sceneWithIdentifier:@"NetworkListViewController" storyboard:@"Network"];
    [self assertMapShowsPinInScene:scene
                          selector:NSSelectorFromString(@"configureServicePlaces")
                         configure:^(UIViewController *loadedScene) {
        id service = [[NSClassFromString(@"EmergencyServiceDataModel") alloc] init];
        [loadedScene setValue:@[service] forKey:@"dataSource"];
    }];
}

#pragma mark - Bundled localization

- (void)testSelectedLanguageIsUsedImmediately {
    SYBundleLocalizationService *service = [[SYBundleLocalizationService alloc] init];
    NSString *key = @"show_results";
    [service setLanguageCode:@"en"];
    NSString *english = [service localizedStringForKey:key];
    [service setLanguageCode:@"az"];
    XCTAssertNotEqualObjects([service localizedStringForKey:key], english);
    XCTAssertEqualObjects(service.currentLocale.localeIdentifier, @"az");
}

- (void)testMissingTranslationsFallBackToEnglishThenKey {
    SYBundleLocalizationService *service = [[SYBundleLocalizationService alloc] init];
    [service setLanguageCode:@"en"];
    NSString *english = [service localizedStringForKey:@"support_mail"];
    [service setLanguageCode:@"az"];
    XCTAssertEqualObjects([service localizedStringForKey:@"support_mail"], english);
    XCTAssertEqualObjects([service localizedStringForKey:@"no_such_key"], @"no_such_key");
}

@end
