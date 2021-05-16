//
//  HelpMessageDataModel.h
//
//  Created by   on 5/15/20
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "BaseDataModel.h"



@interface HelpMessageDataModel : BaseDataModel

@property (nonatomic, assign) double messageId;
@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSArray *translations;
@property (nonatomic, strong) NSString *translation;

- (NSString *)messageForLanguage:(NSString *)languageCode;

@end
