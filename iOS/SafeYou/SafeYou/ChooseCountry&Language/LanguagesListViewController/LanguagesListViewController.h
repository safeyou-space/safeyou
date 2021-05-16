//
//  RegionalOptionsListViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 5/5/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class ChooseRegionalOptionViewModel, LanguagesListViewController, LanguageDataModel, ChooseLanguageViewModel;

@protocol LanguagesListViewDelegate <NSObject>

- (void)languagesOptionView:(LanguagesListViewController *_Nonnull)regionalOptionsView didSelectedOption:(LanguageDataModel *_Nonnull)selectedRegionalOption;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LanguagesListViewController : SYViewController

@property (nonatomic) NSArray <ChooseLanguageViewModel *>*dataSource;
@property (nonatomic, weak) id <LanguagesListViewDelegate> delegate;
@property (nonatomic) BOOL isFromChooseCountry;
@property (nonatomic) CountryDataModel *currentSelectedCountry;

@end

NS_ASSUME_NONNULL_END
