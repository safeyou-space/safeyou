//
//  ReportViewController.h
//  SafeYou
//
//  Created by Edgar on 22.07.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportViewController : UITableViewController

@property (nonatomic) ChatMessageDataModel *comment;
@property (nonatomic) NSNumber *forumId;
@property (nonatomic) NSString *roomKey;
@property (nonatomic) BOOL isForumReport;

@end

NS_ASSUME_NONNULL_END
