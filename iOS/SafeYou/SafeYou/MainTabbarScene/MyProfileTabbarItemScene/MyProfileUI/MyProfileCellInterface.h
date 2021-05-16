//
//  MyProfileCellInterface.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyProfileRowViewModel, UserDataFieldCell;
@protocol TableViewCellActionDelegate;


NS_ASSUME_NONNULL_BEGIN

@protocol MyProfileCellInterface <NSObject>

@optional

- (void)configureCellWithTitle:(NSString *)title;
- (void)configureCellWithViewModelData:(id)viewData;
- (BOOL)becomeFirstResponder;

@property (nonatomic, weak) id delegate;
@property (nonatomic) id fieldData;

@end

@protocol TableViewCellActionDelegate <NSObject>

- (void)actionCellDidPressEditButton:(id<MyProfileCellInterface>)cell;
- (void)actionCellDidPressSaveButton:(id<MyProfileCellInterface>)cell withValue:(NSString *_Nullable)value;
- (void)actionCellDidPressClearButton:(id<MyProfileCellInterface>)cell;

@end

NS_ASSUME_NONNULL_END
