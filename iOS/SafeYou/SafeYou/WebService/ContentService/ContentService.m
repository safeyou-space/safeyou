//
//  ContentService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ContentService.h"

@implementation ContentService

- (NSString *)endpoint
{
    return @"content";
}

- (NSString *)endpointForContentType:(SYRemotContentType)contentType
{
    switch (contentType) {
        case SYRemotContentTypeAboutUs:
            return [NSString stringWithFormat:@"%@/%@", [self endpoint],@"about_us"];
            break;
        case SYRemotContentTypeTermsAndConditionsForAdults:
            return [NSString stringWithFormat:@"%@/%@", [self endpoint],@"terms_conditions"];
            break;
        case SYRemotContentTypeTermsAndConditionsForMinors:
            return [NSString stringWithFormat:@"%@/%@", [self endpoint],@"terms_conditions-18"];
            break;
        case SYRemotContentTypeConsultantTermsAndConditions:
            return [NSString stringWithFormat:@"%@/%@", [self endpoint],@"terms_conditions_consultant"];
            break;
        case SYRemotContentTypePrivacyPolicyForAdults:
            return [NSString stringWithFormat:@"%@/%@", [self endpoint],@"privacy_policy"];
            break;
        case SYRemotContentTypePrivacyPolicyForMinors:
            return [NSString stringWithFormat:@"%@/%@", [self endpoint],@"privacy_policy-18"];
            break;
        default:
            return [self endpoint];
            break;
    }
}



- (void)getContent:(SYRemotContentType)contentType complition:(void(^)(NSString *htmlContent))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:[self endpointForContentType:contentType] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Content received");
        NSString *htmlContent = responseObject[@"content"];
        if (complition) {
            complition(htmlContent);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Content Fail");
        if (failure) {
            failure(error);
        }
    }];
}


@end
