//
//  ThumbnailCollectionViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/30/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"

@implementation ThumbnailCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
