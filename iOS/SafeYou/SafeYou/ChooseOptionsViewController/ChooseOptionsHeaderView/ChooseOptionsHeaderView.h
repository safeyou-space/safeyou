//
//  ChooseOptionsHeaderView.h
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 4/15/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "BaseExtendableTableHeaderCell.h"

@interface ChooseOptionsHeaderView : BaseExtendableTableHeaderCell

@property(weak, nonatomic) IBOutlet UILabel* textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lineBottomSpace;
@property (weak, nonatomic) IBOutlet UIImageView* extendImageView;

@end
