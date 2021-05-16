//
//  BasetableViewCellWithCheckMark.h
//  Fantasy
//
//  Created by Gevorg Karapetyan on 8/4/15.
//  Copyright (c) 2015 BetConstruct. All rights reserved.
//

#import <UIKit/UITableViewCell.h>

@interface BaseTableViewCellWithCheckMark : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkDeactiveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkActiveImageView;


@property (nonatomic) BOOL isSelect;
@property (nonatomic) BOOL isMultiSelect;

@end
