//
//  NGODetailsViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class EmergencyServiceDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface NGODetailsViewController : SYViewController

@property (nonatomic) EmergencyServiceDataModel *serviceData;
@property (nonatomic) BOOL isFromMyProfil;
@property (nonatomic) NSString *updatedingServiceId;
@property (nonatomic) BOOL hideChatButton;

@end

NS_ASSUME_NONNULL_END
