//
//  HelpMessageTranslationDataModel.h
//
//  Created by   on 5/15/20
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "BaseDataModel.h"

@class HelpMessageLanguageDataModel;

@interface HelpMessageTranslationDataModel : BaseDataModel

@property (nonatomic) double helpMessageId;
@property (nonatomic) double translationsIdentifier;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSNumber *languageId;
@property (nonatomic) HelpMessageLanguageDataModel *language;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *translation;


@end
