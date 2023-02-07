//
//  NGOContactViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/9/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NGOActionType) {
    NGOActionTypeNone,
    NGOActionTypeOpenURL,
    NGOActionTypeOpenPhoneURL,
    NGOActionTypeShareItem,
    NGOActionTypeSendEmail,
};

@interface NGOContactViewModel : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *textValue;
@property (nonatomic) NSString *iconURL;
@property (nonatomic) UIImage *icon;
@property (nonatomic) NGOActionType actionType;

@end

NS_ASSUME_NONNULL_END
