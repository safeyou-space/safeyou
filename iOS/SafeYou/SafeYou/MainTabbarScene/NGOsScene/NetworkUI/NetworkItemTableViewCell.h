//
//  NetworkItemTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkItemTableViewCell, EmergencyServiceDataModel;

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkItemTableViewCellDelegae <NSObject>

- (void)networkItemCellDidPressPhoneButton:(NetworkItemTableViewCell *)cell;
- (void)networkItemCellDidPressMailButton:(NetworkItemTableViewCell *)cell;
- (void)networkItemCellDidPressPrivateChat:(NetworkItemTableViewCell *)cell;

@end

@interface NetworkItemTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NetworkItemTableViewCellDelegae> delegate;
@property (nonatomic) BOOL hideChatButton;

- (void)configureWithEmergencyServiceData:(EmergencyServiceDataModel *)serviceData;
- (void)configureWithSearchSuggestion:(NSString *)suggestion;

@end

NS_ASSUME_NONNULL_END
