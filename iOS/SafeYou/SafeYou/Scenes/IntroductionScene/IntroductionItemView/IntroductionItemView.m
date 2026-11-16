//
//  IntroductionItemView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/21/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "IntroductionItemView.h"

@interface IntroductionItemViewModel (Helper)

- (UIImage *)image;

@end

@implementation IntroductionItemViewModel (Helper)

- (UIImage *)image
{
    return [UIImage imageNamed:self.imageName];
}

@end


@interface IntroductionItemView  ()

@property (weak, nonatomic) IBOutlet SYDesignableView *contentView;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *iconImageView;
@property (weak, nonatomic) IBOutlet SYLabelBold *titleLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *clickActionGesture;

@end

@implementation IntroductionItemView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"IntroductionItemView" owner:self options:nil] firstObject];
    [self addSubview:view];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)configureWithViewModel:(IntroductionItemViewModel *)viewModel
{
    self.iconImageView.image = [viewModel image];
    self.titleLabel.text = viewModel.localizedTitle;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.cornerRadius = self.contentView.frame.size.width/2;
}

#pragma mark - IBAction

- (IBAction)itemClickedAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(itemViewDidSelect:)]) {
        [self.delegate itemViewDidSelect:self];
    }
}

@end

@implementation IntroductionItemViewModel

@synthesize localizedTitle;

- (instancetype)initWithLocalizationKey:(NSString *)localizationKey imageName:(NSString *)imageName;
{
    self = [super init];
    if (self) {
        self.titleLocalizationKey = localizationKey;
        self.imageName = imageName;
    }

    return self;
}

- (NSString *)localizedTitle
{
    return LOC(self.titleLocalizationKey);
}

@end
