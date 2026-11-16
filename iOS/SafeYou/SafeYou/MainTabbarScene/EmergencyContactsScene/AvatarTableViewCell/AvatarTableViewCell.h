//
//  AvatarTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/6/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileCellInterface.h"
@class ProfileViewFieldViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface AvatarTableViewCell : UITableViewCell <MyProfileCellInterface>

- (void)configureCellWithViewModelData:(ProfileViewFieldViewModel *)avatartField;
- (void)updatePhotoWithLocalmage:(UIImage * __nullable)localImage;
- (ProfileViewFieldViewModel *)fieldData;

@end

NS_ASSUME_NONNULL_END
