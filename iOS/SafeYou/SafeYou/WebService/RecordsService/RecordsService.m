//
//  RecordsService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordsService.h"
#import "RecordsListDataModel.h"
#import "RecordSearchResult.h"
#import "RecordListItemDataModel.h"

@implementation RecordsService

/*
 //POST Add Record
 @param record file path
 */

- (NSString *)endpoint
{
    return @"record";
}

- (NSString *)endpointRecords
{
    return @"records";
}

- (NSString *)endpointForRecordId:(NSString *)recordId
{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", [self endpoint], recordId];
    return endpoint;
}

- (NSString *)endpointForSendRecord:(NSString *)recordId
{
    NSString *endpoint = [NSString stringWithFormat:@"record/sent/%@", recordId];
    return endpoint;
}



//GET Get Records

- (void)getAllRecordsWithComplition:(void(^)(RecordsListDataModel *records))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:[self endpointRecords] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RecordsListDataModel *recordsData = [RecordsListDataModel modelObjectWithDictionary:responseObject];
        if (complition) {
            complition(recordsData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//GET Get Records with search
- (void)getAllRecordsWithSearch:(NSString *)searchText complition:(void(^)(NSArray <RecordSearchResult *> *searchResults))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"search_string":searchText};
    [self.networkManager GET:[self endpointRecords] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *responseArray = [[NSMutableArray alloc] init];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                RecordSearchResult *searchResult = [RecordSearchResult modelObjectWithDictionary:dict];
                [responseArray addObject:searchResult];
            }
        }
        if (complition) {
            complition(responseArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



//GET Get Record By Record ID

- (void)getRecord:(NSString *)recordId complition:(void(^)(id record))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:[self endpointForRecordId:recordId] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RecordListItemDataModel *recordData = [RecordListItemDataModel modelObjectWithDictionary:responseObject];
        if (complition) {
            complition(recordData);
        }
        NSLog(@"Response %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
        if (failure) {
            failure(error);
        }
    }];
}


//DELETE Delete Record By Record ID
- (void)deleteRecord:(NSString *)recordId complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager DELETE:[self endpointForRecordId:recordId] parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


//POST Send Mail Record By Record ID

- (void)sendEmergencyRecord:(NSString *)recordId params:(NSDictionary *)params complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager POST:[self endpointForSendRecord:recordId] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)addRecord:(NSString *)recordFilePath params:(NSDictionary *)recordParams complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSData *fileData;
    if (recordFilePath) {
        fileData = [NSData dataWithContentsOfFile:recordFilePath];
    } else {
        return;
    }

    [self.networkManager POST:@"record" parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (NSString *key in recordParams.allKeys) {
            NSData* data = [recordParams[key] dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:key];
        }
        
        [formData appendPartWithFileData:fileData name:@"audio" fileName:@"record.mp3" mimeType:@"audio"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        if (failure) {
            failure(error);
        }
    }];    
}

@end
