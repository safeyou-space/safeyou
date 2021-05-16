//
//  HelpService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "HelpService.h"
#import <CoreLocation/CoreLocation.h>

@implementation HelpService

//sent/help_sms

- (void)sendEmergencyMessgaeComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSString *latitude = [NSString stringWithFormat:@"%@",@([Settings sharedInstance].userLocation.coordinate.latitude)];
    NSString *longitude = [NSString stringWithFormat:@"%@",@([Settings sharedInstance].userLocation.coordinate.longitude)];
    NSString *userlocation = [Settings sharedInstance].userLocationName;
    
    NSDictionary *params = @{@"latitude":latitude,
                             @"longitude": longitude,
                             @"location": userlocation
    };
        
    [self.networkManager POST:@"sent/help_sms" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
