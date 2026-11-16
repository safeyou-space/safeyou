//
//  ReviewDataModel.h
//  SafeYou
//
//  Created by Edgar on 14.02.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@interface ReviewDataModel : BaseDataModel

@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, strong) NSString *comment;

@end
