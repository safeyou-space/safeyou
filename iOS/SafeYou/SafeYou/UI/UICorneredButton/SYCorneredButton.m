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
    self.enabled = self.enabled;
    [self configureConrners];
}


- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    CGFloat pointSize = self.titleLabel.font.pointSize;
    self.titleLabel.font = [UIFont boldFontOfSize:pointSize];
    [self configureConrners];
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
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

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    CGFloat fontSize = 16.0;
    if (highlighted) {
        self.layer.borderColor = [UIColor mainTintColor3].CGColor;
        self.layer.borderWidth = 2.0;
        fontSize = 14.0;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0.0;
        fontSize = 16.0;
    }
    self.titleLabel.font = [UIFont boldFontOfSize:fontSize];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    CGFloat fontSize = 16.0;
    if (enabled) {
        [self configureNormalState];
    } else {
        [self configureDisabledState];
    }
    self.titleLabel.font = [UIFont boldFontOfSize:fontSize];
}

#pragma mark - Customize

- (void)configureNormalState
{
    [self setTitleColor:[UIColor purpleColor1] forState:UIControlStateNormal];
    self.backgroundColorType = SYColorTypeMain1;
}

- (void)configureDisabledState
{
    self.backgroundColorType = SYColorTypeOtherGray;
    self.titleLabel.textColor = [UIColor lightGrayColor];
}

- (void)configureConrners
{
    [self setImage:nil forState:UIControlStateNormal];
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    [self setTitleColor:[UIColor purpleColor1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.layer.cornerRadius = 8;
}

@end
