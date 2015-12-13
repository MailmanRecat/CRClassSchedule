//
//  CRLanguage.h
//  CRClassSchedule
//
//  Created by caine on 12/12/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CRLanguageCN = @"CRLanguageCN";
static NSString *const CRLanguageEN = @"CRLanguageEN";

@interface CRLanguage : NSObject

+ (NSString *)deviceLanguage;

+ (NSString *)currentLanguage;
+ (void)setDefaultLanguage:(NSString *)lang;

+ (NSString *)stringFromEnUS:(NSString *)string;

@end
