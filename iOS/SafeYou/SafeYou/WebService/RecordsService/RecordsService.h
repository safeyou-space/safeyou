//
//  RecordsService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
@class RecordsListDataModel, RecordListItemDataModel, RecordSearchResult;

NS_ASSUME_NONNULL_BEGIN

@interface RecordsService : SYServiceAPI

//POST Add Record

- (void)addRecord:(NSString *)recordFilePath params:(NSDictionary *)recordParams complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

//GET Get Records

- (void)getAllRecordsWithComplition:(void(^)(RecordsListDataModel *records))complition failure:(void(^)(NSError *error))failure;

//GET Get Records with search
- (void)getAllRecordsWithSearch:(NSString *)searchText complition:(void(^)(NSArray <RecordSearchResult *> *searchResults))complition failure:(void(^)(NSError *error))failure;


//GET Get Record By Record ID

- (void)getRecord:(NSString *)recordId complition:(void(^)(id record))complition failure:(void(^)(NSError *error))failure;


//DELETE Delete Record By Record ID

- (void)deleteRecord:(NSString *)recordId complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;


//POST Send Mail Record By Record ID

- (void)sendEmergencyRecord:(NSString *)recordId params:(NSDictionary *)params complition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;



@end

NS_ASSUME_NONNULL_END
