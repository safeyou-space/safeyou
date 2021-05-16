//
//  ContentService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/22/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentService : SYServiceAPI

- (void)getContent:(SYRemotContentType)contentType complition:(void(^)(NSString *htmlContent))complition failure:(void(^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
