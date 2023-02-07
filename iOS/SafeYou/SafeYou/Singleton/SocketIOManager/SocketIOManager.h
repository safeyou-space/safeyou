//
//  SocketIOManager.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/27/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SocketIOSignal) {
    SocketIOSignalPROFILE = 0,
    SocketIOSignalCONNECTED = 1,
    SocketIOSignalDISCONNECTED = 2,
    SocketIOSignalRoomJOINED = 3,
    SocketIOSignalRoomLEAVED = 4,
    SocketIOSignalRoomINSERT = 5,
    SocketIOSignalRoomUPDATE = 6,
    SocketIOSignalRoomDELETE = 7,
    SocketIOSignalMessageINSERT = 8,
    SocketIOSignalMessageUPDATE = 9,
    SocketIOSignalMessageDELETE = 10,
    SocketIOSignalMessageTYPING = 11,
    SocketIOSignalMessageRECEIVED = 12,
    SocketIOSignalNotificationReceived = 13,
    SocketIOSignalRoomUpdateMembers = 14,
    SocketIOSignalSOS = 15,
    SocketIOSignalMessageLIKED = 16,
    SocketIOSignalCommentCount = 17
};

NS_ASSUME_NONNULL_BEGIN

@class ChatUserDataModel, SocketIOManager;

@protocol SocketIOManagerDelegate <NSObject>

@optional

- (void)socketIOManager:(SocketIOManager *)manager didReceiveProfileData:(id)profileData;

- (void)socketIOManager:(SocketIOManager *)manager didInsertMessage:(id)messageData;
- (void)socketIOManager:(SocketIOManager *)manager didUpdateMessage:(id)messageData;
- (void)socketIOManager:(SocketIOManager *)manager didDeleteMessage:(id)messageData;

- (void)socketIOManager:(SocketIOManager *)manager didInsertNewRoom:(id)roomData;
- (void)socketIOManager:(SocketIOManager *)manager didUpdateRoom:(id)roomData;
- (void)socketIOManager:(SocketIOManager *)manager didDeleteRoom:(id)roomData;


@end

@import SocketIO;

typedef void(^NotificationDidReceiveBlock)(id notificationData);
typedef void(^NotificationCountUpdateBlock)(NSNumber *notificationsCount);
typedef void(^DidReceiveUpdateBlock)(id updateData);

@interface SocketIOManager : NSObject

+ (instancetype)sharedInstance;

- (void)connect;

@property (nonatomic, readonly) SocketIOClient *socketClient;
@property (nonatomic, readonly) ChatUserDataModel *chatOnlineUser;
@property (nonatomic, weak) id <SocketIOManagerDelegate> delegate;

@property (nonatomic) NotificationDidReceiveBlock receiveNewNotificationBlock;
@property (nonatomic) NotificationCountUpdateBlock notificationsCountUpdateBlock;
@property (nonatomic) DidReceiveUpdateBlock didReceiveUpdateBlock;

@end

NS_ASSUME_NONNULL_END
