//
//  SYMapViewProvider.m
//  SafeYou
//

#import "SYMapViewProvider.h"
#import "SYMapKitViewProvider.h"

@implementation SYMapPin

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = [title copy];
    }
    return self;
}

@end

id<SYMapViewProvider> SYDefaultMapViewProvider(void)
{
    return [[SYMapKitViewProvider alloc] init];
}
