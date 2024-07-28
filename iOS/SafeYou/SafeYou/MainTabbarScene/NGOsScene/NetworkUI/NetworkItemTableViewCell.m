//
//  NetworkItemTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NetworkItemTableViewCell.h"
#import "EmergencyServiceDataModel.h"
#import "ImageDataModel.h"
#import <SDWebImage.h>
#import "NSString+HTML.h"

@interface NetworkItemTableViewCell ()


//@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *serviceAddressLabel;
//@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
//@property (weak, nonatomic) IBOutlet UIButton *mailButton;

@property (weak, nonatomic) IBOutlet SYDesignableImageView *logoImageView;
@property (weak, nonatomic) IBOutlet SYLabelBold *serviceNameLabel;
@property (weak, nonatomic) IBOutlet SYLabelLight *addressLabel;
@property (weak, nonatomic) IBOutlet SYLabelLight *address2Label;
@property (weak, nonatomic) IBOutlet SYLabelRegular *emailLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *infoLabel;
@property (weak, nonatomic) IBOutlet SYDesignableButton *chatButton;

@property (weak, nonatomic) IBOutlet UIView *emailContainerView;
@property (weak, nonatomic) IBOutlet UIView *phoneContainerView;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;

- (IBAction)chatButtonAction:(UIButton *)sender;

- (IBAction)mailButtonAction:(UIButton *)sender;
- (IBAction)phoneButtonAction:(UIButton *)sender;

@end

@implementation NetworkItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.serviceNameLabel.text = @"";
    self.addressLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure With Data

- (void)configureWithEmergencyServiceData:(EmergencyServiceDataModel *)serviceData
{
    NSURL *imageUrl = [serviceData.image imageFullURL];
    [self.logoImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"ngo_logo"]];
    self.serviceNameLabel.text = serviceData.name;
    self.addressLabel.text = serviceData.serviceAddress;
    self.address2Label.text = serviceData.city;
    self.emailLabel.text = serviceData.email;
    self.phoneNumberLabel.text = serviceData.phoneNumber;
    self.chatButton.hidden = self.hideChatButton;
    self.chatButton.imageColorType = 1;
    self.infoLabel.attributedText = serviceData.attributedInfoText;

}

- (void)configureWithSearchSuggestion:(NSString *)suggestion
{
    self.addressLabel.text = @"";
    self.serviceNameLabel.text = suggestion;
}

#pragma mark - ViewModel helper

- (NSString *)addressStringFromSerivceData:(EmergencyServiceDataModel *)serviceData
{
    // @TODO: Garnik Clarify which data to show
    return serviceData.webAddress;
}

#pragma mark - Actions

- (IBAction)mailButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(networkItemCellDidPressMailButton:)]) {
        [self.delegate networkItemCellDidPressMailButton:self];
    }
}

- (IBAction)phoneButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(networkItemCellDidPressPhoneButton:)]) {
        [self.delegate networkItemCellDidPressPhoneButton:self];
    }
}

- (IBAction)chatButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(networkItemCellDidPressPrivateChat:)]) {
        [self.delegate networkItemCellDidPressPrivateChat:self];
    }
}

@end
