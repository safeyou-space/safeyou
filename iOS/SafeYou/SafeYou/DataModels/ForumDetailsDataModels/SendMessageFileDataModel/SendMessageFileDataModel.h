//
//  SendMessageFileDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 3/26/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageFileDataModel : BaseDataModel

@property (nonatomic) NSMutableDictionary *messageParameters;
@property (nonatomic) NSMutableDictionary *messageFormDataParameters;
@property (nonatomic) MessageFileType fileType;

- (instancetype)initWithMessage:(nullable NSString *)message
                          image:(nullable UIImage *)image
             audioFileDirectory:(nullable NSURL *)audioFileDirectory
                      commentId:(nullable NSNumber *)commentId;

@end

NS_ASSUME_NONNULL_END
