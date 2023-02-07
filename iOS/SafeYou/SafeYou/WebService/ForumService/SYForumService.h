//
//  SYForumService.h
//  SafeYou
//
//  Created by Garnik Simonyan on 11/2/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
@class ForumItemListDataModel, ForumItemDataModel, ReportCategoryListDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYForumService : SYServiceAPI

/*
 GET
Forum Categories

 endpoint: /consultant_categories

 */

- (void)getForumCategoriesWithComplition:(void(^)(NSArray * categoriesList))complition failure:(void(^)(NSError *error))failure;

/*
 GET
Forum All Forums

 endpoint: /forums

 */

- (void)getForumsForLanguage:(NSString *)languageCode categories:(NSArray <NSString *> *)categoriesIds page:(NSInteger)page withComplition:(void(^)(NSArray <ForumItemDataModel *>*forumItems, NSInteger lastPage))complition failure:(void(^)(NSError *error))failure;


/*
 GET
Forum Details

 endpoint: /consultant_categories

 */

- (void)getForumDetails:(NSString *)forumId forLanguage:(NSString *)languageCode withComplition:(void(^)(ForumItemDataModel *forumsItem))complition failure:(void(^)(NSError *error))failure;

/*
 GET
Report Comment Categories

 endpoint: /report/categories

 */

- (void)getReportCategories:(void(^)(ReportCategoryListDataModel *categoryList))complition failure:(void(^)(NSError *error))failure;

/*
 POST
Report User

 endpoint: /report

 */

- (void)reportUser:(NSDictionary *)params success:(void(^)(NSString *message))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
