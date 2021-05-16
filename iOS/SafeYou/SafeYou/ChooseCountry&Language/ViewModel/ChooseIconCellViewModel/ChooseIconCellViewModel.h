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

@interface ChooseIconCellViewModel : NSObject

@property (nonatomic) BOOL isSelected;
@property (nonatomic, readonly) NSString *optionTitle;
@property (nonatomic, readonly) NSString  * iconImageName;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
