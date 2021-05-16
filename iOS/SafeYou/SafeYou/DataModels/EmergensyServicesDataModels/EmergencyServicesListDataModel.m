//
//  EmergencyServicesListDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/8/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "EmergencyServicesListDataModel.h"
#import "EmergencyServiceDataModel.h"


@interface EmergencyServicesListDataModel ()

@property (nonatomic) NSString *listNameKey;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end


@implementation EmergencyServiceTypes

@synthesize ngo = _ngo;
@synthesize volunteer = _volunteer;
@synthesize legalService = _legalService;

- (id)init
{
    self = [super init];
    if (self) {
        self.ngo = @"ngo";
        self.volunteer = @"volunteer";
        self.legalService = @"legal_service";
    }
    
    return self;
}

@end

@implementation EmergencyServicesListDataModel

@synthesize emergnecyServices = _emergnecyServices;
@synthesize listNameKey = _listNameKey;

+ (EmergencyServiceTypes *)serviceType
{
    EmergencyServiceTypes *servicesTypes = [[EmergencyServiceTypes alloc] init];
    return servicesTypes;
}


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (NSString *)listNameKey
{
    return @"ngos";
}

- (NSArray  <EmergencyServiceDataModel *> *)servicesForcategoryId:(NSString *)categoryId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId=%@", categoryId];
    NSArray <EmergencyServiceDataModel *> *filteredArray = [self.emergnecyServices filteredArrayUsingPredicate:predicate];
    if (filteredArray) {
        return filteredArray;
    }
    return @[];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedServices = [dict objectForKey:self.listNameKey];
        NSMutableArray *parsedVolunteers = [NSMutableArray array];
        
        if ([receivedServices isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedServices) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedVolunteers addObject:[EmergencyServiceDataModel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedServices isKindOfClass:[NSDictionary class]]) {
            [parsedVolunteers addObject:[EmergencyServiceDataModel modelObjectWithDictionary:(NSDictionary *)receivedServices]];
        }
        
        self.emergnecyServices = [NSArray arrayWithArray:parsedVolunteers];
        
    } else if ([dict isKindOfClass:[NSArray class]]) {
        NSObject *receivedServices = dict;
        NSMutableArray *parsedVolunteers = [NSMutableArray array];
            for (NSDictionary *item in (NSArray *)receivedServices) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedVolunteers addObject:[EmergencyServiceDataModel modelObjectWithDictionary:item]];
                }
            }
        
        self.emergnecyServices = [NSArray arrayWithArray:parsedVolunteers];
    }
    
    return self;

}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForVolunteers = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.emergnecyServices) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForVolunteers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForVolunteers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForVolunteers] forKey:self.listNameKey];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.emergnecyServices = [aDecoder decodeObjectForKey:self.listNameKey];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_emergnecyServices forKey:self.listNameKey];
}

- (id)copyWithZone:(NSZone *)zone {
    EmergencyServicesListDataModel *copy = [[EmergencyServicesListDataModel alloc] init];
    
    if (copy) {
        copy.emergnecyServices = [self.emergnecyServices copyWithZone:zone];
    }
    
    return copy;
}


@end
