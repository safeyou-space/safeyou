//
//  RecordListItemTableViewCell.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordListItemDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecordListItemTableViewCell : UITableViewCell

- (void)configureCellWithRecordData:(RecordListItemDataModel *)recordData;
- (void)configureCellWithRecordName:(NSString *)recordName;


@end

NS_ASSUME_NONNULL_END
