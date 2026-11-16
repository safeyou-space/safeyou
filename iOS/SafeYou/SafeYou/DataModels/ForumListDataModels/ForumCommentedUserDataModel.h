//
//  ForumCommentedUserDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"



@interface ForumCommentedUserDataModel : BaseDataModel

@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *nickname;



@end
