//
//  Constants.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/27/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#ifndef Constants_h

#define Constants_h

#import "Utilities.h"

#define LOC(x) [Utilities fetchTranslationForKey:x]


#define weakify(var) __weak typeof(var) AHKWeak_##var = var;

#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")


#define nilOrJSONObjectForKey(JSON, KEY) [[JSON objectForKey:KEY] isKindOfClass:[NSNull class]] ? nil : [JSON objectForKey:KEY]

#define objectOrNilForKey(MODEL_PROPERTY, DICT, KEY)\
{id jsonObj = [DICT objectForKey:KEY];\
if(jsonObj) {\
MODEL_PROPERTY = ([jsonObj isKindOfClass:[NSNull class]] ? nil : jsonObj);\
}}

#define boolObjectOrNilForKey(MODEL_PROPERTY, DICT, KEY)\
{id jsonObj = [DICT objectForKey:KEY];\
if(jsonObj) {\
MODEL_PROPERTY = [([jsonObj isKindOfClass:[NSNull class]] ? nil : jsonObj) boolValue];\
}}

#define doubleObjectOrNilForKey(MODEL_PROPERTY, DICT, KEY)\
{id jsonObj = [DICT objectForKey:KEY];\
if(jsonObj) {\
MODEL_PROPERTY = [nilOrJSONObjectForKey(DICT, KEY) doubleValue];\
}}

#define integerObjectOrNilForKey(MODEL_PROPERTY, DICT, KEY)\
{id jsonObj = [DICT objectForKey:KEY];\
if(jsonObj) {\
MODEL_PROPERTY = [nilOrJSONObjectForKey(DICT, KEY) integerValue];\
}}

//#define BASE_API_URL @"http://fambox.tv:15080/api/%@/%@/"
//#define BASE_RESOURCE_URL @"http://fambox.tv:15080"

// dev

#if DEBUG

#define BASE_API_URL @"http://localhost:8080/api/%@/%@/"
#define BASE_RESOURCE_URL @"http://localhost:8080"

#else
// prod

#define BASE_API_URL @"http://localhost:8080/api/%@/%@/"
#define BASE_RESOURCE_URL @"http://localhost:8080"

//#define BASE_API_URL @"https://localhost/api/%@/%@/"
//#define BASE_RESOURCE_URL @"https://localhost"

#endif

//#define SOCKET_IO_BASE_URL @"/" //not used values are set in Settings.m
//#define SOCKET_IO_BASE_URL @" " // not used

#define SOCKET_COMMAND_GET_PROFILE  @"SafeYOU_V4##PROFILE_INFO#RESULT"
#define SOCKET_COMMAND_REQUEST_FORUMS @"SafeYOU_V4##GET_ALL_FORUMS"
#define SOCKET_COMMAND_GET_FORUMS_RESULT @"SafeYOU_V4##GET_ALL_FORUMS#RESULT"
#define SOCKET_COMMAND_REQUEST_FORUM_DETAILS @"SafeYOU_V4##FORUM_MORE_INFO"
#define SOCKET_COMMAND_GET_FORUM_DETAILS @"SafeYOU_V4##FORUM_MORE_INFO#RESULT"
#define SOCKET_COMMAND_ADD_NEW_COMMENT @"SafeYOU_V4##ADD_NEW_COMMENT"
#define SOCKET_COMMAND_GET_NEW_COMMENT @"SafeYOU_V4##ADD_NEW_COMMENT#RESULT"

#define SOCKET_COMMAND_GET_NEW_COMMENTS_COUNT @"SafeYOU_V4##GET_NEW_COMMENTS_COUNT"
#define SOCKET_COMMAND_GET_NEW_COMMENTS_COUNT_RESULT @"SafeYOU_V4##GET_NEW_COMMENTS_COUNT#RESULT"

#define SOCKET_COMMAND_GET_NOTIFICATION @"SafeYOU_V4##NOTIFICATION"
#define SOCKET_COMMAND_GET_NOTIFICATION_RESULT @"SafeYOU_V4##NOTIFICATION#RESULT"

#define SOCKET_COMMAND_GET_NOTIFICATIONS_COUNT @"SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT"
#define SOCKET_COMMAND_GET_NOTIFICATIONS_COUNT_RESULT @"SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT#RESULT"
#define SOCKET_COMMAND_READ_NOTIFICATION @"SafeYOU_V4##READ_NOTIFICATION"


#define SOCKET_IO_DID_CONNECT_NOTIFICATION_NAME @"com.SafeYOU.socketIODidConnectNotification"

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

#define UserPinChangedNotificationName @"com.SafeYou.userPinHasChangedNotificationName"
#define UserDataDidUpdateNotificationName @"com.SafeYou.userDataDidUpdateNotificationName"
#define NoInternetConnectionNotificationName @"com.SafeYou.noInternetConnectionNotificationName"
#define CommonNetworkErrorNotificationName @"com.SafeYou.commonNetworkErrorNotificationName"
#define ApplicationLanguageDidChangeNotificationName @"com.SafeYou.applicationLanguageDidChange"
#define InAppNotificationsCountDidChangeNotificationName @"com.SafeYou.inAppNotificationsCountDidChange"

#define APPLICATION_URL_DEFAULT_SETTINGS @{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)}

typedef NS_ENUM(NSUInteger, SYRemotContentType) {
    SYRemotContentTypeUnknown,
    SYRemotContentTypeAboutUs,
    SYRemotContentTypeTermsAndConditions,
    SYRemotContentTypeConsultantTermsAndConditions,
    SYRemotContentTypePrivacyPolicy,
    
};

typedef NS_ENUM(NSUInteger, FieldAccessoryType) {
    FieldAccessoryTypeUnknown,
    FieldAccessoryTypeEdit,
    FieldAccessoryTypeArrow,
    FieldAccessoryTypeSwitch,
    FieldAccessoryTypeAvatar,
    FieldAccessoryTypeLastUnknown,
};

typedef NS_ENUM(NSUInteger, SYChooseOptionType) {
    SYChooseOptionTypeCheck,
    SYChooseOptionTypeRadio
};

typedef NS_ENUM(NSUInteger, ConsultantRequestStatus) {
    ConsultantRequestStatusPending,
    ConsultantRequestStatusConfirmed,
    ConsultantRequestStatusDeclined
};


#endif /* Constants_h */
