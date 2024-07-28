//
//  ChatMessageDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 10/6/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"
#import "ChatUserDataModel.h"
#import "MessageLikeDataModel.h"

@interface ChatMessageDataModel : BaseDataModel

@property (nonatomic) NSString *messageContent;
@property (nonatomic) NSString *createdDateString;
@property (nonatomic) id editedBy;
@property (nonatomic) NSArray *messageFiles; // @TODO: clarify types in the array
@property (nonatomic) UIImage *messageImage; 
@property (nonatomic) NSNumber *messageId;
@property (nonatomic) BOOL isOwner;
@property (nonatomic) NSArray <MessageLikeDataModel *> *likes;
@property (nonatomic) NSArray *mentionOptions; // @TODO: clarify types in the array
@property (nonatomic) NSArray *receivers; // @TODO: clarify types in the array
@property (nonatomic) NSInteger messageLevel;
@property (nonatomic) NSArray <ChatMessageDataModel *> *replies;
@property (nonatomic) NSNumber *roomId;
@property (nonatomic) ChatUserDataModel *sender;
@property (nonatomic) MessageType messageType;
@property (nonatomic) NSString *roomKey;

@property (nonatomic) NSNumber *parentMessageId;


// new reply functionality
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, strong) NSString *replyInfo;

@property (nonatomic, readonly) BOOL isMine;

@property (nonatomic) NSInteger likesCount;
@property (nonatomic) BOOL isLiked;

// view model

@property (nonatomic) NSString *formattedCreatedDate;

- (void)addReplyMessage:(ChatMessageDataModel *)replyMessage;

@end
