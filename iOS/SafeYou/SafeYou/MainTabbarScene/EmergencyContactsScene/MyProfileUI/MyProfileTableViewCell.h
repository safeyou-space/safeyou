//
//  MyProfileTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYUIKit.h"
#import "MyProfileCellInterface.h"

@class MyProfileTableViewCell;

@protocol MyProfileCellDelegate <NSObject>

- (void)cellDidSelectClearButton:(MyProfileTableViewCell *_Nonnull)profileCell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileTableViewCell : UITableViewCell <MyProfileCellInterface>

@property (nonatomic, weak) IBOutlet SYLabelRegular *myProfileTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet SYRegularButtonButton *clearButton;

@end

NS_ASSUME_NONNULL_END
