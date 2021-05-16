//
//  ConsultantExpertiseFieldDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConsultantExpertiseFieldDataModel : BaseDataModel

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *categoryName;

- (instancetype)initWithId:(NSString *)categoryId name:(NSString *)categoryName;

@end

NS_ASSUME_NONNULL_END
