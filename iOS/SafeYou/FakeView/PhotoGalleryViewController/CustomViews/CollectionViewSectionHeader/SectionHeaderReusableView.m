//
//  SectionHeaderReusableView.m
//  SafeYou
//
//  Created by Garnik Simonyan on 10/30/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SectionHeaderReusableView.h"

@interface SectionHeaderReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SectionHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

@end
