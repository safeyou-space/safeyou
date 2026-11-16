//
//  ChatRoomTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomTableViewCell : UITableViewCell

- (void)configureWithData:(RoomDataModel *)roomData;

@end

NS_ASSUME_NONNULL_END
