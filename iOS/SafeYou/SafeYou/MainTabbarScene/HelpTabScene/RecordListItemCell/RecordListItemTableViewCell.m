//
//  RecordListItemTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordListItemTableViewCell.h"
#import "RecordListItemDataModel.h"


@interface RecordListItemTableViewCell ()

@property (weak, nonatomic) IBOutlet SYLabelBold *recordLocationlabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *recordTimelabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *recordDateLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *sentTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sentImageView;

@end

@implementation RecordListItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithRecordData:(RecordListItemDataModel *)recordData
{
    self.sentImageView.hidden = NO;
    self.recordLocationlabel.text = recordData.location;
    self.recordTimelabel.text = recordData.time;
    self.recordDateLabel.text = recordData.date;
    
    if (recordData.isSent) {
        self.sentTimeLabel.hidden = NO;
        self.sentImageView.hidden = NO;
        
        self.sentTimeLabel.text = recordData.time; //  ust be send time
        
    } else {
        self.sentTimeLabel.hidden = YES;
        self.sentImageView.hidden = YES;
    }
}

- (void)configureCellWithRecordName:(NSString *)recordName
{
    self.recordLocationlabel.text = recordName;
    self.recordTimelabel.text = @"";
    self.recordDateLabel.text = @"";
    self.sentTimeLabel.text = @"";
    self.sentImageView.hidden = YES;
    
}

@end
