//
//  ForumDetailsViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/16/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class SocketIOClient;

NS_ASSUME_NONNULL_BEGIN

@interface ForumDetailsViewController : SYViewController

@property (nonatomic) SocketIOClient *socketClient;
@property (nonatomic) NSString *forumItemId;

@end

NS_ASSUME_NONNULL_END
