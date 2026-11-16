//
//  MaritalStatusDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

typedef NS_ENUM(NSInteger, MaritalSatatusType) {
    MaritalSatatusTypeUnknown = -1,
    MaritalSatatusTypeMarried = 0,
    MaritalSatatusTypeUnMarried = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface MaritalStatusDataModel : BaseDataModel

@property (nonatomic) NSNumber *maritalStatusType;
@property (nonatomic) NSString *localizedName;




@end

NS_ASSUME_NONNULL_END
