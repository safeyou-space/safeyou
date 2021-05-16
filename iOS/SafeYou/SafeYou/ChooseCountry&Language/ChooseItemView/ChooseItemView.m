//
//  ChooseItemView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ChooseItemView.h"
#import "UIView+AutoLayout.h"
#import "SYRadioButton.h"
#import "ChooseRegionalOptionViewModel.h"
#import "SDWebImage.h"

@interface ChooseItemView ()

@property (nonatomic) NSString *title;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet SYRadioButton *radioButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)actionButtonPressed:(UIButton *)sender;
- (IBAction)actionButtonDown:(UIButton *)sender;
- (IBAction)touchOutAction:(UIButton *)sender;

@property (nonatomic, weak) SYDesignableView *contentView;
@property (nonatomic) BOOL highlighted;


@end

@implementation ChooseItemView

@synthesize viewData = _viewData;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title withoutImage:(BOOL)withoutImage
{
    self = [super initWithFrame:frame];
    if (self) {
        ChooseItemView *customView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseItemView" owner:self options:nil] objectAtIndex:0];
        self.contentView = customView;
        [self addSubviewWithZeroMargin:self.contentView];
        
        self.imageView.hidden = withoutImage;
        self.titleLabel.text = title;
    }
    return self;
}

- (instancetype)initWithViewData:(ChooseRegionalOptionViewModel *)viewData
{
    self = [super init];
    if (self) {
        _viewData = viewData;
        ChooseItemView *customView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseItemView" owner:self options:nil] objectAtIndex:0];
        self.contentView = customView;
        [self addSubviewWithZeroMargin:self.contentView];
        
        BOOL imageAvailable = viewData.optionImageUrl;
        self.imageView.hidden = !imageAvailable;
        if (imageAvailable) {
            [self.imageView sd_setImageWithURL:viewData.optionImageUrl];
        }
        
        self.titleLabel.text = viewData.optionTitle;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ChooseItemView *customView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseItemView" owner:self options:nil] objectAtIndex:0];
        [self addSubviewWithZeroMargin:customView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        ChooseItemView *customView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseItemView" owner:self options:nil] objectAtIndex:0];
        [self addSubviewWithZeroMargin:customView];
    }
    return self;
}


#pragma mark - Setters

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.radioButton.selected = _selected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    if (_highlighted) {
        self.contentView.backgroundColorAlpha = 0.3;
    } else {
        self.contentView.backgroundColorAlpha = 0.12;
    }
}

#pragma mark - Actions

- (IBAction)actionButtonPressed:(UIButton *)sender {
    // set selected value
    self.highlighted = NO;
    if (!self.selected) {
        self.selected = YES;
        if ([self.delegate respondsToSelector:@selector(chooseItemDidPressSelect:)]) {
            [self.delegate chooseItemDidPressSelect:self];
        }
    }
}

- (IBAction)actionButtonDown:(UIButton *)sender {
    self.highlighted = YES;
}

- (IBAction)touchOutAction:(UIButton *)sender {
    self.highlighted = NO;
}

@end
