//
//  NSString+HTML.m
//  SafeYou
//
//  Created by Garnik Simonyan on 12/6/21.
//  Copyright © 2021 Garnik Simonyan. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

+ (NSAttributedString *)attributedStringFromHTML:(NSString *)htmlString
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil error:nil];
    
    return attributedString;
    
}

@end
