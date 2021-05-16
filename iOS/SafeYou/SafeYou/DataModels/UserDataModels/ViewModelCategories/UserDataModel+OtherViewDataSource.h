//
//  UserDataModel+OtherViewDataSource.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UserDataModel.h"

@class ProfileViewFieldViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UserDataModel (OtherViewDataSource)

- (NSArray <ProfileViewFieldViewModel *>*)othersViewDataSource;

@end

NS_ASSUME_NONNULL_END
