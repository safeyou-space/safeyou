//
//  SYProfileService.h
//  FantasySports
//
//  Created by Garnik Simonyan on 7/25/17.
//  Copyright © 2017 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"
#import "UserDataModel.h"
#import "ProfileQuestionsDataModel.h"

@interface SYProfileService : SYServiceAPI

/*
GET
Get Profile
endpoint: profile
*/

- (void)getUserDataWithComplition:(void(^)(UserDataModel *userData))complition failure:(void(^)(NSError *error))failure;

/*
GET
Get Profile Field Value By Field Name
endppoint:
 */
- (void)getUserDataField:(NSString *)fieldPath withComplition:(void(^)(NSDictionary *response))complition failure:(void(^)(NSError *error))failure;

/*
 {
 "field_name":"first_name",
 "field_value":"Arsine"
 }
 */
- (void)updateUserDataField:(NSString *)fieldName value:(NSString *)fieldValue withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

- (void)updateUserDataField:(NSString *)fieldName :(NSNumber *)questionId :(NSString *)questionType :(NSNumber *)questionOptionId  withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*POST
Add Emergency Contact to Profile
 // endpoint: profile/emergency_contact
 
 data: { "name": "" , "phone: "" }
 */

- (void)addEmergencyContact:(NSString *)contactName phoneNumber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 PUT
 Update Emergency Contact by Emergency Id
 @params: { "name":"", "phone":""}
 endpoint:profile/emergency_contact/{contact_id}
 */

- (void)updateEmergencyContact:(NSString *)contactId withContactName:(NSString *)contactName phoneNumaber:(NSString *)phoneNumber withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
DELETE
Delete Emergency Contact by Emergency Id
 endpoint: profile/emergency_contact/{contact_id}
 */

- (void)deleteEmergencyContact:(NSString *)contactId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*POST
 Add NGO to Profile
 // endpoint: profile/emergency_service_contact
 
 types: "ngo,volunteer,legal_service"
 data: {"type":"ngo","contact_id":"1"}
 */

- (void)addEmergencyService:(NSString *)serviceId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 PUT
 Update NGO by Emergency Id
 endpoint:profile/emergency_service_contact/{contact_id}
 @param: contactID, {"type":"ngo","contact_id":"1"}
 */

- (void)updateEmergencyServiceContact:(NSString *)contactId withServiceId:(NSString *)serviceId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 DELETE
 Delete Emergency Contact by Emergency Id
 endpoint: profile/emergency_service_contact/{contact_id}
 @param: contactId
 */

- (void)deleteEmergencyServiceContact:(NSString *)contactId withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
 Upload user avatar
 */

- (void)uploadUserAvatar:(UIImage *)image params:(NSDictionary *)params withComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;



/*
 Remove user avatar
 //profile/remove_image
 */

- (void)removeUserAvatarComplition:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;


/*
 DELETE
 Delete profile
 endpoint: profile/delete
 */
- (void)deleteProfile:(void(^)(id response))complition failure:(void(^)(NSError *error))failure;

/*
GET
Get Profile Questions
endpoint: profile/questions
*/

- (void)getProfileQuestionsWithComplition:(void(^)(NSArray <ProfileQuestionsDataModel *> *questionsData))complition failure:(void(^)(NSError *error))failure;

/*
 GET
 Get Profile Question With Id
 endpoint: questions
 */

- (void)getProfileQuestionWithComplition:(NSInteger)questionId :(void(^)(NSArray <ProfileQuestionsDataModel *> *))complition failure:(void(^)(NSError *error))failure;

/*
GET
Get Profile Find Town City
endpoint: profile/findText
*/

- (void)findTownOrCityWithComplition:(NSString *)findLocation :(void(^)(NSArray <ProfileQuestionsOption *> *))complition failure:(void(^)(NSError *error))failure;

@end
