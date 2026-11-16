//
//  UIViewController+AlertInterface.m
//  iFix
//
//  Created by Gevorg Karapetyan on 15/10/2017.
//  Copyright © 2017 iFix. All rights reserved.
//

#import "UIViewController+AlertInterface.h"

@implementation UIViewController (AlertInterface)

- (UIAlertController*)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle cancelAction:(void(^)(void))cancel okAction:(void(^)(void))ok
{
    if (!self.presentedViewController || (self.presentedViewController && ![self.presentedViewController isKindOfClass:[UIAlertController class]])) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:cancelButtonTitle
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action){
                                               if (cancel) {
                                                   cancel();
                                               }
                                           }];
            [alertController addAction:cancelAction];
        }
        
        if (okButtonTitle) {
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:okButtonTitle
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action){
                                           if (ok) {
                                               ok();
                                           }
                                       }];
            [alertController addAction:okAction];
        }
        
        alertController.view.tintColor = [UIColor purpleColor2];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return alertController;
    }
    return nil;
}

- (UIAlertController*)showActionSheetWithTitle:(NSString*)title withMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle moreButton1Title:(NSString*)moreButton1Title moreButton2Title:(NSString*)moreButton2Title cancelAction:(void(^)(void))cancel moreButton1Action:(void(^)(void))button1Action moreButton2Action:(void(^)(void))button2Action
{
    if (!self.presentedViewController || (self.presentedViewController && ![self.presentedViewController isKindOfClass:[UIAlertController class]])) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:cancelButtonTitle
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               if (cancel) {
                                                   cancel();
                                               }
                                           }];
            [alertController addAction:cancelAction];
        }
        
        if (moreButton1Title) {
            UIAlertAction *moreButton1Action = [UIAlertAction
                                                actionWithTitle:moreButton1Title
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action){
                                                    if (button1Action) {
                                                        button1Action();
                                                    }
                                                }];
            [alertController addAction:moreButton1Action];
        }
        
        if (moreButton2Title) {
            UIAlertAction *moreButton2Action = [UIAlertAction
                                                actionWithTitle:moreButton2Title
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action){
                                                    if (button2Action) {
                                                        button2Action();
                                                    }
                                                }];
            [alertController addAction:moreButton2Action];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return alertController;
    }
    return nil;
}

- (void)showInternetConnectionAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LOC(@"error_text_key") message:LOC(@"check_internet_connection_text_key") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LOC(@"ok") style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

