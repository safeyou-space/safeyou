//
//  LoginWithPinViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/31/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "LoginWithPinViewController.h"
#import "PinNumberView.h"
#import "AppDelegate.h"
#import "ApplicationLaunchCoordinator.h"

@interface LoginWithPinViewController () <PinNumberViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputViewContainer;
@property (weak, nonatomic) IBOutlet SYLabelRegular *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *numberContainerView;

@property (weak, nonatomic) IBOutlet SYDesignableView *input1;
@property (weak, nonatomic) IBOutlet SYDesignableView *input2;
@property (weak, nonatomic) IBOutlet SYDesignableView *input3;
@property (weak, nonatomic) IBOutlet SYDesignableView *input4;

@property (strong, nonatomic) IBOutletCollection(SYDesignableView) NSArray *inputsCollection;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic) NSMutableString *inputPinString;
@property (nonatomic) PinNumberView *numbersView;



@end

@implementation LoginWithPinViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.inputPinString = [[NSMutableString alloc] initWithCapacity:4];
        self.numbersView = [[PinNumberView alloc] initWithNibName:@"PinNumberView" bundle:nil];
        self.numbersView.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNumbersView];
    self.view.backgroundColor = [UIColor redColor];
    self.backgroundImageView.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    self.titleLabel.text = LOC(@"enter_passcode_text_key");
    [self configureNumbersView];
}

#pragma mark - Customization

- (void)configureNavigationBar
{
    if (self.isFromSignInFlow) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

#pragma mark - Configure Views

- (void)configureNumbersView
{
    self.numberContainerView.backgroundColor = [UIColor clearColor];
    self.numbersView.view.frame = self.numberContainerView.bounds;
    [self addChildViewController:self.numbersView];
    [self.numberContainerView addSubview:self.numbersView.view];
    self.numbersView.view.backgroundColor = [UIColor clearColor];
    [self.numbersView didMoveToParentViewController:self];
}


#pragma mark -  Update Views

- (void)shakeInputView
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.07];
    [animation setRepeatCount:1];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.inputViewContainer center].x - 20.0f, [self.inputViewContainer center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.inputViewContainer center].x + 20.0f, [self.inputViewContainer center].y)]];
    [[self.inputViewContainer layer] addAnimation:animation forKey:@"position"];
}

- (void)resetInputView
{
    self.input1.backgroundColorAlpha = 0.12;
    self.input2.backgroundColorAlpha = 0.12;
    self.input3.backgroundColorAlpha = 0.12;
    self.input4.backgroundColorAlpha = 0.12;
}

- (void)updateInputViewState
{
    [self resetInputView];
    
    for (int i = 0 ; i < self.inputPinString.length; ++i) {
        SYDesignableView *inputView = self.inputsCollection[i];
        inputView.backgroundColorAlpha = 1.0;
    }
}

#pragma mark - PinNumberViewDelegate

- (void)numberView:(PinNumberView *)numberView didSelectNumber:(NSString *)numberText
{
    [self.inputPinString appendString:numberText];
    if (self.inputPinString.length > 4) {
        [self.inputPinString deleteCharactersInRange:NSMakeRange([self.inputPinString length]-1, 1)];
        return;
    }
    [self updateInputViewState];
    if (self.inputPinString.length == 4) {
        // do request staff
        BOOL correct = [[Settings sharedInstance].userPin isEqualToString:self.inputPinString];
        if (correct) {
            // open Application
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate openApplication:self.isFromSignInFlow];
        } else if ([[Settings sharedInstance].userFakePin isEqualToString:self.inputPinString]) {
            // show fake view
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate openFakeApplication];
        } else {
            self.inputPinString = [@"" mutableCopy];
            [self shakeInputView];
            [self resetInputView];
        }
    }
}

- (void)numberViewDidSelectBackspace:(PinNumberView *)numberView
{
    if (self.inputPinString.length == 0) {
        return;
    }
    [self.inputPinString deleteCharactersInRange:NSMakeRange([self.inputPinString length]-1, 1)];
    [self updateInputViewState];
}

- (void)numberViewDidSelectForgotPin:(PinNumberView *)numberView
{
    if ([self isEqual:self.navigationController.viewControllers[0]]) {
        if ([self.delegate respondsToSelector:@selector(loginWithPinViewDidSelectForgotPin:)]) {
            [self.delegate loginWithPinViewDidSelectForgotPin:self];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
