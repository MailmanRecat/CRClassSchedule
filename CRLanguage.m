//
//  CRLanguage.m
//  CRClassSchedule
//
//  Created by caine on 12/12/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRLanguage.h"

static NSString *const CRLanguagekey = @"CRLanguageKey";

@implementation CRLanguage

+ (NSString *)deviceLanguage{
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return currentLanguage;
}

+ (NSString *)currentLanguage{
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:CRLanguagekey];
    if( !lang ){
        lang = CRLanguageEN;
        [CRLanguage setDefaultLanguage:lang];
    }
    
    return lang;
}

+ (void)setDefaultLanguage:(NSString *)lang{
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:CRLanguagekey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)stringFromEnUS:(NSString *)string{
    
    NSDictionary *en, *cn;
    
    en = @{
           @"monday": @"星期一",
           @"thesday": @"星期二",
           @"wednesday": @"星期三",
           @"thursday": @"星期四",
           @"Friday": @"星期五",
           @"saturday": @"星期六",
           @"sunday": @"星期日",
           @"dont't have any class today": @"",
           @"new class": @"",
           @"save": @"",
           @"delete": @"",
           @"edit": @""
           };
    
    cn = @{};
    
    if( [CRLanguage currentLanguage] == CRLanguageCN ){
        
    }
    
    return string;
}

@end
