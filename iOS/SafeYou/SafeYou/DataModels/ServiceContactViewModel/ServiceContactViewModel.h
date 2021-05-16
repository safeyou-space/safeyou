//
//  ServiceContactViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/9/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ServiceActionType) {
    ServiceActionTypeNone,
    ServiceActionTypeOpenURL,
    ServiceActionTypeOpenPhoneURL,
    ServiceActionTypeShareItem
};

@interface ServiceContactViewModel : NSObject

@property (nonatomic) NSString *contactName;
@property (nonatomic) NSString *contactValue;
@property (nonatomic) NSString *iconURL;
@property (nonatomic) ServiceActionType actionType;

@end

NS_ASSUME_NONNULL_END
