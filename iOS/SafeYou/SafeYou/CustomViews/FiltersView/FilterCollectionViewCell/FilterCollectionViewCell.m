//
//  FilterCollectionViewCell.m
//  SafeYou
//
//  Created by MacBook Pro on 01.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#import "FilterViewModel.h"
#import "UIColor+SYColors.h"

@interface FilterCollectionViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableView *containerView;
@property (weak, nonatomic) IBOutlet SYLabelRegular *titleLabel;

@end

@implementation FilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureWithViewModel:(FilterViewModel*)viewModel
{
    _viewModel = viewModel;
    self.titleLabel.text = self.viewModel.name;
    [self updateSelectionUI];
}

- (void)selectCell:(BOOL)select
{
    self.viewModel.isSelected = select;
    [self updateSelectionUI];
}

- (void)updateSelectionUI
{
    if (self.viewModel.isSelected) {
        self.containerView.backgroundColor = [UIColor mainTintColor2];
    } else {
        self.containerView.backgroundColor = [UIColor mainTintColor6];
    }
}

@end
