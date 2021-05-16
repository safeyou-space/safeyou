//
//  BaseExtendableTableHeaderCell.h
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 4/15/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BaseExtendableTableHeaderCellDelegate <NSObject>

- (void)didSelectAtSectionAtIndex:(NSInteger)index;

@end

@interface BaseExtendableTableHeaderCell : UIView

@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) NSInteger sectionCount;
@property(nonatomic, assign) BOOL isClose;
@property(nonatomic, assign) BOOL isExtend;

@property(weak, nonatomic) id<BaseExtendableTableHeaderCellDelegate> delegate;

- (IBAction)buttonAction:(UIButton *)sender;

@end
