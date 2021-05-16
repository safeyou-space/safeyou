//
//  UIViewController+AlertInterface.h
//  iFix
//
//  Created by Gevorg Karapetyan on 15/10/2017.
//  Copyright © 2017 iFix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertInterface)

- (UIAlertController*)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle cancelAction:(void(^)(void))cancel okAction:(void(^)(void))ok;

- (UIAlertController*)showActionSheetWithTitle:(NSString*)title withMessage:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle moreButton1Title:(NSString*)moreButton1Title moreButton2Title:(NSString*)moreButton2Title cancelAction:(void(^)(void))cancel moreButton1Action:(void(^)(void))button1Action moreButton2Action:(void(^)(void))button2Action;

@end
