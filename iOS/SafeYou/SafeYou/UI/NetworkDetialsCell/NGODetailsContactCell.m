//
//  NGODetailsContactCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/9/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NGODetailsContactCell.h"
#import "NGOContactViewModel.h"
#import <SDWebImage.h>
#import "NSString+HTML.h"

@interface NGODetailsContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet SYLabelRegular *contactNameLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *contactValueLabel;


@end

@implementation NGODetailsContactCell

- (void)configureWithViewModel:(NGOContactViewModel *)viewData
{
    if (viewData.icon) {
        self.contactImageView.image = viewData.icon;
    } else {
        if (viewData.iconURL) {
            NSString *iconURLString = [NSString stringWithFormat:@"%@%@", [Settings sharedInstance].baseResourceURL, viewData.iconURL];
            NSURL *iconURL = [NSURL URLWithString:iconURLString];
            [self.contactImageView sd_setImageWithURL:iconURL];
        }
    }
    self.contactNameLabel.text = viewData.title;
    [self configureValueLabel:viewData];
}

- (void)configureValueLabel:(NGOContactViewModel *)viewData
{
    NSMutableAttributedString *mAttributedDescription = [[NSString attributedStringFromHTML:viewData.textValue] mutableCopy];
    [mAttributedDescription addAttribute:NSFontAttributeName value:[UIFont regularFontOfSize:16.0] range:NSMakeRange(0, mAttributedDescription.length)];
    self.contactValueLabel.attributedText = mAttributedDescription;
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
