//
//  NetworkListViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class EmergencyServiceDataModel, NetworkListViewController;

@protocol NetworkListViewDelegate <NSObject>

@optional

- (void)networkList:(NetworkListViewController *_Nonnull)networkPicker didSelectService:(EmergencyServiceDataModel *_Nonnull)emergencyService;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NetworkListViewController : SYViewController

@property (nonatomic, weak) id <NetworkListViewDelegate> delegate;
@property (nonatomic) BOOL isFromMyProfil;
@property (nonatomic) NSString *updatedingServiceId;

@end

NS_ASSUME_NONNULL_END
