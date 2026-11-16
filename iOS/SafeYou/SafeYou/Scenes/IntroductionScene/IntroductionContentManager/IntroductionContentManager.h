//
//  IntroductionContentManager.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/23/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IntrodutionDescriptionViewModel, IntroductionContentViewModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IntroductionContentType) {
    IntroductionContentTypeDualPin,
    IntroductionContentTypeEmergencyContacts,
    IntroductionContentTypePrivateMessages,
    IntroductionContentTypeForums,
    IntroductionContentTypeHelpButton,
    IntroductionContentTypeNetwork

};

@interface IntroductionContentManager : NSObject

- (IntroductionContentViewModel *)viewModelForType:(IntroductionContentType)contentType;

@end

NS_ASSUME_NONNULL_END
