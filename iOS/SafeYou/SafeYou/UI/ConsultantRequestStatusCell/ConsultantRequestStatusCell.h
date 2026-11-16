//
//  ConsultantRequestStatusCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/29/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConsultantRequestInfoViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ConsultantRequestStatusCell : UITableViewCell

- (void)configureWithRequestInfoData:(ConsultantRequestInfoViewModel *)infoData;

@end

NS_ASSUME_NONNULL_END
