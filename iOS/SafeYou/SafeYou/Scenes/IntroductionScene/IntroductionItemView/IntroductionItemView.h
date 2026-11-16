//
//  IntroductionItemView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/21/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntroductionItemView, IntroductionItemViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol IntroductionItemViewDelegate <NSObject>

- (void)itemViewDidSelect:(IntroductionItemView *)itemView;

@end

@interface IntroductionItemView : SYDesignableView

@property (weak, nonatomic) IBOutlet id <IntroductionItemViewDelegate> delegate;

- (void)configureWithViewModel:(IntroductionItemViewModel *)viewModel;

@end

@interface IntroductionItemViewModel : NSObject

@property (nonatomic) NSString *localizedTitle;
@property (nonatomic) NSString *titleLocalizationKey;
@property (nonatomic) NSString *imageName;

- (instancetype)initWithLocalizationKey:(NSString *)localizationKey imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
