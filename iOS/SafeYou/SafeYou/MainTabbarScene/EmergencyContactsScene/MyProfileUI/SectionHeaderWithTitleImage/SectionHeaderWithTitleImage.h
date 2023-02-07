//
//  SectionHeaderWithTitleImage.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/13/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionHeaderWithTitleImage : UITableViewHeaderFooterView

- (void)configureWithImage:(NSString *)imageName title:(NSString *)title hideTopLine:(BOOL)hideTopLine;

@end

NS_ASSUME_NONNULL_END
