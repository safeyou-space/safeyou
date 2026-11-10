//
//  SYMapViewProvider.h
//  SafeYou
//
//  Lets screens show pins without depending on a map framework. To use another
//  map, such as MapLibre, implement SYMapViewProvider and return it from
//  SYDefaultMapViewProvider().
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMapPin : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, nullable, copy) NSString *title;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(nullable NSString *)title;

@end

@protocol SYMapViewProvider <NSObject>

/// Adds the map to the container, filling its bounds.
- (void)attachToContainer:(UIView *)container;
/// Replaces any pins on the map and zooms to fit the new ones.
- (void)showPins:(NSArray<SYMapPin *> *)pins animated:(BOOL)animated;

@end

id<SYMapViewProvider> SYDefaultMapViewProvider(void);

NS_ASSUME_NONNULL_END
