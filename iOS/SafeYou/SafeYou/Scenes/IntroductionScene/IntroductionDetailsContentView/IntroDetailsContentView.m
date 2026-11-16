//
//  IntroDetailsContentView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/24/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "IntroDetailsContentView.h"
#import "IntroductionContentViewModel.h"

@interface IntroDetailsContentView ()

@property (nonatomic) IntrodutionDescriptionViewModel *viewMdel;

@property (weak, nonatomic) IBOutlet SYLabelBold *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *descriptionLabel;

@end

@implementation IntroDetailsContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithViewModel:(IntrodutionDescriptionViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.viewMdel = viewModel;
        [self commonInit];
    }

    return self;
}

- (void)layoutSubviews
{
//    [self updateUI];
    [super layoutSubviews];
}

#pragma mark - ConfigureUI

- (void)updateUI
{
    self.titleLabel.text = LOC(self.viewMdel.titleLocalizationKey);
    self.descriptionLabel.text = LOC(self.viewMdel.mainTextLocalizationKey);
}

#pragma mark - Private
- (void)commonInit {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"IntroDetailsContentView" owner:self options:nil] firstObject];
    [self addSubview:view];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self updateUI];
}

@end
