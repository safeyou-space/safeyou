//
//  SYCorneredButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYCorneredButton.h"
#import "UIColor+SYColors.h"

@implementation SYCorneredButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureConrners];
    [self configureStates];
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self configureConrners];
//        [self configureStates];
//    }
//    return self;
//}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    
    [self configureConrners];
    [self configureStates];
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self configureConrners];
    [self.titleLabel sizeToFit];
}

- (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Customize

- (void)configureStates
{
    UIImage *tintImage = [self imageWithColor:[UIColor mainTintColor1] size:CGSizeMake(1, 1)];
    UIImage *whiteImage = [self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    [self setTitleColor:[UIColor mainTintColor1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.layer.masksToBounds = YES;
    
    [self setBackgroundImage:whiteImage forState:UIControlStateNormal];
    [self setBackgroundImage:tintImage forState:UIControlStateSelected];
    
    UIImage *tintImageHighlighted = [self imageWithColor:[UIColor mainTintColor2] size:CGSizeMake(1, 1)];
    [self setBackgroundImage:tintImageHighlighted forState:UIControlStateHighlighted];
}

- (void)configureConrners
{
    [self setTitleColor:[UIColor mainTintColor1] forState:UIControlStateNormal];
    self.layer.borderColor = [UIColor mainTintColor1].CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
