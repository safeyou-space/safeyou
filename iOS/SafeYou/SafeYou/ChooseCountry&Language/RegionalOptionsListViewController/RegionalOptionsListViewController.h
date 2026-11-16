//
//  RegionalOptionsListViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class ChooseRegionalOptionViewModel, RegionalOptionsListViewController, RegionalOptionDataModel;

@protocol RegionalOptionsListViewDelegate <NSObject>

- (void)regionalOptionView:(RegionalOptionsListViewController *_Nonnull)regionalOptionsView didSelectedOption:(RegionalOptionDataModel *_Nonnull)selectedRegionalOption;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RegionalOptionsListViewController : SYViewController

@property (nonatomic) NSArray <ChooseRegionalOptionViewModel *>*dataSource;
@property (nonatomic, weak) id <RegionalOptionsListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
