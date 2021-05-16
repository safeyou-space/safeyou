//
//  IntorductionDialogViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/24/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "IntorductionDialogViewController.h"
#import "SYSemiRoundedView.h"
#import "SYDesignableLabel.h"

@interface IntorductionDialogViewController ()

@property (weak, nonatomic) IBOutlet SYSemiRoundedView *contentView;

@property (weak, nonatomic) IBOutlet SYDesignableLabel *titleLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *messageLabel;

- (IBAction)closeButtonAction:(UIButton *)sender;

@end

@implementation IntorductionDialogViewController

{
    NSString *_messageTitle;
    NSString *_message;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super initWithNibName:@"IntorductionDialogViewController" bundle:nil];
    if (self) {
        _messageTitle = title;
        _message = message;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:_message];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:3];
    
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, _message.length)];
    self.messageLabel.attributedText = attrString;
    
    self.titleLabel.text = _messageTitle;
//    self.messageLabel.text = _message;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureShadow];
}

#pragma mark - View custinizations

- (void)configureCorners
{
    UIRectCorner corners = (UIRectCornerTopLeft | 0 | UIRectCornerBottomLeft | UIRectCornerBottomRight);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:(corners) cornerRadii:CGSizeMake(self.contentView.cornerRadius, 0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}

- (void)configureShadow
{
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowOffset = CGSizeMake(.0f,0.75f);
    self.contentView.layer.shadowRadius = _contentView.cornerRadius;
    self.contentView.layer.shadowOpacity = .7f;
    self.contentView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
