//
//  SYHTTPSessionManager.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//


#import <AFNetworking/AFNetworking.h>

@interface SYHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sessionManagerWithUrlURL:(NSString*)baseURL
                            headerParams:(NSDictionary *)headerParams
                         withRequestJson:(BOOL)isJSONRequest
                        withResponseJson:(BOOL)isJSONResponse
                        withHTTPResponse:(BOOL)isHTTPResponse
                             isTextPlain:(BOOL)isTextPlain
                              isTextHtml:(BOOL)isTextHtml
                       getResponseHeader:(BOOL)mustReturnResponseHeader
                            disableCache:(BOOL)disableCache;

+ (instancetype)sessionManagerWithBaseURL:(NSString *)baseURL
                             headerParams:(NSDictionary *)headerParams
                            configuration:(NSDictionary *)configuration;

@end
