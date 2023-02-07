//
//  CountryDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
@class ImageDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface RegionalOptionDataModel : BaseDataModel <NSCoding, NSCopying>

@property (nonatomic) NSNumber * _Nullable itemId;
@property (nonatomic) NSString * _Nullable name;
@property (nonatomic) NSString * _Nullable apiServiceCode;
@property (nonatomic) NSString * _Nullable localizationShortCode;
@property (nonatomic) NSNumber * _Nullable imageId;
@property (nonatomic) ImageDataModel * _Nullable imageData;

/**
 {
     "id": 1,
     "name": "Armenia",
     "short_code": "arm",
     "image_id": 8,
     "status": 1,
     "created_at": "2020-03-30 23:10:30",
     "updated_at": null,
     "image": ImageDataModel
 }
 */

@end

@interface CountryDataModel : RegionalOptionDataModel

@end

@interface LanguageDataModel : RegionalOptionDataModel

+ (NSString *)localizationCodeForApiCode:(NSString *)apiCode;

@end

NS_ASSUME_NONNULL_END
