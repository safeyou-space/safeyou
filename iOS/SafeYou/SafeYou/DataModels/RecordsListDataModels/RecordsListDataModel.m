//
//  RecordsListDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/21/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordsListDataModel.h"

NSString *const kRecordsListItem = @"recirdId";

@interface RecordsListDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RecordsListDataModel

@synthesize records = _records;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedRecordListItem = dict;
        NSMutableArray *parsedRecordListItem = [NSMutableArray array];
        
        if ([receivedRecordListItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedRecordListItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedRecordListItem addObject:[RecordListItemDataModel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedRecordListItem isKindOfClass:[NSDictionary class]]) {
            [parsedRecordListItem addObject:[RecordListItemDataModel modelObjectWithDictionary:(NSDictionary *)receivedRecordListItem]];
        }
        
    } else if ([dict isKindOfClass:[NSArray class]]) {
        NSObject *receivedRecordListItem = dict;
        NSMutableArray *parsedRecordListItem = [NSMutableArray array];
        
        if ([receivedRecordListItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedRecordListItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedRecordListItem addObject:[RecordListItemDataModel modelObjectWithDictionary:item]];
                }
            }
            self.records = [NSArray arrayWithArray:parsedRecordListItem];
        }
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForRecordListItem = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.records) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForRecordListItem addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForRecordListItem addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRecordListItem] forKey:kRecordsListItem];
    
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
    
    self.records = [aDecoder decodeObjectForKey:kRecordsListItem];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_records forKey:kRecordsListItem];
}

- (id)copyWithZone:(NSZone *)zone {
    RecordsListDataModel *copy = [[RecordsListDataModel alloc] init];
    
    
    
    if (copy) {
        
        copy.records = [self.records copyWithZone:zone];
    }
    
    return copy;
}

@end
