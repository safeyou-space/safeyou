//
//  BaseDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDataModel : NSObject <NSCoding, NSCopying>

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
