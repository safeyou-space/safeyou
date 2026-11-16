//
//  SYViewController+CustomBarButtonItems.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/2/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import "SYViewController+CustomBarButtonItems.h"

@implementation UIViewController (CustomBarButtonItems)

- (void)configureBackBarButtonItem
{
    if (self.navigationController && self == self.navigationController.viewControllers.firstObject) {
        return;
    }
    SYDesignableBarButtonItem *backBarButtonitem = [[SYDesignableBarButtonItem alloc] initWithTitle:LOC(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    backBarButtonitem.tintColorType = SYColorTypeOtherAccent;
    self.navigationItem.leftBarButtonItem = backBarButtonitem;
}

- (void)backButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
