//
//  SYForumService.m
//  SafeYou
//
//  Created by Garnik Simonyan on 11/2/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYForumService.h"
#import "ForumItemDataModel.h"
#import "ForumCommentedUserDataModel.h"
#import "ForumCategoryDataModel.h"
#import "ForumItemListDataModel.h"
#import "ReportCategoryListDataModel.h"

@implementation SYForumService

- (void)getForumCategoriesWithComplition:(void(^)(NSArray * categoriesList))complition failure:(void(^)(NSError *error))failure
{
    NSString *endPoint = [NSString stringWithFormat:@"forum/categories?_lang=%@", [Settings sharedInstance].selectedLanguageCode];
    [self.networkManager GET:endPoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *categoriesList = [ForumCategoryDataModel catgoriesFromDictionary:responseObject];
        if (complition) {
            complition(categoriesList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getForumsForLanguage:(NSString *)languageCode categories:(NSArray <NSString *> *)categoriesIds page:(NSInteger)page withComplition:(void(^)(NSArray <ForumItemDataModel *>*forumItems, NSInteger lastPage))complition failure:(void(^)(NSError *error))failure
{
    //forums?_lang=en&_cat={"0":"6", "1":"5"}
    NSString *endPoint = [NSString stringWithFormat:@"forums?_lang=%@&page=%ld", languageCode, (long)page];
    if (categoriesIds.count > 0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSNumber *categoryId in categoriesIds) {
            [dict setObject:categoryId forKey:categoryId];
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *categoryIdsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        categoryIdsString = [categoryIdsString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        endPoint = [NSString stringWithFormat:@"forums?_lang=%@&_cat=%@", languageCode, categoryIdsString];
    }
    [self.networkManager GET:endPoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ForumItemListDataModel *forumsList = [ForumItemListDataModel modelObjectWithDictionary:responseObject];
        if (complition) {
            complition(forumsList.forumItems, forumsList.lastPage);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getForumDetails:(NSString *)forumId forLanguage:(NSString *)languageCode withComplition:(void(^)(ForumItemDataModel *forumsItem))complition failure:(void(^)(NSError *error))failure
{
    //{{baseUrl}}/{{apiPrefix}}/{{countryCode}}/{{languageCode}}/forum/9
    NSString *endpoint = [NSString stringWithFormat:@"forum/%@", forumId];
    [self.networkManager GET:endpoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ForumItemDataModel *forumItem = [ForumItemDataModel modelObjectWithDictionary:responseObject];
        if (complition) {
            complition(forumItem);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getReportCategories:(void(^)(ReportCategoryListDataModel *categoryList))complition failure:(void(^)(NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"report/categories"];
    [self.networkManager GET:endpoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ReportCategoryListDataModel *categoryList = [[ReportCategoryListDataModel alloc] initWithDictionary:responseObject];
        if (complition) {
            complition(categoryList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)reportUser:(NSDictionary *)params success:(void(^)(NSString *message))success failure:(void(^)(NSError *error))failure
{
    NSString *endpoint = [NSString stringWithFormat:@"report"];
    [self.networkManager POST:endpoint parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *message = [dict objectForKey:@"message"];
        if (![message isEqual:[NSNull null]]) {
            success(message);
        } else {
            success(message);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
