//
//  RegionalOptionsService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

@class CountryDataModel, LanguageDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface RegionalOptionsService : SYServiceAPI

- (void)getCountryListWithComplition:(void(^)(NSArray <CountryDataModel *> *counrtyList))complition failure:(void(^)(NSError *error))failure;

- (void)getLanguagesListWithComplition:(void(^)(NSArray <LanguageDataModel *> *languagesList))complition failure:(void(^)(NSError *error))failure;

- (void)getLanguagesListForCountry:(NSString *)countryCode withComplition:(void(^)(NSArray <LanguageDataModel *> *languagesList))complition failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
