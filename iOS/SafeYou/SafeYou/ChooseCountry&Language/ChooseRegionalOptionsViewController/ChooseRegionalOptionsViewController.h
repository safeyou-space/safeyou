//
//  ChooseRegionalOptionsViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"
#import "ChooseItemViewDelegate.h"

@class ChooseRegionalOptionViewModel, RegionalOptionsService, RegionalOptionDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChooseRegionalOptionsViewController : SYViewController <ChooseItemViewDelegate>

@property (nonatomic) BOOL showFlags;
@property (nonatomic) NSArray <ChooseRegionalOptionViewModel *>*dataSource;
@property (nonatomic, readonly) RegionalOptionsService *optionsService;
@property (nonatomic) RegionalOptionDataModel * _Nullable selectedRegionalOption;

@property (nonatomic, readonly) SYDesignableBarButtonItem *rightBarButtonItem;

// Interface
- (void)fetchOptions;
- (void)showNextView;
- (void)enableNextButton:(BOOL)enable;

// Texts

@property (nonatomic) NSString *mainTitle;
@property (nonatomic) NSString *secondaryTitle;
@property (nonatomic) NSString *rightBarButtonTitle;
@property (nonatomic) NSString *submitButtonTitle;

@end

NS_ASSUME_NONNULL_END
