//
//  ChooseLanguageVC.m
//  SafeYou
//
//  Created by Garnik Simonyan on 8/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "ChooseLanguageVC.h"
#import "SYCorneredButton.h"

@interface ChooseLanguageVC ()
@property (weak, nonatomic) IBOutlet SYCorneredButton *armenianLanguageButton;
@property (weak, nonatomic) IBOutlet SYCorneredButton *englishLanguageButton;

- (IBAction)armenianLanguageButtonAction:(UIButton *)sender;
- (IBAction)englishLanguageButtonAction:(UIButton *)sender;

@end

@implementation ChooseLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @" ";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([[Settings sharedInstance].selectedLanguageCode isEqualToString:@"en"]) {
        self.englishLanguageButton.selected = YES;
    }
    
    if ([[Settings sharedInstance].selectedLanguageCode isEqualToString:@"en"]) {
        self.armenianLanguageButton.selected = YES;
    }
}


#pragma mark - Actions

- (IBAction)armenianLanguageButtonAction:(UIButton *)sender {
//    [Settings sharedInstance].selectedLanguageCode = @"hy";
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self performSegueWithIdentifier:@"showIntroductionView" sender:nil];
//    }
}

- (IBAction)englishLanguageButtonAction:(UIButton *)sender {
//    [Settings sharedInstance].selectedLanguageCode = @"en";
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self performSegueWithIdentifier:@"showIntroductionView" sender:nil];
//    }
}

@end
