//
//  OpenSurveysDataModel.h
//  SafeYou
//
//  Created by armen sahakian on 23.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenSurveyItemDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenSurveysDataModel : NSObject

@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSArray<OpenSurveyItemDataModel *> *data;

- (OpenSurveysDataModel *)createWithData:(NSDictionary *)data;

@end
NS_ASSUME_NONNULL_END
