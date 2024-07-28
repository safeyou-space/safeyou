//
//  EmergencyContactTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 5/13/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "EmergencyContactTableViewCell.h"
#import "MyProfileSectionViewModel.h"

@interface EmergencyContactTableViewCell ()

@property (weak, nonatomic) IBOutlet SYLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet SYLabelRegular *valueLabel;
@property (weak, nonatomic) IBOutlet SYRegularButtonButton *clearbutton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *editButton;

- (IBAction)clearButtonAction:(UIButton *)sender;
- (IBAction)editButtonAction:(UIButton *)sender;


@end

@implementation EmergencyContactTableViewCell

@synthesize delegate = _delegate;
@synthesize fieldData = _fieldData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithViewModelData:(MyProfileRowViewModel *)viewData
{
    self.fieldData = viewData;
    self.clearbutton.hidden = !viewData.showClearButton;
    self.editButton.hidden = !viewData.showEditButton;
    self.titleLabel.text = viewData.fieldTitle;
    self.valueLabel.text = viewData.fieldValue;
    NSString *editImageName = viewData.showClearButton ? @"edit_button" : @"icon-plus";
    [self.editButton setImage:[[UIImage imageNamed:editImageName] imageWithTintColor:UIColor.mainTintColor1] forState:UIControlStateNormal];
    self.editButton.imageColorType = SYColorTypeMain1;
}

#pragma mark - Actions

- (IBAction)clearButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionCellDidPressClearButton:)]) {
        [self.delegate actionCellDidPressClearButton:self];
    }
}

- (IBAction)editButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionCellDidPressEditButton:)]) {
        [self.delegate actionCellDidPressEditButton:self];
    }
}

@end
