//
//  HelpMessageLanguageDataModel.h
//
//  Created by   on 5/15/20
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HelpMessageLanguageDataModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double status;
@property (nonatomic, assign) double languageIdentifier;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double imageId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) id updatedAt;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
