//
//  ChooseOptionsViewController.h
//  Sportsbook
//
//  Created by Gevorg Karapetyan on 1/25/16.
//  Copyright © 2016 BetConstruct. All rights reserved.
//

#import "SYViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SYChooseOptionControllerPresentationStyle) {
    SYChooseOptionControllerPresentationStylePopover,
    SYChooseOptionControllerPresentationStylePush,
};

@protocol ChooseOptionsViewDelegate <NSObject>

@optional

- (void)optionDidSelect:(NSString * _Nonnull )selectedOption withRow:(NSUInteger)selectedOptionRow;
- (void)optionDidSelect:(NSString* _Nonnull)selectedOption inSection:(NSUInteger)selectedOptionSection withRow:(NSUInteger)selectedOptionRow;
- (void)optionsDidSelect:(NSArray* _Nonnull)selectedOptionsArray;
- (void)didSelectAllOptions;
- (void)didDeselect;

@end

@interface ChooseOptionsViewController : SYViewController <UITableViewDelegate, UITableViewDataSource>

+ (ChooseOptionsViewController *)instantiateChooseOptionController;

@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (nonatomic) SYChooseOptionType chooseOptionType;
@property (nonatomic, strong) NSString *optionTitle;
@property (nonatomic, strong) NSString *selectedOptionName;
@property (nonatomic, strong) NSMutableArray *optionsArray;
@property (nonatomic, strong) NSMutableArray *extendableOptionsArray;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

@property (nonatomic) NSUInteger selectedOptionSection;
@property (nonatomic) NSUInteger selectedOptionRow;

//@property (nonatomic) BOOL isMultiSelect;
@property (nonatomic) BOOL canSelectAll;
//@property (nonatomic) BOOL isExtendable;
@property (nonatomic) BOOL canDeselect;

@property (nonatomic) BOOL showSearchBar;

//simonyan
//@property (nonatomic) BOOL isRegistration;
@property (strong, nonatomic) NSArray <NSString *>  * _Nonnull dataSource;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, copy) void  (^ _Nullable cancelBlock)(void);
@property (nonatomic, copy) void (^ _Nullable selectionBlock)(NSInteger selectedIndex);
@property (nonatomic, copy) void (^ _Nullable multySelectionBlock)(NSArray * _Nullable selectedOptions);
@property (nonatomic, copy) void (^ _Nullable allSelectionBlock)(void);

@property (nonatomic, strong) NSString * _Nullable applyButtonText;

@property (nonatomic, weak) id  <ChooseOptionsViewDelegate> delegate;

@end


NS_ASSUME_NONNULL_END
