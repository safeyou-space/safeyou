//
//  ConsultantNewRequestDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/28/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class ConsultantExpertiseFieldDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ConsultantNewRequestDataModel : BaseDataModel

@property (nonatomic) ConsultantExpertiseFieldDataModel *expertiseFieldDataModel;
@property (nonatomic) NSString *promotionalText;
@property (nonatomic) NSString *emailAddress;
@property (nonatomic) BOOL isNewExpertiseFieldSuggested;
@property (nonatomic) NSString *suggestedExpertiseField;
@property (nonatomic) ConsultantRequestStatus requestStatus;

//ViewModel
@property (nonatomic) NSString *requestStatusText;

@end

NS_ASSUME_NONNULL_END
