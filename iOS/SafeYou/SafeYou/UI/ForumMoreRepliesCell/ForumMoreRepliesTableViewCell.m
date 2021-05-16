//
//  ForumMoreRepliesTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/24/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "ForumMoreRepliesTableViewCell.h"

@interface ForumMoreRepliesTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableLabel *numberOfRepliesLabel;
@property (weak, nonatomic) IBOutlet SYDesignableLabel *viewMoreRepliesLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation ForumMoreRepliesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithNumber:(NSNumber *)repliesNumber
{
    self.numberOfRepliesLabel.text = [NSString stringWithFormat:LOC(@"{param}_replies"), repliesNumber];
    self.viewMoreRepliesLabel.text = LOC(@"view_more_replies");
}

- (IBAction)selectCellButtonAction:(UIButton *)sender {
    if ([self.viewMoreDelegate respondsToSelector:@selector(didSelectViewMoreReplies:)]) {
        [self.viewMoreDelegate didSelectViewMoreReplies:self];
    }
}

@end
