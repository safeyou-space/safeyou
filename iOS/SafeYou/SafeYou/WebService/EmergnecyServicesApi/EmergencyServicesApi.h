//
//  EmergencyServicesApi.h
//  SafeYou
//
//  Created by Garnik Simonyan on 9/13/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "SYServiceAPI.h"

@class EmergencyServicesListDataModel, ServiceSearchResult, EmergencyServiceDataModel, EmergencyServicesDataModel, ServiceCategoryDataModel;

typedef NS_ENUM(NSUInteger, EmergencyServiceType) {
    EmergencyServiceTypeUnknown,
    EmergencyServiceTypeVounteer,
    EmergencyServiceTypeNGO,
    EmergencyServiceTypeLegalService
};

@protocol EmergencyServicesApiInterface <NSObject>

- (void)getEmergencyServicesWithComplition:(void(^_Nonnull)(EmergencyServicesListDataModel * _Nullable emergencySerivcesList))complition failure:(void(^_Nonnull)(NSError * _Nonnull error))failure;

- (void)getEmergencyServicesById:(NSString *_Nonnull)serviceId type:(NSString *_Nonnull)type complition:(void(^_Nonnull)(EmergencyServiceDataModel * _Nonnull serviceData))complition failure:(void(^_Nonnull)(NSError * _Nullable error))failure;

- (void)getEmergencyServicesWithSearchString:(NSString *_Nonnull)searchString complition:(void(^_Nonnull)(NSArray <ServiceSearchResult *> * _Nullable searchResult))complition failure:(void(^_Nonnull)(NSError * _Nullable error))failure;

- (void)getEmergencyServicesCategoriesWithComplition:(void(^_Nonnull)(NSArray <ServiceCategoryDataModel*> * _Nonnull emergencySerivcesCategoryList))complition failure:(void(^_Nonnull)(NSError * _Nullable error))failure;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EmergencyServicesApi : SYServiceAPI <EmergencyServicesApiInterface>

- (instancetype)initWithEmergency:(BOOL)forEmergency;

@end


NS_ASSUME_NONNULL_END
