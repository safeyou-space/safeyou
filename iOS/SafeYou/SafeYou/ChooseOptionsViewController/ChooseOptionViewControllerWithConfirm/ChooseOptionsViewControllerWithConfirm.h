//
//  ChooseOptionsViewControllerWithConfirm.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/27/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseOptionsViewControllerWithConfirm : SYViewController <UITableViewDelegate, UITableViewDataSource>

+ (ChooseOptionsViewControllerWithConfirm *)instantiateChooseOptionController;

@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;

@property (nonatomic) SYChooseOptionType chooseOptionType;
@property (nonatomic, strong) NSString *optionTitle;
@property (nonatomic, strong) NSString *selectedOptionName;
@property (nonatomic, strong) NSMutableArray *optionsArray;
@property (nonatomic, strong) NSMutableArray *extendableOptionsArray;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

@property (nonatomic) NSUInteger selectedOptionSection;
@property (nonatomic) NSUInteger selectedOptionRow;

@property (nonatomic) BOOL canSelectAll;
@property (nonatomic) BOOL canDeselect;

@property (nonatomic) BOOL showSearchBar;

@property (strong, nonatomic) NSArray <NSString *>  * _Nonnull dataSource;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, copy) void  (^ _Nullable cancelBlock)(void);
@property (nonatomic, copy) void (^ _Nullable selectionBlock)(NSInteger selectedIndex);
@property (nonatomic, copy) void (^ _Nullable multySelectionBlock)(NSArray * _Nullable selectedOptions);
@property (nonatomic, copy) void (^ _Nullable allSelectionBlock)(void);

@property (nonatomic, copy) void (^ _Nullable customInputSelectionblock)(NSString *customSelectedValue);

@property (nonatomic, strong) NSString * _Nullable applyButtonText;

@property (nonatomic) BOOL hasCustomInput;
@property (nonatomic) NSString *customInputTitle;
@property (nonatomic) NSString *customInputPlaceholder;

@end


NS_ASSUME_NONNULL_END
