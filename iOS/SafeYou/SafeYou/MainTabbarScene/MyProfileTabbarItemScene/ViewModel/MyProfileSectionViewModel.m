//
//  MyProfileSectionViewModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "MyProfileSectionViewModel.h"

@implementation MyProfileRowViewModel : NSObject

@synthesize fieldTitle = _fieldTitle;
@synthesize rowType = _rowType;

- (instancetype)initWithTitle:(NSString *)title rowType:(MyProfileRowType)type
{
    self = [super init];
    if (self) {
        _fieldTitle = title;
        _rowType = type;
    }
    
    return self;
}

@end

@implementation MyProfileSectionViewModel

@synthesize sectionDataSource = _sectionDataSource;
@synthesize sectionTitle = _sectionTitle;
@synthesize footerTitle = _footerTitle;
@synthesize footertext = _footertext;

- (instancetype)initWithRows:(NSArray <MyProfileRowViewModel *>*)rows
{
    self = [super init];
    if (self) {
        _sectionDataSource = rows;
        _sectionTitle = @"";
        _footerTitle = @"";
        _footertext = @"";
    }
    
    return self;
}

@end
