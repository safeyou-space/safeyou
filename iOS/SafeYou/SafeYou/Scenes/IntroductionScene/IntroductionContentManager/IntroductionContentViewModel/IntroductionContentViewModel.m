//
//  IntroductionContentViewModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/23/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "IntroductionContentViewModel.h"

@implementation IntrodutionDescriptionViewModel

- (instancetype)initWithTitleLocalizationKey:(NSString *)titleLocalizationKey
                       mainTextLocalizationKey:(NSString *)mainTextLocKey
{
    self = [super init];
    if (self) {
        self.titleLocalizationKey = titleLocalizationKey;
        self.mainTextLocalizationKey = mainTextLocKey;
    }

    return self;
}

@end

@implementation IntroductionContentViewModel

- (instancetype)initWithImageName:(NSString *)imageName
                      titleLocKey:(NSString *)titleLocKey
                    headingLocKey:(NSString *)headingLocKey
{
    self = [super init];
    if (self) {
        self.iconImageName = imageName;
        self.titleLocKey = titleLocKey;
        self.headingLocKey = headingLocKey;
    }

    return self;
}

- (NSString *)localizedHeading
{
    return LOC(self.headingLocKey);
}

- (NSString *)localizedTitle
{
    return LOC(self.titleLocKey);
}

@end
