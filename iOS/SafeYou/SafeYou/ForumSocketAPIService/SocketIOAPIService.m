//
//  SocketIOAPIService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/11/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SocketIOAPIService.h"

#import "Settings.h"
#import "SocketIOManager.h"
#import "RoomDataModel.h"
#import "ChatMessageDataModel.h"
#import "UserDataModel.h"
#import "SafeYou-Swift.h"

@implementation SocketIOAPIService

- (SYHTTPSessionManager *)networkManagerWithUrl:(NSString *)urlString
{
    Settings *settings = [Settings sharedInstance];
    NSString *token = settings.userAuthToken;
    NSDictionary *headerParams;
    if (token.length && [SocketIOManager sharedInstance].socketClient.status == SocketIOStatusConnected) {
        /**
         1) Authorization: 0013bbbcf2f21b30709ea4c186... # This is the oauth access_token
         2) _: ZkJbjUa6n3CgkuGXAAAB                      # This is the ID of the socket client
         3) Accept-Language: EN                          # This is the response messages language

         */
        headerParams = @{@"Authorization" : [NSString stringWithFormat:@"%@", token],
                         @"_": [SocketIOManager sharedInstance].socketClient.sid,
                         @"Accept-Language" : [Settings sharedInstance].selectedLanguageCode
        };
    }
    
    SYHTTPSessionManager *manager = [SYHTTPSessionManager sessionManagerWithBaseURL:urlString headerParams:headerParams configuration:nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    return manager;
}

- (void)joinToRoom:(NSString *)roomId success:(void(^)(RoomDataModel *response))success failure:(void(^)(NSError *error))failure
{
    //Method: GET  | Url: http://185.177.105.151:1998/api/rooms/:room_key/join
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endppoint = [NSString stringWithFormat:@"/api/rooms/%@/join", roomId];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endppoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *roomDict = responseObject[@"data"];
        RoomDataModel *roomData = [RoomDataModel modelObjectWithDictionary:roomDict];
        if (success) {
            success(roomData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)leaveRoom:(NSString *)roomId success:(void(^)(RoomDataModel *response))success failure:(void(^)(NSError *error))failure
{
    //Method: GET  | Url: http://185.177.105.151:1998/api/rooms/:room_key/leave
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endppoint = [NSString stringWithFormat:@"/api/rooms/%@/leave", roomId];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endppoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *roomDict = responseObject[@"data"];
        if (![roomDict isKindOfClass:[NSDictionary class]]) {
            if (success) {
                success(nil);
            }
        } else {
            RoomDataModel *roomData = [RoomDataModel modelObjectWithDictionary:roomDict];
            if (success) {
                success(roomData);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getRoomMessages:(NSString *)roomKey skip:(int)skip success:(void(^)(NSArray <ChatMessageDataModel *> *receivedMessages))success failure:(void(^)(NSError *error))failure
{
    /**
     Query Parameters:

     limit - No Required/Number. Used to specify the maximum number of results to be returned
     skip - No Required/Number. Gets or sets the number of search results to skip.
     Method: GET  | Url: http://185.177.105.151:1998/api/rooms/:room_key/messages/list?limit=10&skip=0

     */
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endppoint = [NSString stringWithFormat:@"/api/rooms/%@/messages/list?limit=10&skip=%d", roomKey, skip];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endppoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *receivedDataDict = responseObject[@"data"];
        NSArray *receivedMessages = [self messagesFromDict:receivedDataDict];
        if (success) {
            success(receivedMessages);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/:room_key/messages/send
 */

- (void)sendMessageToRoom:(NSString *)roomKey
          sendMessageFile:(SendMessageFileDataModel *)sendMessageFile
                  success:(void(^)(ChatMessageDataModel *messageData))success
                  failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endpoint = [NSString stringWithFormat:@"/api/rooms/%@/messages/send", roomKey];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager POST:endpoint parameters:sendMessageFile.messageParameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in sendMessageFile.messageFormDataParameters.allKeys) {
            id value = sendMessageFile.messageFormDataParameters[key];
            if([key containsString:@"message_files"]) {
                if(sendMessageFile.fileType == FileTypeImage) {
                    [formData appendPartWithFileData:value name:key fileName:@"safeYouForumImage" mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:value name:key fileName:@"safeYouForumAudio" mimeType:@"audio/mpeg"];
                }
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            ChatMessageDataModel *messageObject = [ChatMessageDataModel modelObjectWithDictionary:responseObject[@"data"]];
            success(messageObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)editMessageInRoom:(NSString *)roomKey
                messageId:(NSNumber *)messageId
          sendMessageFile:(SendMessageFileDataModel *)sendMessageFile
                  success:(void(^)(ChatMessageDataModel *messageData))success
                  failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endpoint = [NSString stringWithFormat:@"/api/rooms/%@/messages/%@/update", roomKey, messageId];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager POST:endpoint parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in sendMessageFile.messageParameters.allKeys) {
            id value = sendMessageFile.messageParameters[key];
            if([key containsString:@"message_files"]) {
                if(sendMessageFile.fileType == FileTypeImage) {
                    [formData appendPartWithFileData:value name:key fileName:@"safeYouForumImage" mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:value name:key fileName:@"safeYouForumAudio" mimeType:@"audio/mpeg"];
                }
            } else {
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data name:key];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            ChatMessageDataModel *messageObject = [ChatMessageDataModel modelObjectWithDictionary:responseObject[@"data"]];
            success(messageObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)deleteMessageInRoom:(NSString *)roomKey
                  messageId:(NSNumber *)messageId
                    success:(void(^)(BOOL success))success
                    failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endpoint = [NSString stringWithFormat:@"/api/rooms/%@/messages/%@/delete", roomKey, messageId];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager POST:endpoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)reportUser:(NSNumber *)userId
                    success:(void(^)(BOOL success))success
                    failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    // TODO - add report user endpoint
    NSString *endpoint = [NSString stringWithFormat:@"/api/rooms/%@/messages/", userId];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager POST:endpoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 Method: GET  | Url: http://185.177.105.151:1998/api/rooms/list?type=1
 
 Method: GET  | Url: http://185.177.105.151:1998/api/friends/list?joint_room_type=1&limit=10&skip=0
 */

- (void)getRoomsForType:(RoomType)roomType success:(void(^)(NSArray <RoomDataModel *> *roomsList))success failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endpoint = [NSString stringWithFormat:@"/api/rooms/list"];
//    NSString *endpoint = [NSString stringWithFormat:@"api/friends/list"];
    NSDictionary *params = @{@"type": @(roomType)};
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endpoint parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *roomsDict = responseObject[@"data"];
        NSArray *roomsList = [self roomsFromDict:roomsDict];
        
        if (success) {
            success(roomsList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/create
 Method: POST | Url: http://185.177.105.151:1998/api/rooms/:room_key/update
 */

- (void)createRoomWithUser:(ChatUserDataModel *)userData success:(void(^)(RoomDataModel *roomData))success failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endpoint = [NSString stringWithFormat:@"/api/rooms/create"];
    NSDictionary *params = @{@"room_name": @"room_name",
                             @"room_type": [NSString stringWithFormat:@"%@",@(RoomTypePrivateOnToOne)],
                             @"room_member[0]":[NSString stringWithFormat:@"%@",userData.userId],
                             @"room_image": @"image_name"};
    
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager POST:endpoint parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in params.allKeys) {
            id value = params[key];
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:key];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            RoomDataModel *roomData = [RoomDataModel modelObjectWithDictionary:responseObject[@"data"]];
            success(roomData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)joinToPrivateRoomWithUser:(ChatUserDataModel *)userData success:(void (^)(RoomDataModel *roomData))success failure:(void (^)(NSError *error))failure
{
    NSString *roomKey = [NSString stringWithFormat:@"PRIVATE_CHAT_%@_%@", [Settings sharedInstance].onlineUser.userId, userData.userId];
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endppoint = [NSString stringWithFormat:@"/api/rooms/%@/join", roomKey];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endppoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *roomDict = responseObject[@"data"];
        RoomDataModel *roomData = [RoomDataModel modelObjectWithDictionary:roomDict];
        if (success) {
            success(roomData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getUserNotificationsSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *endpoint = @"api/notifications";
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endpoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getRoomUnreadMessages:(NSString *)roomKey success:(void(^)(NSArray <NSNumber *> *unreadMessageIds))success failure:(void(^)(NSError *error))failure
{
    NSString *apiURL = [Settings sharedInstance].socketAPIURL;
    NSString *endppoint = [NSString stringWithFormat:@"/api/rooms/%@/unread/messages", roomKey];
    SYHTTPSessionManager *networkManager = [self networkManagerWithUrl:apiURL];
    [networkManager GET:endppoint parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *receivedDataDict = responseObject[@"data"];
        NSMutableArray *unreadMessages = [NSMutableArray array];
        if (receivedDataDict.count > 0) {
            NSArray *receivedMessages = [self messagesFromDict:receivedDataDict];
            for (ChatMessageDataModel *message in receivedMessages) {
                if (message.messageId) {
                    [unreadMessages addObject:message.messageId];
                }
            }
        }
        if (success) {
            success(unreadMessages);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Helper

- (NSArray <ChatMessageDataModel *>*)messagesFromDict:(NSDictionary *)messagesDict
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *messageDict in messagesDict) {
        ChatMessageDataModel *messageData = [ChatMessageDataModel modelObjectWithDictionary:messageDict];
        [tempArray addObject:messageData];
    }
    
    return [tempArray copy];
}

- (NSArray <RoomDataModel *>*)roomsFromDict:(NSDictionary *)roomsDict
{
    BOOL isUserAdult = [Helper isUserAdultWithBirthday: [Settings sharedInstance].onlineUser.birthday isRegisteration:NO];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *roomDict in roomsDict) {
        RoomDataModel *roomData = [RoomDataModel modelObjectWithDictionary:roomDict];
        if (isUserAdult) {
            [tempArray addObject:roomData];
        } else {
            if ([[Settings sharedInstance].selectedCountryCode isEqualToString:@"arm"]) {
                NSArray *keyParts = [roomData.roomKey componentsSeparatedByString:@"_"];
                if (keyParts[3] != NULL && [NGO_IDS_TO_SHOW_CHAT_FOR_MINOR_USERS containsObject:keyParts[3]]) {
                    [tempArray addObject:roomData];
                }
            } else {
                [tempArray addObject:roomData];
            }
        }
    }
    
    return [tempArray copy];
}

@end
