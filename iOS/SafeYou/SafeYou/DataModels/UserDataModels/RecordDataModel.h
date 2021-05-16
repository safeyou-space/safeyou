//
//  RecordDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@interface RecordDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *recordId;
@property (nonatomic, assign) BOOL isSent;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *name;


@end
