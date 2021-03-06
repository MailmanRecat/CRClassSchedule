//
//  CRTheme.m
//  CRClassSchedule
//
//  Created by caine on 12/18/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTheme.h"

static NSString *const CRThemeColorDefault = @"default";

@implementation CRTheme

+ (NSDictionary *)themeColors{
    return @{
             @"default": [UIColor colorWithRed:70 / 255.0 green:136 / 255.0 blue:241 / 255.0 alpha:1],
             @"tomato": [UIColor colorWithRed:210 / 255.0 green:9 / 255.0 blue:21 / 255.0 alpha:1],
             @"tangerine": [UIColor colorWithRed:240 / 255.0 green:81 / 255.0 blue:43 / 255.0 alpha:1],
             @"banana": [UIColor colorWithRed:244 / 255.0 green:189 / 255.0 blue:58 / 255.0 alpha:1],
             @"basil": [UIColor colorWithRed:22 / 255.0 green:126 / 255.0 blue:68 / 255.0 alpha:1],
             @"sage": [UIColor colorWithRed:59 / 255.0 green:181 / 255.0 blue:123 / 255.0 alpha:1],
             @"peacock": [UIColor colorWithRed:26 / 255.0 green:155 / 255.0 blue:225 / 255.0 alpha:1],
             @"blueberry": [UIColor colorWithRed:65 / 255.0 green:94 / 255.0 blue:167 / 255.0 alpha:1],
             @"lavender": [UIColor colorWithRed:121 / 255.0 green:135 / 255.0 blue:200 / 255.0 alpha:1],
             @"grape": [UIColor colorWithRed:140 / 255.0 green:43 / 255.0 blue:167 / 255.0 alpha:1],
             @"flamingo": [UIColor colorWithRed:227 / 255.0 green:124 / 255.0 blue:116 / 255.0 alpha:1],
             @"graphite": [UIColor colorWithRed:99 / 255.0 green:99 / 255.0 blue:99 / 255.0 alpha:1],
             @"black": [UIColor colorWithWhite:0 alpha:1]
             };
}

+ (UIColor *)themeColorFromString:(NSString *)string{
    
    NSDictionary *colors = [CRTheme themeColors];
    
    return ({
        UIColor *color = (UIColor *)colors[[string lowercaseString]];
        color ? color : colors[CRThemeColorDefault];
    });
}

@end
