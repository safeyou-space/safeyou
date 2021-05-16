//
//  ReEnterPinViewController.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/19/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DialogViewType) {
    DialogViewTypeButtonAction,
    DialogViewTypeCreatePin,
    DialogViewTypeEditPin
};

#import "SYViewController.h"

@class DialogViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol DialogViewDelegate <NSObject>

@optional
- (void)dialogViewDidPressActionButton:(DialogViewController *)dialogView;
- (void)dialogViewDidEnterCorrectPin:(DialogViewController *)enterPincodeView;
- (void)dialogViewDidCancel:(DialogViewController *)dialogView;

@end

@interface DialogViewController : SYViewController

// factory
+ (instancetype)instansiateDialogViewWithType:(DialogViewType)type;
+ (instancetype)instansiateDialogViewWithType:(DialogViewType)type title:(NSString *)title message:(NSString *)message;

@property (nonatomic) DialogViewType actionType;
@property (nonatomic) NSString *correctValue;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic, weak) id <DialogViewDelegate> delegate;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *titleText;
@property (nonatomic) BOOL showCancelButton;

@end

NS_ASSUME_NONNULL_END
