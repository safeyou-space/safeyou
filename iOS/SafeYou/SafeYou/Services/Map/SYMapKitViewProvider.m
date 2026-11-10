//
//  SYMapKitViewProvider.m
//  SafeYou
//

#import "SYMapKitViewProvider.h"
#import <MapKit/MapKit.h>

@interface SYMapKitViewProvider ()

@property (nonatomic) MKMapView *mapView;

@end

@implementation SYMapKitViewProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)attachToContainer:(UIView *)container
{
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:self.mapView];
    [NSLayoutConstraint activateConstraints:@[
        [self.mapView.topAnchor constraintEqualToAnchor:container.topAnchor],
        [self.mapView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [self.mapView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [self.mapView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
    ]];
}

- (void)showPins:(NSArray<SYMapPin *> *)pins animated:(BOOL)animated
{
    NSMutableArray<MKPointAnnotation *> *annotations = [NSMutableArray arrayWithCapacity:pins.count];
    for (SYMapPin *pin in pins) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = pin.coordinate;
        annotation.title = pin.title;
        [annotations addObject:annotation];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView showAnnotations:annotations animated:animated];
}

@end
