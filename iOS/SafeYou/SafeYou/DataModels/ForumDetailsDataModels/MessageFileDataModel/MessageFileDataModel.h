//
//  MessageFileDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageFileDataModel : BaseDataModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *mimetype;
@property (nonatomic) NSString *md5;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *audioDuration;
@property (nonatomic) NSInteger messageId;
@property (nonatomic) NSInteger roomId;
@property (nonatomic) NSInteger type;
@property (nonatomic) double fileId;
@property (nonatomic) double size;

- (NSURL *)mediaPath;
- (int)audioDurationSeconds;

@end

NS_ASSUME_NONNULL_END
