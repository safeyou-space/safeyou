//
//  CountryDataModel.m
//  SafeYou
//
//  Created by Garnik Simonyan on 4/26/20.
//  Copyright © 2020 Garnik Simonyan. All rights reserved.
//

#import "RegionalOptionDataModel.h"
#import "ImageDataModel.h"

NSString *const  kRegionalOptionId = @"id";
NSString *const  kRegionalOptionName = @"name";
NSString *const  kRegionalOptionShortCode = @"short_code";
NSString *const  kRegionalOptionLocalizationCode = @"localization_code";
NSString *const  kRegionalOptionImageId = @"image_id";
NSString *const  kRegionalOptionImageData = @"image";

@implementation RegionalOptionDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        objectOrNilForKey(self.itemId, dict, kRegionalOptionId);
        objectOrNilForKey(self.name, dict, kRegionalOptionName);
        objectOrNilForKey(self.apiServiceCode, dict, kRegionalOptionShortCode);
        objectOrNilForKey(self.imageId, dict, kRegionalOptionImageId);
        NSDictionary *imageDataDict = nilOrJSONObjectForKey(dict, kRegionalOptionImageData);
        if (imageDataDict) {
            self.imageData = [ImageDataModel modelObjectWithDictionary:imageDataDict];
        }
    }
    
    return self;
}

@end

@implementation CountryDataModel : RegionalOptionDataModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.itemId forKey:kRegionalOptionId];
    [encoder encodeObject:self.name forKey:kRegionalOptionName];
    [encoder encodeObject:self.apiServiceCode forKey:kRegionalOptionShortCode];
    [encoder encodeObject:self.imageData forKey:kRegionalOptionImageData];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.itemId = [decoder decodeObjectForKey:kRegionalOptionId];
        self.name = [decoder decodeObjectForKey:kRegionalOptionName];
        self.apiServiceCode = [decoder decodeObjectForKey:kRegionalOptionShortCode];
        self.imageData = [decoder decodeObjectForKey:kRegionalOptionImageData];
    }
    return self;
}

@end


NSString *const  kLanguageOptionId          = @"id";
NSString *const  kLanguageOptionName        = @"title";
NSString *const  kLanguageOptionShortCode   = @"code";
NSString *const  kLanguageOptionImageId     = @"image_id";
NSString *const  kLanguageOptionImageData   = @"image";

@implementation LanguageDataModel : RegionalOptionDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        objectOrNilForKey(self.itemId, dict, kLanguageOptionId);
        objectOrNilForKey(self.name, dict, kLanguageOptionName);
        objectOrNilForKey(self.apiServiceCode, dict, kLanguageOptionShortCode);
        self.localizationShortCode = [LanguageDataModel localizationCodeForApiCode:self.apiServiceCode];
        objectOrNilForKey(self.imageId, dict, kLanguageOptionImageId);
        NSDictionary *imageDataDict = nilOrJSONObjectForKey(dict, kLanguageOptionImageData);
        if (imageDataDict) {
            self.imageData = [ImageDataModel modelObjectWithDictionary:imageDataDict];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:self.itemId forKey:kRegionalOptionId];
    [encoder encodeObject:self.name forKey:kRegionalOptionName];
    [encoder encodeObject:self.apiServiceCode forKey:kRegionalOptionShortCode];
    [encoder encodeObject:self.localizationShortCode forKey:kRegionalOptionLocalizationCode];
    [encoder encodeObject:self.imageData forKey:kRegionalOptionImageData];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.itemId = [decoder decodeObjectForKey:kRegionalOptionId];
        self.name = [decoder decodeObjectForKey:kRegionalOptionName];
        self.apiServiceCode = [decoder decodeObjectForKey:kRegionalOptionShortCode];
        self.localizationShortCode = [decoder decodeObjectForKey:kRegionalOptionLocalizationCode];
        self.localizationShortCode = nil;
        self.imageData = [decoder decodeObjectForKey:kRegionalOptionImageData];
    }
    return self;
}

+ (NSString *)localizationCodeForApiCode:(NSString *)apiCode
{
    /**
     kurdish sorani - key - qs
     kurdish badini - key - ku
     arabic- key - ar
     */
    /**
     kurdish sorani - key - ckb
     kurdish badini - key - ku
     arabic- key - ar
     */
    if ([apiCode isEqualToString:@"iw"]) {
        return @"ckb";
    }
    
    if ([apiCode isEqualToString:@"ps"]) {
        return @"ku";
    }
    
    if ([apiCode isEqualToString:@"ka"]) {
        return @"ka_GE";
    }
    
    return apiCode;
}

@end
