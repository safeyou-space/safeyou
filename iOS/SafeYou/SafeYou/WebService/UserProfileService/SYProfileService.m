//
//  SYProfileService.m
//  FantasySports
//
//  Created by Garnik Simonyan on 7/25/17.
//  Copyright © 2017 Garnik Simonyan. All rights reserved.
//

#import "SYProfileService.h"
#import "SYHTTPSessionManager.h"
#import "UserDataModel.h"
#import "ProfileQuestionsDataModel.h"

static NSString *const kthenByConfigurationsValue = @"[]";

@interface SYProfileService ()

@end

@implementation SYProfileService

- (NSString *)endpoint
{
    return @"profile";
}

- (NSString *)endpointForField:(NSString *)fieldName
{
    return [NSString stringWithFormat:@"profile/%@", fieldName];
}

- (NSString *)endpointForEmergencyContact
{
    return @"profile/emergency_contact";
}

- (NSString *)endpointForEmergencyContactWithId:(NSString *)contactId
{
    return [NSString stringWithFormat:@"%@/%@",[self endpointForEmergencyContact], contactId];
}

- (NSString *)endpointForEmergencyServiceContact
{
    return @"profile/emergency_service";
}

- (NSString *)endpointForEmergencyServiceContactWithId:(NSString *)serviceId
{
    return [NSString stringWithFormat:@"%@/%@", [self endpointForEmergencyServiceContact], serviceId];
}

- (NSString *)endpointForQuestions
{
    return @"profile/questions";
}

- (NSString *)endpointForFindLocation
{
    return  @"profile/find_town_city";
}

- (NSString *)endpointForQuestionId:(NSString *)questionId
{
    
    NSString *string1 = @"profile/";
    NSString *string2 = questionId;
    NSString *result = [string1 stringByAppendingString:string2];
    return result;
}


/*
 GET
 Get Profile
 endpoint: profile
 */

- (void)getUserDataWithComplition:(void(^)(UserDataModel *userData))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:[self endpoint] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UserDataModel *userData = [[UserDataModel alloc] initWithDictionary:responseObject];
        [Settings sharedInstance].onlineUser = userData;
        if (complition) {
            complition(userData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/*
 GET
 Get Profile Field Value By Field Name
 endppoint: profile/{field_name}
 */

- (void)getUserDataField:(NSString *)fieldPath withComplition:(void(^)(NSDictionary *response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager GET:[self endpointForField:fieldPath] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 {
 "field_name":"first_name",
 "field_value":"Arsine"
 }
 */
- (void)updateUserDataField:(NSString *)fieldName value:(NSString *)fieldValue withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSString *value = [NSString stringWithFormat:@"%@", fieldValue];
    NSDictionary *params = @{@"field_name":fieldName, @"field_value":value};
    [self.networkManager PUT:[self endpoint] parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self getUserDataWithComplition:nil failure:^(NSError *error) {
            NSLog(@"Error %@", error);
        }];
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)updateUserDataField:(NSString *)fieldName :(NSNumber *)questionId :(NSString *)questionType :(NSNumber *)questionOptionId  withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"field_name":fieldName, @"question_id":questionId,
                             @"question_type":questionType, @"question_option_id":questionOptionId};
    [self.networkManager PUT:[self endpoint] parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self getUserDataWithComplition:nil failure:^(NSError *error) {
            NSLog(@"Error %@", error);
        }];
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 POST
 Add Emergency Contact to Profile
 // endpoint: profile/emergency_contact
 
 data: { "name": "" , "phone: "" }
 */

- (void)addEmergencyContact:(NSString *)contactName phoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"name":contactName, @"phone":phoneNumber};
    [self.networkManager POST:[self endpointForEmergencyContact] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 PUT
 Update Emergency Contact by Emergency Id
 @params: { "name":"", "phone":""}
 endpoint:profile/emergency_contact/{contact_id}
 */

- (void)updateEmergencyContact:(NSString *)contactId withContactName:(NSString *)contactName phoneNumaber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"name": contactName, @"phone":phoneNumber};
    [self.networkManager PUT:[self endpointForEmergencyContactWithId:contactId] parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 DELETE
 Delete Emergency Contact by Emergency Id
 endpoint: profile/emergency_contact/{contact_id}
 */

- (void)deleteEmergencyContact:(NSString *)contactId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager DELETE:[self endpointForEmergencyContactWithId:contactId] parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*POST
 Add NGO to Profile
 // endpoint: profile/emergency_service_contact
 
 types: "ngo,volunteer,legal_service"
 data: {"type":"ngo","contact_id":"1"}
 */

- (void)addEmergencyService:(NSString *)serviceId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;
{
    NSDictionary *params = @{@"emergency_service_id":serviceId};
    [self.networkManager POST:[self endpointForEmergencyServiceContact] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 PUT
 Update NGO by Emergency Id
 endpoint:profile/emergency_service_contact/{contact_id}
 @param: contactID, {"type":"ngo","contact_id":"1"}
 */

- (void)updateEmergencyServiceContact:(NSString *)contactId withServiceId:(NSString *)serviceId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"emergency_service_id":serviceId};
    [self.networkManager PUT:[self endpointForEmergencyServiceContactWithId:contactId] parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 DELETE
 Delete Emergency Contact by Emergency Id
 endpoint: profile/emergency_service_contact/{contact_id}
 @param: contactId
 */

- (void)deleteEmergencyServiceContact:(NSString *)contactId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager DELETE:[self endpointForEmergencyServiceContactWithId:contactId] parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 Upload user avatar
 */

- (void)uploadUserAvatar:(UIImage *)image params:(NSDictionary *)params withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    NSData *imageData = [self shrinkedImageData:image];//UIImageJPEGRepresentation(image, 1.0);
    
    params = @{@"field_name":@"image",
               @"_method":@"PUT"};
    [self.networkManager POST:[self endpoint] parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (NSString *key in params.allKeys) {
            NSData* data = [params[key] dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:key];
        }
        
        [formData appendPartWithFileData:imageData name:@"field_value" fileName:@"avatar" mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Helper Image Size

- (NSData *)shrinkedImageData:(UIImage *)image
{
    CGFloat expectedSize = 1048576.f * 2; // 2 MByte
    CGFloat step = 0.1;
    CGFloat compression = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while (imageData.length > expectedSize) {
        compression-=step;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}

/*
 Remove user avatar
 //profile/remove_image
 */

- (void)removeUserAvatarComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure
{
    [self.networkManager DELETE:@"profile/remove_image" parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 DELETE
 Delete profile
 endpoint: profile/delete
 */
- (void)deleteProfile:(void (^)(id))complition failure:(void (^)(NSError *))failure
{
    [self.networkManager DELETE:@"profile/delete" parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complition) {
            complition(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 GET
 Get Profile Questions
 endpoint: questions
 */

- (void)getProfileQuestionsWithComplition:(void(^)(NSArray <ProfileQuestionsDataModel *> *))complition failure:(void(^)(NSError *error))failure
{
    
    [self.networkManager GET:[self endpointForQuestions] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *questionsData = [ProfileQuestionsDataModel createWithData: responseObject];
        
        if (complition) {
            complition(questionsData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 GET
 Get Profile Question With Id
 endpoint: questions
 */

- (void)getProfileQuestionWithComplition:(NSInteger)questionId :(void(^)(NSArray <ProfileQuestionsDataModel *> *))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"question_id":@(questionId)};
    [self.networkManager GET:[self endpointForQuestions] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *questionsData = [ProfileQuestionsDataModel createWithData: responseObject];
        
        if (complition) {
            complition(questionsData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
GET
Get Profile Find Town City
endpoint: profile/findText
*/

- (void)findTownOrCityWithComplition:(NSString *)findLocation :(void(^)(NSArray <ProfileQuestionsOption *> *))complition failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"keyword":findLocation};
    [self.networkManager GET:[self endpointForFindLocation] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *questionsData = [ProfileQuestionsOption createWithOptionsData: responseObject];
        
        if (complition) {
            complition(questionsData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
