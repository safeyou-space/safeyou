//
//  SectionHeaderWithTitleImage.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/13/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SectionHeaderWithTitleImage.h"

@interface SectionHeaderWithTitleImage ()

@property (nonatomic, weak) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (nonatomic, weak) IBOutlet SYDesignableImageView *iconImageView;

@end

@implementation SectionHeaderWithTitleImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configureWithImage:(NSString *)imageName title:(NSString *)title
{
    if (title.length > 0) {
        self.titleLabel.hidden = NO;
        self.titleLabel.text = title;
    } else {
        self.titleLabel.hidden = YES;
    }
    
    if (imageName.length && [UIImage imageNamed:imageName]) {
        self.iconImageView.hidden = NO;
        self.iconImageView.image = [UIImage imageNamed:imageName];
    } else {
        self.iconImageView.hidden = YES;
    }
    
}

@end
