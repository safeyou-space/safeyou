//
//  PasswordTextField.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/31/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "PasswordTextField.h"

@interface PasswordTextField ()

@property (nonatomic, strong) UIButton *showHideButton;
@property (nonatomic, strong) UIView *eyeButtonView;

@end

@implementation PasswordTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureEyeButton];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureEyeButton];
        [self setup];
    }
    return self;
}

- (void)configureEyeButton
{
    self.showHideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.showHideButton.frame = CGRectMake(0, 0, 40, 40);
    [self.showHideButton setImage:[UIImage systemImageNamed:@"eye.fill"] forState:UIControlStateNormal];
    [self.showHideButton addTarget:self action:@selector(showHideButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.eyeButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [self.eyeButtonView addSubview:self.showHideButton];
}

- (void)setup {
    // Create the show/hide button
    self.rightView = self.eyeButtonView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

- (void)showHideButtonTapped:(UIButton *)sender {
    // Toggle secureTextEntry property of the text field
    self.secureTextEntry = !self.secureTextEntry;

    // Change eye icon based on the secureTextEntry state
    UIImage *eyeImage = self.secureTextEntry ? [UIImage systemImageNamed:@"eye.fill"] : [UIImage systemImageNamed:@"eye.slash.fill"];
    [self.showHideButton setImage:eyeImage forState:UIControlStateNormal];
}

@end
