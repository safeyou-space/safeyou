//
//  NotificationsIconView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "NotificationsIconView.h"
#import "UIView+AutoLayout.h"

@interface NotificationsIconView ()

@property (weak, nonatomic) IBOutlet UIButton *badgeButton;
@property (weak, nonatomic) IBOutlet SYDesignableImageView *notificationImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)notificationViewAction:(UIButton *)sender;

@end

@implementation NotificationsIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadCustomViewFromNib];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadCustomViewFromNib];
    }
    return self;
}

- (void)loadCustomViewFromNib
{
    if (self.subviews.count == 0) {
        UIView *customView = [[[NSBundle mainBundle] loadNibNamed:@"NotificationsIconView" owner:self options:nil] objectAtIndex:0];
        customView.backgroundColor = [UIColor clearColor];
        self.frame = customView.frame;
        [self addSubviewWithZeroMargin:customView];
        self.badgeButton.hidden = YES;
        self.actionButton.accessibilityLabel = @"Note";
    }
}

- (void)updateBadgeValue:(NSString *)badgeValue
{
    if ([badgeValue isEqualToString:@""] || [badgeValue isEqualToString:@"0"]) {
        self.badgeButton.hidden = YES;
    } else {
        self.badgeButton.hidden = NO;
    }
    [self.badgeButton setTitle:badgeValue forState:UIControlStateNormal];
    [self.badgeButton sizeToFit];
}
- (IBAction)notificationViewAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(notificationBarItemAction:)]) {
        [self.delegate notificationBarItemAction:self];
    }
}

- (void)setWhiteColorType
{
    self.notificationImageView.imageColorType = SYColorTypeWhite;
}

@end
