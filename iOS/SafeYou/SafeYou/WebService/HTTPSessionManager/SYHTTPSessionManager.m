//
//  SYHTTPSessionManager.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//


#import "SYHTTPSessionManager.h"
#import "CustomJSONResponseSerializer.h"

#define BASE_URL_KEY @"base_url"
#define IS_JSON_RESPONSE_KEY @"is_json_response"
#define IS_JSON_REQUEST_KEY @"is_json_request"
#define IS_PLAIN_TEXT_KEY @"is_plain_text"
#define IS_HTTP_RESPONSE_KEY @"is_http_response"
#define IS_TEXT_HTML_KEY @"is_text_html"
#define HEADER_PARAMS_KEY @"header_params"


@implementation SYHTTPSessionManager

+ (instancetype)sessionManagerWithUrlURL:(NSString*)baseURL
                            headerParams:(NSDictionary *)headerParams
                         withRequestJson:(BOOL)isJSONRequest
                        withResponseJson:(BOOL)isJSONResponse
                        withHTTPResponse:(BOOL)isHTTPResponse
                             isTextPlain:(BOOL)isTextPlain
                              isTextHtml:(BOOL)isTextHtml
                       getResponseHeader:(BOOL)mustReturnResponseHeader
                            disableCache:(BOOL)disableCache
{
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    SYHTTPSessionManager *manager = [[super alloc] initWithBaseURL:url];
    
    if(disableCache) {
        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    }
    
    
    if(isJSONRequest) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    if(isJSONResponse) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    } else if(isHTTPResponse) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        
    }
    
    if(!isTextPlain && !isTextHtml) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    } else {
        if(isTextPlain) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        }
        if(isTextHtml) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/x-mpegurl", nil];
        }
    }
    
    NSArray *headerKeysArray = [headerParams allKeys];
    for (NSString *headerKey in headerKeysArray) {
        id headerValue = [headerParams objectForKey:headerKey];
        [manager.requestSerializer setValue:headerValue forHTTPHeaderField:headerKey];
    }
    
    return manager;
}


+ (instancetype)sessionManagerWithBaseURL:(NSString *)baseURL
                             headerParams:(NSDictionary *)headerParams
                            configuration:(NSDictionary *)configuration
{
    NSURL *url= [NSURL URLWithString:baseURL];
    SYHTTPSessionManager *manager = [[SYHTTPSessionManager alloc] initWithBaseURL:url];
    
    if (configuration) {
        BOOL isJSONRequest = [nilOrJSONObjectForKey(configuration, IS_JSON_REQUEST_KEY) boolValue];
        if(isJSONRequest) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
        
        BOOL isJSONResponse = [nilOrJSONObjectForKey(configuration, IS_JSON_RESPONSE_KEY) boolValue];
        if(isJSONResponse) {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
        
        BOOL isHTTPResponse = [nilOrJSONObjectForKey(configuration, IS_HTTP_RESPONSE_KEY) boolValue];
        if(isHTTPResponse) {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        
        BOOL isTextPlain = [nilOrJSONObjectForKey(configuration, IS_PLAIN_TEXT_KEY) boolValue];
        BOOL isTextHtml = [nilOrJSONObjectForKey(configuration, IS_TEXT_HTML_KEY) boolValue];
        if(!isTextPlain && !isTextHtml) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        } else {
            if(isTextPlain) {
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            }
            if(isTextHtml) {
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/x-mpegurl", nil];
            }
        }
    } else {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        
        
        [acceptableContentTypes addObject:@"application/json"];

        manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    
    NSArray *headerKeysArray = [headerParams allKeys];
    for (NSString *headerKey in headerKeysArray) {
        id headerValue = [headerParams objectForKey:headerKey];
        [manager.requestSerializer setValue:headerValue forHTTPHeaderField:headerKey];
    }
    
    return manager;
}

#pragma mark - Override requests


#pragma mark - Override

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   if (responseObject) {
                                       NSInteger statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
                                       error = [[NSError alloc] initWithDomain:error.domain code:statusCode userInfo:responseObject];
                                       if (statusCode != 401 && statusCode != 400 && statusCode != 422) {
                                           id errorMessage = responseObject[@"message"];
                                           if (errorMessage && ((NSString *)errorMessage).length > 0) {
                                               if (!responseObject[@"errors"] && [errorMessage isKindOfClass:[NSString class]]) {
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:CommonNetworkErrorNotificationName object:errorMessage];
                                               }
                                           }
                                       }
                                   }
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}


@end
