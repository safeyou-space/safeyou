//
//  NetworkItemTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/11/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "NetworkItemTableViewCell.h"
#import "EmergencyServiceDataModel.h"

@interface NetworkItemTableViewCell ()

@property (weak, nonatomic) IBOutlet HyRobotoLabelBold *serviceNameLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *serviceAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;

- (IBAction)phoneButtonAction:(UIButton *)sender;
- (IBAction)mailButtonAction:(UIButton *)sender;



@end

@implementation NetworkItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.phoneButton.hidden = NO;
    self.mailButton.hidden = NO;
    self.serviceNameLabel.text = @"";
    self.serviceAddressLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure With Data

- (void)configureWithEmergencyServiceData:(EmergencyServiceDataModel *)serviceData
{
    self.phoneButton.hidden = NO;
    self.mailButton.hidden = NO;
    self.serviceNameLabel.text = serviceData.userDetails.firstName;
    self.serviceAddressLabel.text = serviceData.userDetails.location;
}

- (void)configureWithSearchSuggestion:(NSString *)suggestion
{
    self.phoneButton.hidden = YES;
    self.mailButton.hidden = YES;
    self.serviceAddressLabel.text = @"";
    self.serviceNameLabel.text = suggestion;
}

#pragma mark - ViewModel helper

- (NSString *)addressStringFromSerivceData:(EmergencyServiceDataModel *)serviceData
{
    // @TODO: Garnik Clarify which data to show
    return serviceData.webAddress;
}

#pragma mark - Actions

- (IBAction)phoneButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(networkItemCellDidPressPhoneButton:)]) {
        [self.delegate networkItemCellDidPressPhoneButton:self];
    }
}

- (IBAction)mailButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(networkItemCellDidPressMailButton:)]) {
        [self.delegate networkItemCellDidPressMailButton:self];
    }
}

@end
