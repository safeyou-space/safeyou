//
//  ConsultantRequestStatusViewModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/4/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ConsultantRequestInfoViewModel.h"
#import "UserConsultantRequestDataModel.h"
#import <Lokalise/Lokalise.h>

@implementation ConsultantRequestInfoViewModel

+ (instancetype)statusInfoDataFromRequestData:(UserConsultantRequestDataModel *)requestData
{
    ConsultantRequestInfoViewModel *statusInfoData = [[ConsultantRequestInfoViewModel alloc] init];
    
    statusInfoData.title = LOC(@"request_status");
    statusInfoData.statusInfoText = [statusInfoData statusDateTextFromRequestData:requestData];
    statusInfoData.iconName = [statusInfoData iconNameForStatus:requestData.requestStatus];
    statusInfoData.requestStatus = requestData.requestStatus;    
    
    return statusInfoData;
}

+ (instancetype)submissionDateDataFromRequestData:(UserConsultantRequestDataModel *)requestData
{
    ConsultantRequestInfoViewModel *dateInfoData = [[ConsultantRequestInfoViewModel alloc] init];
    dateInfoData.title = LOC(@"submission_date");
    dateInfoData.statusInfoText = [dateInfoData formattedDateStringFromRequestCreateDate:requestData.createdDateString];
    dateInfoData.requestStatus = requestData.requestStatus;
    
    return dateInfoData;
}

#pragma mark - Helpers

- (NSString *)formattedDateStringFromRequestUpdatedDate:(NSString *)dateString
{
    //03/28/2021
    NSDateFormatter *oldDateFormatter = [[NSDateFormatter alloc] init];
    oldDateFormatter.locale = [[Lokalise sharedObject] localizationLocale];
    oldDateFormatter.dateFormat = @"MM/dd/yyyy";
    NSDate *date = [oldDateFormatter dateFromString:dateString];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    newDateFormatter.locale = [[Lokalise sharedObject] localizationLocale];
    newDateFormatter.dateFormat = @"dd MMMM, yyyy";
    
    NSString *convertedDateString = [newDateFormatter stringFromDate:date];
    
    return convertedDateString;
    
}

- (NSString *)formattedDateStringFromRequestCreateDate:(NSString *)dateString
{
    //03/28/2021
    NSDateFormatter *oldDateFormatter = [[NSDateFormatter alloc] init];
    oldDateFormatter.locale = [[Lokalise sharedObject] localizationLocale];
    oldDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.ssssZ";
    NSDate *date = [oldDateFormatter dateFromString:dateString];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    newDateFormatter.locale = [[Lokalise sharedObject] localizationLocale];
    newDateFormatter.dateFormat = @"dd MMMM, YYYY";
    
    NSString *convertedDateString = [newDateFormatter stringFromDate:date];
    
    return convertedDateString;
}

- (NSString *)iconNameForStatus:(ConsultantRequestStatus)status {
    
    NSString *iconName = @"";
    switch (status) {
        case ConsultantRequestStatusPending:
            iconName = @"icon_pending";
            break;
            
        case ConsultantRequestStatusConfirmed:
            iconName = @"icon_approved";
            break;
            
        case ConsultantRequestStatusDeclined:
            iconName = @"icon_declined";
            break;
            
        default:
            break;
    }
    
    return iconName;
}

- (NSString *)statusDateTextFromRequestData:(UserConsultantRequestDataModel *)requestData
{
    NSString *statusDateString = @"";
    switch (requestData.requestStatus) {
        case ConsultantRequestStatusPending: {
            statusDateString = LOC(@"pending_approval");
        }
            break;
            
        case ConsultantRequestStatusConfirmed: {
            NSString *dateString = [self formattedDateStringFromRequestUpdatedDate:requestData.updatedDateString];
            statusDateString = [NSString stringWithFormat:LOC(@"approved_on_date"), dateString];
        }
            break;
            
        case ConsultantRequestStatusDeclined: {
            NSString *dateString = [self formattedDateStringFromRequestUpdatedDate:requestData.updatedDateString];
            statusDateString = [NSString stringWithFormat:LOC(@"declined_on_date"), dateString];
        }
            
            break;
            
        default:
            statusDateString = LOC(@"pending_request");
            break;
    }
    return statusDateString;
}


@end
