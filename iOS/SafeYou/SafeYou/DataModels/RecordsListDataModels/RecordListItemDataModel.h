//
//  RecordListItemDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@class RecordListItemDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecordListItemDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *recordId;
@property (nonatomic, assign) BOOL isSent;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, assign) NSNumber *userId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) double duration;
@property (nonatomic, strong) NSString *name;



@end

NS_ASSUME_NONNULL_END
