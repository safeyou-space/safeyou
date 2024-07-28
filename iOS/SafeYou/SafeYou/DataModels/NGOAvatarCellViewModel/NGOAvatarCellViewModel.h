//
//  NGOAvatarCellViewModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/6/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NGOAvatarCellViewModel : NSObject

@property (nonatomic) NSURL *logoURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger rating;

@end

NS_ASSUME_NONNULL_END
