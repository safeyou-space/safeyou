//
//  ReportCategoryTableViewCell.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/24/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "ReportCategoryTableViewCell.h"
#import "ReportCategoryDataModel.h"

@interface ReportCategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet SYDesignableLabel *nameLabel;

@end

@implementation ReportCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithViewData:(ReportCategoryDataModel *)viewData {
    self.nameLabel.text = viewData.name;
}

@end
