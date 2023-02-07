//
//  NSString+HTML.h
//  SafeYou
//
//  Created by Garnik Simonyan on 12/6/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HTML)

+ (NSAttributedString *)attributedStringFromHTML:(NSString *)htmlString;

@end

NS_ASSUME_NONNULL_END
