//
//  ChooseOptionsHeaderView.m
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 4/15/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "ChooseOptionsHeaderView.h"

@interface ChooseOptionsHeaderView()



@end

@implementation ChooseOptionsHeaderView

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ChooseOptionsHeaderView" owner:self options:nil] objectAtIndex:0];
    if (self) {
//        [ViewColorsDataController configureGameTableViewControllerHeaderColors:self];
        
        
    }
    return self;
}

- (IBAction)buttonAction:(UIButton *)sender
{
    [super buttonAction:sender];
}

- (void)setIsClose:(BOOL)isClose
{
    [super setIsClose:isClose];
    self.lineBottomSpace.constant = isClose?0:-1;
    
    if(self.index == self.sectionCount-1) {
        self.lineBottomSpace.constant = isClose?0:-1;
    }
}

- (void)setIsExtend:(BOOL)isExtend
{
    [super setIsExtend:isExtend];
    CGFloat degree;
    if(isExtend) {
        degree = 0;
    } else {
        degree = 180;
    }
    _extendImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree));
}

@end
