//
//  RecordsListDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
#import "RecordListItemDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordsListDataModel : BaseDataModel

@property (nonatomic) NSArray <RecordListItemDataModel *>*records;




@end

NS_ASSUME_NONNULL_END
