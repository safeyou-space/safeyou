//
//  WebContentViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "TermsViewController.h"
#import "ContentService.h"
#import <WebKit/WebKit.h>

@interface TermsViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webKitView;

@property (nonatomic) ContentService *contentService;
@property (nonatomic) NSString *htmlContent;

@end

@implementation TermsViewController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.contentService = [[ContentService alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureWebView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self configureNavibationBar];
}

- (void)configureNavibationBar
{
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainTintColor1]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIImage *image = [self imageWithColor:[UIColor mainTintColor1] withPoint:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setShadowImage:image];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor mainTintColor1];
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
}

- (IBAction)agreeButtonPressed:(SYDesignableBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(termsViewDidAcceptTerms:)]) {
        [self.delegate termsViewDidAcceptTerms:self];
    }
}

#pragma mark - Helper

- (UIImage *)imageWithColor:(UIColor *)color withPoint:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)configureWebView
{
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TermsAndConditions" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webKitView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Functionality

- (void)closePresentedView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
