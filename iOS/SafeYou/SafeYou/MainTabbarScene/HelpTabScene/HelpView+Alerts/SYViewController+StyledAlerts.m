//
//  SYViewController+StyledAlerts.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/3/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController+StyledAlerts.h"
#import "UserDataModels.h"
#import "UserDetail.h"
#import "EmergencyServiceDataModel.h"


@implementation SYViewController (StyledAlerts)

#pragma mark - Info alert
- (void)showInfoAlert
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *titleString = LOC(@"alert_message_title");
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:titleString];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    [title addAttribute:NSFontAttributeName
                  value:[UIFont hyRobotoFontBoldOfSize:20.0]
                  range:NSMakeRange(0, title.length)];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[UIColor mainTintColor1]
                  range:NSMakeRange(0, title.length)];
    

    NSString *messageString = [NSString stringWithFormat:@"%@\n\n", LOC(@"add_emergency_contacts_text_key")];
        
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attributedMessage addAttribute:NSFontAttributeName
                              value:[UIFont hyRobotoFontRegularOfSize:16.0]
                              range:NSMakeRange(0, attributedMessage.length)];
    
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor mainTintColor1] range:NSMakeRange(0, attributedMessage.length)];
    
    UserDataModel *onlineUser = [Settings sharedInstance].onlineUser;
    
    
    
    NSMutableString *contactsString = [[NSMutableString alloc] init];
    
    for (EmergencyContactDataModel *userContact in onlineUser.emergencyContacts) {
        NSString *contactName = userContact.name;
        [contactsString appendString:contactName];
        if (userContact == onlineUser.emergencyContacts.lastObject) {
            [contactsString appendString:@"\n"];
        } else {
            [contactsString appendString:@","];
        }
    }
    
    for (EmergencyServiceDataModel *userContact in onlineUser.emergencyServices) {
        NSString *contactName = userContact.userDetails.firstName;
        [contactsString appendString:contactName];
        if (userContact == onlineUser.emergencyServices.lastObject) {
            [contactsString appendString:@"\n"];
        } else {
            [contactsString appendString:@","];
        }
    }
    
    NSMutableAttributedString *contactsAttrString;
    if (contactsString) {
        contactsAttrString = [[NSMutableAttributedString alloc] initWithString:contactsString];
        [contactsAttrString addAttributes:@{NSForegroundColorAttributeName: [UIColor mainTintColor1],
                                           NSFontAttributeName:[UIFont hyRobotoFontBoldOfSize:16.0]
        } range:NSMakeRange(0, contactsString.length)];
    }
    
    if (contactsAttrString) {
        [attributedMessage appendAttributedString:contactsAttrString];
    }
    
    [alertVC setValue:title forKey:@"attributedTitle"];
    [alertVC setValue:attributedMessage forKey:@"attributedMessage"];

    UIAlertAction *button = [UIAlertAction actionWithTitle:LOC(@"ok")
                                            style:UIAlertActionStyleCancel
                                            handler:nil];
    alertVC.view.tintColor = [UIColor mainTintColor1];
    [alertVC addAction:button];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showMessageSentAlert
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *titleString = LOC(@"alert_message_sent_text_key");
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:titleString];
    [attrTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    [attrTitle addAttribute:NSFontAttributeName
                  value:[UIFont hyRobotoFontBoldOfSize:20.0]
                  range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName
                  value:[UIColor mainTintColor1]
                  range:NSMakeRange(0, attrTitle.length)];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM.dd.YYYY";
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm";
    NSString *timeString = [timeFormatter stringFromDate:currentDate];
    NSString *messageString = [NSString stringWithFormat:@"%@ \n %@", dateString, timeString];;
        
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attributedMessage addAttribute:NSFontAttributeName
                              value:[UIFont hyRobotoFontRegularOfSize:16.0]
                              range:NSMakeRange(0, attributedMessage.length)];
    
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor mainTintColor1] range:NSMakeRange(0, attributedMessage.length)];
    
    [alertVC setValue:attrTitle forKey:@"attributedTitle"];
    [alertVC setValue:attributedMessage forKey:@"attributedMessage"];
    
    UIAlertAction *button = [UIAlertAction actionWithTitle:LOC(@"close_key")
                                            style:UIAlertActionStyleCancel
                                            handler:nil];
    alertVC.view.tintColor = [UIColor mainTintColor1];
    [alertVC addAction:button];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showStyledAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    [attrTitle addAttribute:NSFontAttributeName
                  value:[UIFont hyRobotoFontBoldOfSize:20.0]
                  range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName
                  value:[UIColor mainTintColor1]
                  range:NSMakeRange(0, attrTitle.length)];
    
        
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [attributedMessage addAttribute:NSFontAttributeName
                              value:[UIFont hyRobotoFontRegularOfSize:16.0]
                              range:NSMakeRange(0, attributedMessage.length)];
    
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor mainTintColor1] range:NSMakeRange(0, attributedMessage.length)];
    [alertVC setValue:attrTitle forKey:@"attributedTitle"];
    [alertVC setValue:attributedMessage forKey:@"attributedMessage"];
    
    UIAlertAction *button = [UIAlertAction actionWithTitle:LOC(@"close_key")
                                            style:UIAlertActionStyleCancel
                                            handler:nil];
    alertVC.view.tintColor = [UIColor mainTintColor1];
    [alertVC addAction:button];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showReocrdSavedAlert
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *titleString = LOC(@"record_was_successfully_saved_text_key");
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:titleString];
    [attrTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    [attrTitle addAttribute:NSFontAttributeName
                  value:[UIFont hyRobotoFontBoldOfSize:20.0]
                  range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName
                  value:[UIColor mainTintColor1]
                  range:NSMakeRange(0, attrTitle.length)];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM.dd.YYYY";
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm";
    NSString *timeString = [timeFormatter stringFromDate:currentDate];
    NSString *messageString = [NSString stringWithFormat:@"%@ \n %@", dateString, timeString];;
        
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attributedMessage addAttribute:NSFontAttributeName
                              value:[UIFont hyRobotoFontRegularOfSize:16.0]
                              range:NSMakeRange(0, attributedMessage.length)];
    
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor mainTintColor1] range:NSMakeRange(0, attributedMessage.length)];
    [alertVC setValue:attrTitle forKey:@"attributedTitle"];
    [alertVC setValue:attributedMessage forKey:@"attributedMessage"];
    
    UIAlertAction *button = [UIAlertAction actionWithTitle:LOC(@"close_key")
                                            style:UIAlertActionStyleCancel
                                            handler:nil];
    alertVC.view.tintColor = [UIColor mainTintColor1];
    [alertVC addAction:button];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showReocrdSentAlert:(NSString *)recordName recordDate:(NSString *)recordDate
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *titleString = LOC(@"record_was_successfully_sent_text_key");
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:titleString];
    [attrTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    [attrTitle addAttribute:NSFontAttributeName
                  value:[UIFont hyRobotoFontBoldOfSize:20.0]
                  range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName
                  value:[UIColor mainTintColor1]
                  range:NSMakeRange(0, attrTitle.length)];

    NSString *messageString = [NSString stringWithFormat:@"%@ \n %@", recordName, recordDate];;
        
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attributedMessage addAttribute:NSFontAttributeName
                              value:[UIFont hyRobotoFontRegularOfSize:16.0]
                              range:NSMakeRange(0, attributedMessage.length)];
    
    [attributedMessage addAttribute:NSForegroundColorAttributeName value:[UIColor mainTintColor1] range:NSMakeRange(0, attributedMessage.length)];
    
    [alertVC setValue:attrTitle forKey:@"attributedTitle"];
    [alertVC setValue:attributedMessage forKey:@"attributedMessage"];
    
    UIAlertAction *button = [UIAlertAction actionWithTitle:LOC(@"close_key")
                                            style:UIAlertActionStyleCancel
                                            handler:nil];
    alertVC.view.tintColor = [UIColor mainTintColor1];
    [alertVC addAction:button];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
