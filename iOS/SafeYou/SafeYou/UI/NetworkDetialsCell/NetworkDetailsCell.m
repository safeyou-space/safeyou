//
//  NetworkDetailsCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/9/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NetworkDetailsCell.h"
#import "ServiceContactViewModel.h"
#import <SDWebImage.h>

@interface NetworkDetailsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *contactNameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *contactValueLabel;


@end

@implementation NetworkDetailsCell

- (void)configureWithViewModel:(ServiceContactViewModel *)viewData
{
    if (viewData.iconURL) {
        NSString *iconURLString = [NSString stringWithFormat:@"%@%@", BASE_RESOURCE_URL, viewData.iconURL];
        NSURL *iconURL = [NSURL URLWithString:iconURLString];
        [self.contactImageView sd_setImageWithURL:iconURL];
    }
    self.contactNameLabel.text = viewData.contactName;
    self.contactValueLabel.text = viewData.contactValue;
}

- (void)configureWithImage:(UIImage *)image title:(NSString *)title value:(NSString *)value
{
    self.contactImageView.image = image;
    self.contactNameLabel.text = title;
    self.contactValueLabel.text = value;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
