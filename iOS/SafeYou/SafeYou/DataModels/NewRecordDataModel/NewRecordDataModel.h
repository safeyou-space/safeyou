//
//  NewRecordDataModel.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/19/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "BaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewRecordDataModel : BaseDataModel

/*
 { [ name ] : "something ..." ,
 
 [ location] : "something ..." ,
 
 [ latitude] : "double ..." ,
 
 [ longitude ] : "double ..." ,
 
 [ duration ] : "integer ..." (secunds) ,
 
 [ date] : "date()..." (date_format:Y-m-d)
 
 [ time] : "time()..." (time_format:H:i:s)
 
 [ audio ] : "file" (mimes:audio/mpeg,mpga,mp3,wav and max size 5mb)
 */

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *duration;
@property (nonatomic) NSString *dateCreated;
@property (nonatomic) NSString *timeCreated;
@property (nonatomic) NSString *filePath;
@property (nonatomic) NSData *audioData;

@end

NS_ASSUME_NONNULL_END
