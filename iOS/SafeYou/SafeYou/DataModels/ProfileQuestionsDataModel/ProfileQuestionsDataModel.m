//
//  ProfileQuestionsDataModel.m
//  SafeYou
//
//  Created by armen sahakian on 02.08.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "ProfileQuestionsDataModel.h"

@implementation ProfileQuestionsOption

- (instancetype)initWithId:(NSNumber *)id
                     title:(NSString *)name
                    title2:(NSNumber *)provinceId
                      type:(NSString *)type {
    self = [super init];
    if (self) {
        _id = id;
        _name = [name copy];
        _provinceId = [provinceId copy];
        _type = [type copy];
    }
    return self;
}

+ (NSArray<ProfileQuestionsOption *> *)createWithOptionsData:(NSArray<NSDictionary *> *)data {
    NSMutableArray<ProfileQuestionsOption *> *optionsArray = [NSMutableArray array];
    
    for (NSDictionary *dataDict in data) {
        ProfileQuestionsOption *option = [[ProfileQuestionsOption alloc] init];
        option.id = dataDict[@"id"];
        option.name = dataDict[@"name"];
        option.provinceId = dataDict[@"provinceId"];
        option.type = dataDict[@"type"];
        
        [optionsArray addObject:option];
    }
    
    return [optionsArray copy];
}

@end

@implementation ProfileQuestionsDataModel

- (instancetype)initWithId:(NSNumber *)id
                     title:(NSString *)title
                    title2:(NSString *)title2
                      type:(NSString *)type
                   options:(NSArray<ProfileQuestionsOption *> *)options {
    self = [super init];
    if (self) {
        _id = id;
        _title = [title copy];
        _title2 = [title2 copy];
        _type = [type copy];
        _options = [options copy];
    }
    return self;
}

+ (NSArray<ProfileQuestionsDataModel *> *)createWithData:(NSArray<NSDictionary *> *)data {
    NSMutableArray<ProfileQuestionsDataModel *> *dataArray = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        NSNumber *id = dict[@"id"];
        NSString *title = dict[@"title"];
        NSString *title2 = dict[@"title2"];
        NSString *type = dict[@"type"];
        NSArray *optionsData = dict[@"options"];
        NSMutableArray<ProfileQuestionsOption *> *options = [NSMutableArray array];
        
        for (NSDictionary *optionDict in optionsData) {
            NSNumber *optionId = optionDict[@"id"];
            NSString *name = optionDict[@"name"];
            NSNumber *provinceId = optionDict[@"province_id"];
            NSString *optionType = optionDict[@"type"];
            
            ProfileQuestionsOption *option = [[ProfileQuestionsOption alloc] init];
            option.id = optionId;
            option.name = name;
            option.provinceId = provinceId;
            option.type = optionType;
            
            [options addObject:option];
        }
        
        ProfileQuestionsDataModel *model = [[ProfileQuestionsDataModel alloc] initWithId:id
                                                                                    title:title
                                                                                   title2:title2
                                                                                     type:type
                                                                                  options:options];
        [dataArray addObject:model];
    }
    return [dataArray copy];
}

@end
