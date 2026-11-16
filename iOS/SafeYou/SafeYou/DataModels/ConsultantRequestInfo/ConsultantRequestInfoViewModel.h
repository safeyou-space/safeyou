//
//  ConsultantRequestStatusViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/4/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class UserConsultantRequestDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ConsultantRequestInfoViewModel : BaseDataModel

+ (instancetype)statusInfoDataFromRequestData:(UserConsultantRequestDataModel *)requestData;
+ (instancetype)submissionDateDataFromRequestData:(UserConsultantRequestDataModel *)requestData;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *statusInfoText;
@property (nonatomic) NSString *iconName;
@property (nonatomic) ConsultantRequestStatus requestStatus;

@end


NS_ASSUME_NONNULL_END
