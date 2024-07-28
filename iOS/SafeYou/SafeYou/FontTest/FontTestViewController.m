//
//  FontTestViewController.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/17/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "FontTestViewController.h"

@interface FontTestViewController ()
@property (weak, nonatomic) IBOutlet SYLabelRegular *regularLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *boldLabel;
@property (weak, nonatomic) IBOutlet SYLabelBoldItalic *boldItalicLabel;
@property (weak, nonatomic) IBOutlet SYLabelItalic *italicLabel;
@property (weak, nonatomic) IBOutlet SYLabelLight *lightLabel;
@property (weak, nonatomic) IBOutlet SYLabelLightItalic *lightItalicLabel;
@property (weak, nonatomic) IBOutlet SYLabelMediumItalic *mediumItalicLabel;
@property (weak, nonatomic) IBOutlet SYLabelMedium *mediumLabel;

@end

@implementation FontTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self.restorationIdentifier isEqual:@"arm"]) {
        self.regularLabel.text = @"Ռեգուլյար";
        self.boldLabel.text = @"Բոլդ";
        self.boldItalicLabel.text = @"Բոլդ Իտալիկ";
        self.italicLabel.text = @"Իտալիկ";
        self.lightLabel.text = @"Լայթ";
        self.lightItalicLabel.text = @"Լայթ Իտալիկ";
        self.mediumItalicLabel.text = @"Մեդիում Իտալիկ";
        self.mediumLabel.text = @"Մեդիում";
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
