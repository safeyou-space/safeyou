//
//  UserDataFieldCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/16/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "UserDataFieldCell.h"
#import "ProfileViewFieldViewModel.h"

@interface UserDataFieldCell ()

@property (nonatomic, weak) IBOutlet HyRobotoLabelRegular *fieldNameLabel;
@property (nonatomic, weak) IBOutlet HyRobotoLabelRegular *fieldValueLabel;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *fieldValueTextField;

- (IBAction)editButtonPressed:(UIButton *)sender;

@property (nonatomic) BOOL valueChanged;



@end

@implementation UserDataFieldCell

@synthesize fieldData = _fieldData;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fieldValueTextField.tintColor = [UIColor mainTintColor2];
    [self.fieldValueTextField addTarget:self action:@selector(textFieldDidChnage:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChnage:(UITextField *)textField
{
    self.fieldData.fieldValue = textField.text;
}

- (ProfileViewFieldViewModel *)fieldData
{
    return _fieldData;
}

- (void)configureCellWithViewModelData:(ProfileViewFieldViewModel *)viewData
{
    [self.editButton setImage:[UIImage imageNamed:@"edit_button"] forState:UIControlStateNormal];
    self.fieldData = viewData;
    self.fieldNameLabel.text = viewData.fieldTitle;
    if (self.fieldValueLabel) {
        self.fieldValueLabel.text = viewData.fieldValue;
    }
    if (self.fieldValueTextField) {
        self.fieldValueTextField.text = viewData.fieldValue;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)becomeFirstResponder
{
//    [self.editButton setTitle:LOC(@"save_key") forState:UIControlStateNormal];
    [self.editButton setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
    [self.fieldValueTextField becomeFirstResponder];
    return [super becomeFirstResponder];
    
}

- (BOOL)isFirstResponder
{
    return self.fieldValueTextField.isFirstResponder;
}

- (BOOL)resignFirstResponder
{
//    [self.editButton setTitle:LOC(@"edit_key") forState:UIControlStateNormal];
    [self.editButton setImage:[UIImage imageNamed:@"edit_button"] forState:UIControlStateNormal];
    [self.fieldValueTextField resignFirstResponder];
    return [super resignFirstResponder];
}



- (IBAction)editButtonPressed:(UIButton *)sender {
    if (self.isFirstResponder) {
        if ([self.delegate respondsToSelector:@selector(actionCellDidPressSaveButton:withValue:)]) {
            [self.delegate actionCellDidPressSaveButton:self withValue:self.fieldValueTextField.text];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(actionCellDidPressEditButton:)]) {
            [self.delegate actionCellDidPressEditButton:self];
        }
    }
}
@end
