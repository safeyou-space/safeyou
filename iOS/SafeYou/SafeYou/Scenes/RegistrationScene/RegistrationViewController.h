//
//  RegistrationViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 8/28/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYViewController.h"
@class RegistrationDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationViewController : SYViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RegistrationDataModel *registrationData;
@property (nonatomic, readonly, getter=formTableView) UITableView *formTableView;

@property (weak, nonatomic) IBOutlet SYLabelBold *mainTitleLabel;
@property (weak, nonatomic) IBOutlet SYLabelBold *secondaryTitleLabel;

- (void)submitForm;
- (void)showFormErrorAlert:(nullable NSString *)message;
- (void)reloadDataSource;
- (id)fieldForIndexpath:(NSIndexPath *)indexPath;

- (NSString *)saveButtonTitle;
- (NSString *)cancelButtonTitle;


@property (nonatomic) NSArray *dataSource;
@property (nonatomic) BOOL editingDisabled;

@end

NS_ASSUME_NONNULL_END
