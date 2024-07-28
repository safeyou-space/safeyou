//
//  IntroductionContentViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/23/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntrodutionDescriptionViewModel : NSObject

@property (nonatomic) NSString *titleLocalizationKey;
@property (nonatomic) NSString *localizedTitle;
@property (nonatomic) NSString *mainTextLocalizationKey;
@property (nonatomic) NSString *localizedMainText;

- (instancetype)initWithTitleLocalizationKey:(NSString *)titleLocalizationKey
                       mainTextLocalizationKey:(NSString *)mainTextLocKey;

@end

@interface IntroductionContentViewModel : NSObject

@property (nonatomic) NSString *iconImageName;
@property (nonatomic) NSString *titleLocKey;
@property (nonatomic) NSString *localizedTitle;
@property (nonatomic) NSString *headingLocKey;
@property (nonatomic) NSString *localizedHeading;
@property (nonatomic) NSArray<IntrodutionDescriptionViewModel *> *descritpionContents;

- (instancetype)initWithImageName:(NSString *)imageName
                      titleLocKey:(NSString *)titleLocKey
                    headingLocKey:(NSString *)headingLocKey;


@end

NS_ASSUME_NONNULL_END
