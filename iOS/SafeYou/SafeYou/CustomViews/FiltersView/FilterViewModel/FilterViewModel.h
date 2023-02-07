//
//  FilterViewModel.h
//  SafeYou
//
//  Created by MacBook Pro on 02.11.21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterViewModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSString *modelId;

@end

NS_ASSUME_NONNULL_END
