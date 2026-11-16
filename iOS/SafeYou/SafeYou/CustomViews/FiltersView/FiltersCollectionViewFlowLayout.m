//
//  FiltersCollectionViewFlowLayout.m
//  SafeYou
//
//  Created by MacBook Pro on 04.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "FiltersCollectionViewFlowLayout.h"

@implementation FiltersCollectionViewFlowLayout

- (instancetype)initWithItemMaxSpace:(CGFloat)space
{
    self = [super init];
    if (self) {
        self.itemsMaxSpace = space;
        self.estimatedItemSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    return self;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];

    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);

        if(origin + self.itemsMaxSpace + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + self.itemsMaxSpace;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
