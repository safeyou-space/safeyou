//
//  UserDataFieldCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileCellInterface.h"

@class ProfileViewFieldViewModel;

@class UserDataFieldCell;

NS_ASSUME_NONNULL_BEGIN

@interface UserDataFieldCell : UITableViewCell <MyProfileCellInterface>

- (ProfileViewFieldViewModel *)fieldData;

@end

NS_ASSUME_NONNULL_END
