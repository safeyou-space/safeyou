//
//  BasetableViewCellWithCheckMark.m
//  Fantasy
//
//  Created by Gevorg Karapetyan on 8/4/15.
//  Copyright (c) 2015 BetConstruct. All rights reserved.
//

#import "BaseTableViewCellWithCheckMark.h"

@implementation BaseTableViewCellWithCheckMark

- (void)setIsMultiSelect:(BOOL)isMultiSelect
{
    _isMultiSelect = isMultiSelect;
    _checkDeactiveImageView.hidden = !_isMultiSelect;
    _checkDeactiveImageView.hidden = YES;
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
//    _checkDeactiveImageView.hidden = _isSelect;
    _checkDeactiveImageView.hidden = YES;
    _checkActiveImageView.hidden = !_isSelect;
}

@end
