//
//  ProfileQuestionsDataModel.h
//  SafeYou
//
//  Created by armen sahakian on 02.08.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileQuestionsOption : NSObject

@property (nonatomic, strong, nullable) NSNumber *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *provinceId;
@property (nonatomic, strong, nullable) NSString *type;

- (instancetype)initWithId:(NSNumber *)id
                     title:(NSString *)name
                    title2:(NSNumber *)provinceId
                      type:(NSString *)type;

+ (NSArray<ProfileQuestionsOption *> *)createWithOptionsData:(NSArray<NSDictionary *> *)data;

@end

@interface ProfileQuestionsDataModel : NSObject

@property (nonatomic, assign) NSNumber *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *title2;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray<ProfileQuestionsOption *> *options;

- (instancetype)initWithId:(NSNumber *)id
                     title:(NSString *)title
                    title2:(NSString *)title2
                      type:(NSString *)type
                   options:(NSArray<ProfileQuestionsOption *> *)options;

+ (NSArray<ProfileQuestionsDataModel *> *)createWithData:(NSArray<NSDictionary *> *)data;

@end

NS_ASSUME_NONNULL_END
