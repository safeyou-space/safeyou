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

@property (weak, nonatomic) IBOutlet HyRobotoLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet HyRobotoLabelRegular *valueLabel;
@property (weak, nonatomic) IBOutlet HyRobotoButton *clearbutton;
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
    [self.clearbutton setTitle:LOC(@"clear_tex_key") forState:UIControlStateNormal];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.clearbutton setTitle:LOC(@"clear_tex_key") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithViewModelData:(MyProfileRowViewModel *)viewData
{
    self.fieldData = viewData;
    self.clearbutton.hidden = !viewData.showClearButton;
    self.titleLabel.text = viewData.fieldTitle;
    self.valueLabel.text = viewData.fieldValue;
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
