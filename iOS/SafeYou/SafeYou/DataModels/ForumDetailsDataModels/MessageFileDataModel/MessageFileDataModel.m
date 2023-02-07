//
//  MessageFileDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/22/22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

#import "MessageFileDataModel.h"

@implementation MessageFileDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        objectOrNilForKey(self.name, dict, @"file_name");
        objectOrNilForKey(self.path, dict, @"file_path");
        objectOrNilForKey(self.mimetype, dict, @"file_mime_type");
        objectOrNilForKey(self.md5, dict, @"file_md5");
        objectOrNilForKey(self.createdAt, dict, @"file_created_at");
        objectOrNilForKey(self.updatedAt, dict, @"file_updated_at");
        objectOrNilForKey(self.audioDuration, dict, @"file_audio_duration");
        integerObjectOrNilForKey(self.messageId, dict, @"file_message_id");
        integerObjectOrNilForKey(self.roomId, dict, @"file_room_id");
        integerObjectOrNilForKey(self.type, dict, @"file_type");
        doubleObjectOrNilForKey(self.fileId, dict, @"file_id");
        doubleObjectOrNilForKey(self.size, dict, @"file_size");
    }
    
    return self;
}

- (int)audioDurationSeconds {
    int result = 0;
    if(self.audioDuration != nil) {
        NSArray *durationItems = [self.audioDuration componentsSeparatedByString:@":"];
        if(durationItems.count > 0) {
            NSString *minutes = durationItems[0];
            NSString *seconds = durationItems[1];
            result = 60 * [minutes intValue] + [seconds intValue];
        }
    }
    return result;
}

- (NSURL *)mediaPath {
    NSString *imagePathString = [NSString stringWithFormat:@"%@%@",[Settings sharedInstance].socketAPIURL, self.path];
    return [[NSURL alloc] initWithString:imagePathString];
}

@end
