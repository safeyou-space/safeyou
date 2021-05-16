//
//  ConsultantNewRequestDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 3/28/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "ConsultantNewRequestDataModel.h"
#import "ConsultantExpertiseFieldDataModel.h"

@implementation ConsultantNewRequestDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        objectOrNilForKey(self.emailAddress, dict, @"email");
        objectOrNilForKey(self.promotionalText, dict, @"message");
        integerObjectOrNilForKey(self.requestStatus, dict, @"status");
        
        //@TODO: Garnik implement parsing for rest fields
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.emailAddress) {
        [dataDictionary setValue:self.emailAddress forKey:@"email"];
    }
    if (self.isNewExpertiseFieldSuggested) {
        if (self.suggestedExpertiseField.length) {
            [dataDictionary setValue:self.suggestedExpertiseField forKey:@"suggested_category"];
        }
    } else {
        [dataDictionary setValue:self.expertiseFieldDataModel.categoryId forKey:@"category_id"];
    }
    if (self.promotionalText.length) {
        [dataDictionary setValue:self.promotionalText forKey:@"message"];
    }
    
    return [dataDictionary copy];
}

@end
