//
//  RegionalOptionsListViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class ChooseRegionalOptionViewModel, CountryListViewController, RegionalOptionDataModel;

@protocol CountryListViewDelegate <NSObject>

- (void)countryOptionsView:(CountryListViewController *_Nonnull)regionalOptionsView didSelectedOption:(CountryDataModel *_Nonnull)selectedCountryData;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CountryListViewController : SYViewController

@property (nonatomic, weak) id <CountryListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
