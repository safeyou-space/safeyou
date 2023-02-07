//
//  SYDesignableCheckBoxButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableCheckBoxButton.h"

@implementation SYDesignableCheckBoxButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setTitle:@"" forState:UIControlStateNormal];
        [self setTitle:@"" forState:UIControlStateSelected];
        if (self.checkedImage) {
            [self setBackgroundImage:self.checkedImage forState:UIControlStateSelected];
        } else {
            // set application default checkbox icon
            self.checkedImage = [[UIImage imageNamed:@"icon_checkbox_checked"] imageWithTintColor: UIColor.mainTintColor1];
        }
        
        if (self.unCheckedImage) {
            [self setBackgroundImage:self.unCheckedImage forState:UIControlStateNormal];
        } else {
            // set application default checkbox icons
            self.unCheckedImage = [[UIImage imageNamed:@"icon_checkbox_unchecked"] imageWithTintColor: UIColor.mainTintColor1];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self sizeToFit];
    UIImage *image = [self imageForState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(0., self.frame.size.width - image.size.width, 0., 0.);
    self.titleEdgeInsets = UIEdgeInsetsMake(0., -self.frame.size.width/2 - image.size.width, 0., image.size.width);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = [self imageForState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(0., self.frame.size.width - image.size.width, 0., 0.);
    self.titleEdgeInsets = UIEdgeInsetsMake(0., -self.frame.size.width/2 - image.size.width, 0., image.size.width);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.selected = !self.selected;
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - Setter (Inspectables)

- (void)setCheckedImage:(UIImage *)checkedImage
{
    _checkedImage = checkedImage;
    [self setBackgroundImage:self.checkedImage forState:UIControlStateSelected];
}

- (void)setUnCheckedImage:(UIImage *)unCheckedImage
{
    _unCheckedImage = unCheckedImage;
    [self setBackgroundImage:self.unCheckedImage forState:UIControlStateNormal];
}

@end
