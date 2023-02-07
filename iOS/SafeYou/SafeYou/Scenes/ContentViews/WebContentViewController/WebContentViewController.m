//
//  WebContentViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "WebContentViewController.h"
#import "ContentService.h"
#import <WebKit/WebKit.h>

@interface WebContentViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webKitView;

@property (nonatomic) ContentService *contentService;
@property (nonatomic) NSString *htmlContent;

@end

@implementation WebContentViewController

+ (instancetype)initializeWebContentView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WebContent" bundle:nil];
    WebContentViewController *webContentView = [storyboard instantiateViewControllerWithIdentifier:@"WebContentViewController"];
    
    return webContentView;
}

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
    // Do any additional setup after loading the view.
    
    if (self.navigationController.presentingViewController) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(closePresentedView)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    [self showLoader];
    weakify(self);
    [self.contentService getContent:self.contentType complition:^(NSString * _Nonnull htmlContent) {
        strongify(self);
        [self hideLoader];
        self.htmlContent = htmlContent;
        [self configureWebView];
    } failure:^(NSError * _Nonnull error) {
        [self hideLoader];
    }];
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
}

#pragma mark - Localiations

- (void)updateLocalizations
{
    self.navigationItem.title = self.title;
    
    switch (self.contentType) {
        case SYRemotContentTypeTermsAndConditionsForAdults:
        case SYRemotContentTypeTermsAndConditionsForMinors:
            self.navigationItem.title = LOC(@"terms_and_conditions");
            break;
        case SYRemotContentTypeAboutUs:
            self.navigationItem.title = LOC(@"about_us_title_key");
            break;
        case SYRemotContentTypeConsultantTermsAndConditions:
            self.navigationItem.title = LOC(@"consultant_terms_and_conditions");
            break;
            
        case SYRemotContentTypePrivacyPolicyForAdults:
        case SYRemotContentTypePrivacyPolicyForMinors:
            self.navigationItem.title = LOC(@"privacy_policy");
            break;
            
        default:
            break;
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
    [self.webKitView loadHTMLString:self.htmlContent baseURL:nil];
    NSLog(@"contenthelo %@", self.htmlContent);
}

#pragma mark - Functionality

- (void)closePresentedView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
