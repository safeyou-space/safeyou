//
//  SYViewController+StyledAlerts.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/3/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYViewController (StyledAlerts)

- (void)showInfoAlert;
- (void)showUpdateApplicationAlert;
- (void)showMessageSentAlert;
- (void)showReocrdSavedAlert;
- (void)showReocrdSentAlert:(NSString *)recordName recordDate:(NSString *)recordDate;
- (void)showStyledAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
