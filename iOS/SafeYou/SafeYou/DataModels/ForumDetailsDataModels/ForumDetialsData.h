//
//  ForumDetialsData.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
@class ChatMessageDataModel;


@interface ForumDetialsData : BaseDataModel

/**
 {
     "id": 9,
     "image_id": 83,
     "creator_id": 2,
     "from": null,
     "to": null,
     "age_restricted": 0,
     "views_count": 0,
     "comments_count": 0,
     "status": 1,
     "created_at": "2020-08-03T20:58:48.000000Z",
     "updated_at": "2020-08-03T20:58:48.000000Z",
     "deleted_at": null,
     "title": "Ի՞նչ է վիքթիմբլեյմինգը և ինչո՞վ է վտանգավոր զոհի մեղադրումը",
     "description": Content,
     "sub_title": "Այս ֆորումը ստեղծվել է Safe YOU նախաձեռնության կողմից",
     "short_description": "Այս ֆորումում մենք ուզում ենք քննարկել և հասկանալ բռնության զոհին մեղադրելու երևույթը և դրա վտանգավոր հետևանքները։",
     "translation": [
       {
         "id": 18,
         "title": "Ի՞նչ է վիքթիմբլեյմինգը և ինչո՞վ է վտանգավոր զոհի մեղադրումը",
         "sub_title": "Այս ֆորումը ստեղծվել է Safe YOU նախաձեռնության կողմից",
         "description": "Content",
         "short_description": "Այս ֆորումում մենք ուզում ենք քննարկել և հասկանալ բռնության զոհին մեղադրելու երևույթը և դրա վտանգավոր հետևանքները։",
         "language_id": 2,
         "forum_id": 9,
         "created_at": "2020-08-03T20:58:48.000000Z",
         "updated_at": "2020-08-03T21:08:11.000000Z",
         "deleted_at": null
       }
     ]
   }
 */

//@property (nonatomic, strong) NSArray <ChatMessageDataModel *>*comments;
//@property (nonatomic, strong) NSArray <ChatMessageDataModel *>*strippedComments;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *forumId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *topCommentedUsers;
@property (nonatomic, assign) NSInteger commentsCount;

// data for filter comments

@property (nonatomic) NSNumber *currentCommentId;
@property (nonatomic, readonly) NSArray <ChatMessageDataModel *>*originalComments;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict level:(NSInteger)level;


@end
