//
//  ChooseRegionalOptionViewModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseRegionalOptionViewModel.h"
#import "RegionalOptionDataModel.h"
#import "ImageDataModel.h"

@implementation ChooseRegionalOptionViewModel

@synthesize optionImageUrl = _optionImageUrl;
@synthesize optionTitle = _optionTitle;
@synthesize isSelected = _isSelected;
@synthesize regionalOptionData = _regionalOptionData;

- (instancetype)initWithData:(RegionalOptionDataModel *)regionalOptionData
{
    self = [super init];
    if (self) {
        _regionalOptionData = regionalOptionData;
        _optionTitle = regionalOptionData.name;
        NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", BASE_RESOURCE_URL, regionalOptionData.imageData.url];
        _optionImageUrl = [NSURL URLWithString:imageUrlString];
        _isSelected = NO;
    }
    
    return self;
}

@end

@implementation ChooseCountryViewModel : ChooseRegionalOptionViewModel

@end

@implementation ChooseLanguageViewModel : ChooseRegionalOptionViewModel

@synthesize optionImageUrl = _optionImageUrlPrivate;

- (instancetype)initWithData:(RegionalOptionDataModel *)regionalOptionData
{
    self = [super initWithData:regionalOptionData];
    if (self) {
        _optionImageUrlPrivate = nil;
    }
    
    return self;
}

@end

