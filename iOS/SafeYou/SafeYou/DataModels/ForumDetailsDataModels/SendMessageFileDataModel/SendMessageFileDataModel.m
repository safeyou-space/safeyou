//
//  SendMessageFileDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/26/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "SendMessageFileDataModel.h"

@implementation SendMessageFileDataModel

- (instancetype)initWithMessage:(nullable NSString *)message
                          image:(nullable UIImage *)image
             audioFileDirectory:(nullable NSURL *)audioFileDirectory
                      commentId:(nullable NSNumber *)commentId {
    self = [super init];
    if (self) {
        self.messageParameters = [[NSMutableDictionary alloc] init];
        self.messageFormDataParameters = [[NSMutableDictionary alloc] init];
        MessageType messageType = MessageTypeSystem;
        if (message.length > 0) {
            messageType = MessageTypeCommon;
            self.messageParameters[@"message_content"] = message;
            self.fileType = FileTypeNone;
        }
        if (image != nil) {
            if (messageType != MessageTypeCommon) {
                messageType = MessageTypeMedia;
            }
            NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
            self.messageFormDataParameters[@"message_files[0]"] = imageData;
            self.fileType = FileTypeImage;
        }
        if(audioFileDirectory != nil) {
            messageType = MessageTypeMedia;
            NSData *audioData = [NSData dataWithContentsOfURL:audioFileDirectory];
            self.messageFormDataParameters[@"message_files[0]"] = audioData;
            self.fileType = FileTypeAudio;
        }
        if(commentId != nil) {
            self.messageParameters[@"message_replies"] = @[commentId];
        }
        self.messageParameters[@"message_type"] = [NSString stringWithFormat:@"%@",@(messageType)];
    }
    
    return self;
}

@end
