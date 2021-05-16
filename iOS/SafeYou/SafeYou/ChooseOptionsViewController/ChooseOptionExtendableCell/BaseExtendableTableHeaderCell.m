//
//  BaseExtendableTableHeaderCell.m
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 4/15/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "BaseExtendableTableHeaderCell.h"

@implementation BaseExtendableTableHeaderCell


- (IBAction)buttonAction:(UIButton *)sender
{
    [self.delegate didSelectAtSectionAtIndex:self.index];
}

- (void)setIsClose:(BOOL)isClose
{
    _isClose = isClose;
   
}

- (void)setIsExtend:(BOOL)isExtend
{
    _isExtend = isExtend;
}

@end
