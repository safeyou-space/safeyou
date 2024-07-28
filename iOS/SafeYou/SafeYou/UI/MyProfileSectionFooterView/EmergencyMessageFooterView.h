//
//  EmergencyMessageFooterView.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  EmergencyMessageViewDelegate <NSObject>

- (void)emergencyMessageDidUpdate:(NSString *)updatedMessage;

@end

@interface EmergencyMessageFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet SYLabelRegular *footerTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *emergencyTextView;

@property (weak, nonatomic) id <EmergencyMessageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
