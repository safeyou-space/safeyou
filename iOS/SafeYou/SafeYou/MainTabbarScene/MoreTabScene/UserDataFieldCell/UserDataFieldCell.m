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

@property (nonatomic, weak) IBOutlet SYLabelRegular *fieldNameLabel;
@property (nonatomic, weak) IBOutlet SYLabelRegular *fieldValueLabel;
@property (nonatomic, weak) IBOutlet SYDesignableButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *fieldValueTextField;
@property (weak, nonatomic) IBOutlet UIImageView *reportIconImageView;

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
    _reportIconImageView.hidden = YES;
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
    UIImage *editImage = [[UIImage imageNamed:@"edit_button"] imageWithTintColor:UIColor.mainTintColor1];
    [self.editButton setImage:editImage forState:UIControlStateNormal];
    self.fieldData = viewData;
    self.fieldNameLabel.text = viewData.fieldTitle;
    if (self.fieldValueLabel) {
        if(viewData.fieldValue) {
            self.fieldValueLabel.text = viewData.fieldValue;
            self.fieldValueLabel.textColor = UIColor.blackColor;
        } else {
            self.fieldValueLabel.text = LOC(@"not_specified_text_key");
            self.fieldValueLabel.textColor = UIColor.lightGrayColor;
        }
    }
    if (self.fieldValueTextField) {
        self.fieldValueTextField.text = viewData.fieldValue;
    }
    
    if ([viewData.fieldName isEqualToString:@"userId"]) {
        self.editButton.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        self.editButton.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)becomeFirstResponder
{
    UIImage *checkmarkImage = [[UIImage imageNamed:@"checkmark"] imageWithTintColor:UIColor.mainTintColor1];
    [self.editButton setImage:checkmarkImage forState:UIControlStateNormal];
    [self.fieldValueTextField becomeFirstResponder];
    return [super becomeFirstResponder];
    
}

- (BOOL)isFirstResponder
{
    return self.fieldValueTextField.isFirstResponder;
}

- (BOOL)resignFirstResponder
{
    UIImage *editImage = [[UIImage imageNamed:@"edit_button"] imageWithTintColor:UIColor.mainTintColor1];
    [self.editButton setImage:editImage forState:UIControlStateNormal];
    [self.fieldValueTextField resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)showReportIcon:(BOOL) hidden
{
    _reportIconImageView.hidden = hidden;
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
