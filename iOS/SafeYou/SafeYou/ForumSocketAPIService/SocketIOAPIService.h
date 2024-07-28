//
//  SocketIOAPIService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/11/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
#import "SendMessageFileDataModel.h"

@class RoomDataModel, ChatMessageDataModel, ChatUserDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface SocketIOAPIService : SYServiceAPI

- (void)joinToRoom:(NSString *)roomId success:(void(^)(RoomDataModel *response))success failure:(void(^)(NSError *error))failure;

- (void)leaveRoom:(NSString *)roomId success:(void(^)(RoomDataModel *response))success failure:(void(^)(NSError *error))failure;

- (void)getRoomMessages:(NSString *)roomKey skip:(int)skip success:(void(^)(NSArray <ChatMessageDataModel *> *receivedMessages))success failure:(void(^)(NSError *error))failure;

/**
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/:room_key/messages/send
 Exmple Body:
     message_content:Hello Chat!
     message_type:1
     message_mention_options:[{"test": "text"}]
     message_replies[0]:431
     message_replies[1]:432
     message_files[0]:<binary_file>
     message_files[1]:<binary_file>
     message_deleted_files[0]:1
     message_deleted_files[1]:2
 */

- (void)sendMessageToRoom:(NSString *)roomKey
          sendMessageFile:(SendMessageFileDataModel *)sendMessageFile
                  success:(void(^)(ChatMessageDataModel *messageData))success
                  failure:(void(^)(NSError *error))failure;

- (void)editMessageInRoom:(NSString *)roomKey
                messageId:(NSNumber *)messageId
          sendMessageFile:(SendMessageFileDataModel *)sendMessageFile
                  success:(void(^)(ChatMessageDataModel *messageData))success
                  failure:(void(^)(NSError *error))failure;

- (void)deleteMessageInRoom:(NSString *)roomKey
                  messageId:(NSNumber *)messageId
                    success:(void(^)(BOOL success))success
                    failure:(void(^)(NSError *error))failure;

/**
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/:room_key/messages/:message_id/update
 Exmple Body:
     message_content:Hello Chat!
     message_type:1
     message_mention_options:[{"test": "text"}]
     message_replies[0]:431
     message_replies[1]:432
     message_files[0]:<binary_file>
     message_files[1]:<binary_file>
     message_deleted_files[0]:1
     message_deleted_files[1]:2
 */



/**
 Method: GET  | Url: http://185.177.105.151:1998/api/rooms/list?type=1
 */

- (void)getRoomsForType:(RoomType)roomType success:(void(^)(NSArray <RoomDataModel *> *roomsList))success failure:(void(^)(NSError *error))failure;


/**
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/create
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/:room_key/update
 Exmple Body:
     room_name:MyRoom
     room_type:1
     
     room_owner[0]:4532
     
     room_member[0]:75137
     room_member[1]:25433

     room_image:<binary_file>
     or
     room_image:http://136.244.117.119:88/upload/images/users/profiles/admins/mark46.png
 */

- (void)createRoomWithUser:(ChatUserDataModel *)userData success:(void(^)(RoomDataModel *roomData))success failure:(void(^)(NSError *error))failure;


- (void)joinToPrivateRoomWithUser:(ChatUserDataModel *)userData success:(void (^)(RoomDataModel *roomData))success failure:(void (^)(NSError *error))failure;

- (void)getUserNotificationsSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

- (void)getRoomUnreadMessages:(NSString *)roomKey success:(void(^)(NSArray <NSNumber *> *unreadMessageIds))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
