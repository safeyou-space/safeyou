//
//  MessageOptionsView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/27/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageOptionButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageOptionsViewDelegate <NSObject>

- (void)messageOptionsDidSelectButton:(MessageOptionButton *)button;

@end

@interface MessageOptionsView : SYDesignableView

@property (weak, nonatomic) id<MessageOptionsViewDelegate> delegate;

- (instancetype)initWithButtonsArray:(NSArray<MessageOptionButton *> *)buttonsArray;

@end

NS_ASSUME_NONNULL_END
