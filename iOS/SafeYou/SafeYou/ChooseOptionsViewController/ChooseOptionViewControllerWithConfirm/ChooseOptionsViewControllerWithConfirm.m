//
//  ChooseOptionsViewControllerWithConfirm.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/27/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ChooseOptionsViewControllerWithConfirm.h"
#import "ChooseOptionsTableViewCell.h"
#import "ChooseOptionsHeaderView.h"
#import "ChooseOptionCustomInputCell.h"
#import "MainTabbarController.h"

@interface ChooseOptionsViewControllerWithConfirm () <ChooseOptionCustomInputCellDelegate>

@property (nonatomic, strong) UIFont *cellFont;

@property (weak, nonatomic) IBOutlet SYDesignableButton *saveButton;
@property (weak, nonatomic) IBOutlet SYDesignableButton *cancelButton;

@property (nonatomic) BOOL isCustomOptionSelected;
@property (nonatomic) NSString *customOptionValue;

- (IBAction)cancelButtonPressed:(SYDesignableButton *)sender;
- (IBAction)saveButtonPressed:(SYDesignableButton *)sender;

@end

@implementation ChooseOptionsViewControllerWithConfirm

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.chooseOptionType = SYChooseOptionTypeRadio;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cellFont = [UIFont systemFontOfSize:16];
    if(self.showSearchBar) {
        [self.optionsTableView setContentOffset:CGPointMake(0,44) animated:YES];
    } else {
        self.optionsTableView.tableHeaderView = nil;
    }
    
    [self enableKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self mainTabbarController] hideTabbar:YES];
    [self updateLocalizations];
    [_optionsTableView reloadData];
    [self configureNavigationBar];
}

#pragma mark - Localizations

- (void)updateLocalizations
{
    [self.saveButton setTitle:LOC(@"save_key") forState:UIControlStateNormal];
    [self.cancelButton setTitle:LOC(@"cancel") forState:UIControlStateNormal];
    self.navigationItem.title = _optionTitle ? _optionTitle : LOC(@"field_of_expertise");
}

#pragma mark - Customization
- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *image = [self imageWithColor:[UIColor mainTintColor1] withPoint:CGSizeMake(1, 1)];
    
//    [[UINavigationBar appearance] setShadowImage:image];
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (UIImage *)imageWithColor:(UIColor *)color withPoint:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isModal]) {
        NSLog(@"is modal");
    } else {
        NSLog(@"isZ modal");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isModal
{
    return NO;
}

- (BOOL)didOpenSection:(NSInteger)section
{
    return NO;
}

#pragma mark - UITableViewDataSource delegate

// section row count.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasCustomInput) {
        return self.optionsArray.count +1;
    }
    return self.optionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDelegate delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ChooseOptionsTableViewCell";
    if (self.hasCustomInput) {
        if (indexPath.row == self.optionsArray.count) {
            ChooseOptionCustomInputCell *customFieldCell = [tableView dequeueReusableCellWithIdentifier:@"ChooseOptionCustomInputCell"];
            customFieldCell.chooseOptionType = self.chooseOptionType;
            customFieldCell.isSelect = self.isCustomOptionSelected;
            customFieldCell.delegate = self;
            [customFieldCell configureWithTitle:self.customInputTitle placeholder:self.customInputPlaceholder];
            return customFieldCell;
        }
    }
    if (self.chooseOptionType == SYChooseOptionTypeRadio) {
        CellIdentifier = @"ChooseOptionsRadioTableViewCellConfirm";
    }
    ChooseOptionsTableViewCell *chooseOptionsTableViewCell = (ChooseOptionsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    chooseOptionsTableViewCell.chooseOptionType = self.chooseOptionType;
    if (chooseOptionsTableViewCell == nil) {
        chooseOptionsTableViewCell = [[ChooseOptionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    chooseOptionsTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *optionName;
    
    optionName = [self.optionsArray objectAtIndex:indexPath.row];
    
    [chooseOptionsTableViewCell configureForOptionName:optionName];
    
    
    if ([optionName isEqualToString:_selectedOptionName]) {
        chooseOptionsTableViewCell.isSelect = YES;
    } else {
        chooseOptionsTableViewCell.isSelect = NO;
    }
    
    return chooseOptionsTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.optionsArray.count) {
        // custom option is selected
        self.selectedOptionName = @"";
        self.isCustomOptionSelected = YES;
    } else {
        self.isCustomOptionSelected = NO;
        NSString *optionName = [self.optionsArray objectAtIndex:indexPath.row];
        self.selectedOptionName = optionName;
    }
    
    [tableView reloadData];
}

#pragma mark - actions
- (IBAction)leftBarButtonPressed:(id)sender
{
    [self closeOptionsView];
}

- (IBAction)rightBarButtonPressed:(id)sender
{
    [self closeOptionsView];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self closeOptionsView];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if (self.isCustomOptionSelected) {
        if (self.customInputSelectionblock) {
            self.customInputSelectionblock(self.customOptionValue);
        }
    } else {
        if (self.selectedOptionName.length && [self.optionsArray containsObject:self.selectedOptionName]) {
            NSInteger selectedIndex = [self.optionsArray indexOfObject:self.selectedOptionName];
            if (self.selectionBlock) {
                self.selectionBlock(selectedIndex);
            }
        }
    }
    [self closeOptionsView];
}

#pragma mark - ChooseOptionCustomInputCellDelegate

- (void)customOptionCell:(ChooseOptionCustomInputCell *)cell didChangeText:(NSString *)text
{
    self.customOptionValue = text;
}


#pragma mark - Close
- (void)closeOptionsView
{
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Factory

+ (ChooseOptionsViewControllerWithConfirm *)instantiateChooseOptionController
{
    UIStoryboard *chooseOptionStoryboard = [UIStoryboard storyboardWithName:@"ChooseOptionsViewController" bundle:nil];
    ChooseOptionsViewControllerWithConfirm *chooseOptionController = [chooseOptionStoryboard instantiateViewControllerWithIdentifier:@"ChooseOptionsViewControllerWithConfirm"];
    return chooseOptionController;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.optionsTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    self.optionsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);;
    weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        strongify(self)
        [self.view layoutSubviews];
    }];
}

@end
