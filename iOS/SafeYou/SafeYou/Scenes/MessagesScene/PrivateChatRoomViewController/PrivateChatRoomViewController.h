//
//  PrivateChatRoomViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/23/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//


#import "SYViewController.h"

@class SocketIOClient, RoomDataModel, ChatMessageDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface PrivateChatRoomViewController : SYViewController

@property (nonatomic) RoomDataModel *roomData;

@property (nonatomic) BOOL isForComposing;


@end

NS_ASSUME_NONNULL_END
