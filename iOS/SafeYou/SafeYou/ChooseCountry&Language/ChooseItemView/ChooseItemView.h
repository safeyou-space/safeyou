//
//  ChooseItemView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYDesignableView.h"
#import "ChooseItemViewDelegate.h"

@class ChooseItemView, ChooseRegionalOptionViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChooseItemView : SYDesignableView

@property (nonatomic, readonly) ChooseRegionalOptionViewModel *viewData;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title withoutImage:(BOOL)withoutImage;

- (instancetype)initWithViewData:(ChooseRegionalOptionViewModel *)viewData;

@property (nonatomic) BOOL selected;
@property (nonatomic, weak) id <ChooseItemViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
