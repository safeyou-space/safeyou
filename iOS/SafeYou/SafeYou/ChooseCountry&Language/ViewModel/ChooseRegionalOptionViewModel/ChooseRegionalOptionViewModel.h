//
//  ChooseRegionalOptionViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RegionalOptionDataModel;


NS_ASSUME_NONNULL_BEGIN

@interface ChooseRegionalOptionViewModel : NSObject

@property (nonatomic) BOOL isSelected;
@property (nonatomic, readonly) NSString *optionTitle;
@property (nonatomic, readonly) NSURL  * _Nullable optionImageUrl;

- (instancetype)initWithData:(RegionalOptionDataModel *)regionalOptionData;

@property (nonatomic, readonly) RegionalOptionDataModel *regionalOptionData;

@end

@interface ChooseCountryViewModel : ChooseRegionalOptionViewModel

@end

@interface ChooseLanguageViewModel : ChooseRegionalOptionViewModel

@end

NS_ASSUME_NONNULL_END
