//
//  ForumFiltersViewController.h
//  SafeYou
//
//  Created by MacBook Pro on 31.10.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

@class ForumFiltersViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ForumFiltersViewControllerDelegate <NSObject>

- (void)didForumFilter:(ForumFiltersViewController *_Nonnull)filterOptions withLanguage:(NSString *)language andCategories:(NSArray<NSString *>*)categories;

@end

@interface ForumFiltersViewController : SYViewController

@property (nonatomic, weak) id <ForumFiltersViewControllerDelegate> delegate;
@property (nonatomic) NSString *selectedLanguage;
@property (nonatomic) NSArray<NSString *> *selectedCategories;

@end

NS_ASSUME_NONNULL_END
