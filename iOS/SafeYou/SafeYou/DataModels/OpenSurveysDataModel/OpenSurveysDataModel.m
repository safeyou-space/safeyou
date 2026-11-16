//
//  OpenSurveysDataModel.m
//  SafeYou
//
//  Created by armen sahakian on 23.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "OpenSurveysDataModel.h"

NSString *const kCurrentPage = @"current_page";
NSString *const kTotal = @"total";
NSString *const kData = @"data";

@implementation OpenSurveysDataModel

- (instancetype)initWithId:(NSNumber *)currentPage {
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (OpenSurveysDataModel *)createWithData:(NSDictionary *)data {
    OpenSurveysDataModel *rootObject = [[OpenSurveysDataModel alloc] init];
    
    rootObject.currentPage = data[kCurrentPage];
    rootObject.total = data[kTotal];
    
    NSArray *dataArray = data[kData];
    NSMutableArray<OpenSurveyItemDataModel *> *dataObjects = [NSMutableArray array];
    
    for (NSDictionary *dataDict in dataArray) {
        OpenSurveyItemDataModel *dataObject = [[OpenSurveyItemDataModel alloc] createWithData:dataDict];
        
        [dataObjects addObject:dataObject];
    }
    
    rootObject.data = dataObjects;
    
    return rootObject;
}
@end

