//
//  ServiceSearchResult.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceSearchResult : BaseDataModel

/**
 {
     id = 8;
     name = "MARK Varazdat last name";
     type = ngo;
 }
 */

@property (nonatomic) NSString *serviceId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *serviceType;

@end

NS_ASSUME_NONNULL_END
