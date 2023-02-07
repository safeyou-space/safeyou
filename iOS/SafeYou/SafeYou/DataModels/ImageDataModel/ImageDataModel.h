//
//  ImageDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

@interface ImageDataModel : BaseDataModel

@property (nonatomic, strong) NSNumber *imageId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger type;

@end

@interface ImageDataModel (ImageURL)

- (NSURL *)imageFullURL;

@end
