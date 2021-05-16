//
//  ChooseRegionalOptionViewModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseIconCellViewModel.h"
#import "ImageDataModel.h"

@implementation ChooseIconCellViewModel

@synthesize iconImageName = _iconImageName;
@synthesize optionTitle = _optionTitle;
@synthesize isSelected = _isSelected;


- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        
        _optionTitle = title;
        _iconImageName = imageName;
        _isSelected = NO;
    }
    
    return self;
}

@end
