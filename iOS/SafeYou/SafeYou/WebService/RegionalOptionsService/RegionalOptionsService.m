//
//  RegionalOptionsService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/25/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "RegionalOptionsService.h"
#import "RegionalOptionDataModel.h"

@implementation RegionalOptionsService

- (void)getCountryListWithComplition:(void(^)(NSArray <CountryDataModel *> *counrtyList))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:@"countries" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *countryDataDict in responseObject) {
            CountryDataModel *countryData = [CountryDataModel modelObjectWithDictionary:countryDataDict];
            [tempArray addObject:countryData];
        }
        if (complition) {
            complition([tempArray copy]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getLanguagesListWithComplition:(void(^)(NSArray <LanguageDataModel *> *languagesList))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:@"languages" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *languageDataDict in responseObject) {
            LanguageDataModel *languageData = [LanguageDataModel modelObjectWithDictionary:languageDataDict];
            [tempArray addObject:languageData];
        }
//#if DEBUG
//        [tempArray addObject:[self kurdishSoraniLanguageData]];
//        [tempArray addObject:[self kartuliLanguageData]];
//#endif

        if (complition) {
            complition([tempArray copy]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getLanguagesListForCountry:(NSString *)countryCode withComplition:(void(^)(NSArray <LanguageDataModel *> *languagesList))complition failure:(void(^)(NSError *error))failure
{
    NSString *baseUrl = [[Settings sharedInstance] baseApiUrlByCountryCode:countryCode];
    NSString *urlWithCountryCode = [NSString stringWithFormat:baseUrl, countryCode, [Settings sharedInstance].selectedLanguageCode];
    [[self networkManagerWithUrl:urlWithCountryCode] GET:@"languages" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *languageDataDict in responseObject) {
            LanguageDataModel *languageData = [LanguageDataModel modelObjectWithDictionary:languageDataDict];
            [tempArray addObject:languageData];
        }
        if (complition) {
            complition([tempArray copy]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// For Testing
- (LanguageDataModel *)arabicLanguageData
{
    LanguageDataModel *arabic = [[LanguageDataModel alloc] init];
    arabic.name = @"Arabic";
    arabic.apiServiceCode = @"ar";
    return arabic;
}

- (LanguageDataModel *)kurdishSoraniLanguageData
{
    LanguageDataModel *arabic = [[LanguageDataModel alloc] init];
    arabic.name = @"Sorani";
    arabic.apiServiceCode = @"ckb";
    return arabic;
}

- (LanguageDataModel *)kartuliLanguageData
{
    LanguageDataModel *arabic = [[LanguageDataModel alloc] init];
    arabic.name = @"Kartuli";
    arabic.apiServiceCode = @"ka";
    return arabic;
}

@end
