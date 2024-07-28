//
//  ConsultantRequestStatusCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/29/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ConsultantRequestStatusCell.h"

#import "ConsultantRequestInfoViewModel.h"

@interface ConsultantRequestStatusCell ()

@property (weak, nonatomic) IBOutlet SYLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIconImage;
@property (weak, nonatomic) IBOutlet SYLabelRegular *statusDateLabel;


@end

@implementation ConsultantRequestStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure With Data

- (void)configureWithRequestInfoData:(ConsultantRequestInfoViewModel *)infoData
{
    self.statusDateLabel.textColorAlpha = 1;
    self.titleLabel.text = infoData.title;
    self.statusDateLabel.text = infoData.statusInfoText;
    UIImage *statusIcon = [UIImage imageNamed:infoData.iconName];
    if (statusIcon) {
        self.statusIconImage.hidden = NO;
        self.statusIconImage.image = statusIcon;
    } else {
        self.statusIconImage.hidden = YES;
        self.statusDateLabel.textColorType = SYColorTypeBlack;
    }
    switch (infoData.requestStatus) {
        case ConsultantRequestStatusPending:
            self.statusDateLabel.textColorType = SYColorTypeDarkGray;
            break;
            
        case ConsultantRequestStatusConfirmed:
            self.statusDateLabel.textColorType = SYColorTypeMain1;
            break;
            
        case ConsultantRequestStatusDeclined:
            self.statusDateLabel.textColorType = SYColorTypeRed;
            break;
            
        default:
            self.statusDateLabel.textColorType = SYColorTypeDarkGray;
            break;
    }
}

@end
