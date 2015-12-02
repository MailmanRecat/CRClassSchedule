//
//  CRClassDatabase.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassDatabase.h"

static NSString *const CRClassDatabaseSundayKey = @"CRClassDatabaseSundayKey";
static NSString *const CRClassDatabaseMondayKey = @"CRClassDatabaseMondayKey";
static NSString *const CRClassDatabaseTuesdayKey = @"CRClassDatabaseTuesdayKey";
static NSString *const CRClassDatabaseWednesdayKey = @"CRClassDatabaseWednesdayKey";
static NSString *const CRClassDatabaseThursdayKey = @"CRClassDatabaseThursdayKey";
static NSString *const CRClassDatabaseFridayKey = @"CRClassDatabaseFridayKey";
static NSString *const CRClassDatabaseSaturdayKey = @"CRClassDatabaseSaturdayKey";

@interface CRClassDatabase()

@end

@implementation CRClassDatabase

+ (BOOL)insert:(CRClassSchedule *)schedule{
    
    NSArray *row = @[
                     schedule.weekday,
                     schedule.timeStart,
                     schedule.location,
                     schedule.classname,
                     schedule.teacher,
                     schedule.timeLong,
                     schedule.colorStyle,
                     schedule.userInfo,
                     schedule.type
                     ];
    
    NSString *key = [self CRClassDatabaseKeyFromWeekday:schedule.weekday];
    if( !key ) return NO;
    
    NSMutableArray *table = [[NSMutableArray alloc] initWithArray:[self selectClass:key]];
    [table addObject:row];
    [self insertTable:table toWeekday:key];
    
    return YES;
}

+ (NSArray *)selectClassFromWeekday:(NSString *)day{
    return [self selectClass:[self CRClassDatabaseKeyFromWeekday:day]];
}

+ (NSArray *)selectClass:(NSString *)key{
    
    NSArray *res = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if( !res ) res = [NSArray new];
    
    return [[NSMutableArray alloc] initWithArray:res];
}

+ (void)insertTable:(NSArray *)table toWeekday:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:table forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)CRClassDatabaseKeyFromWeekday:(NSString *)day{
    NSString *weekday = [day lowercaseString];
    NSString *key;
    if( [weekday isEqualToString:@"sunday"]  )
        key = CRClassDatabaseSundayKey;
    
    else if( [weekday isEqualToString:@"monday"] )
        key = CRClassDatabaseMondayKey;
    
    else if( [weekday isEqualToString:@"tuesday"] )
        key = CRClassDatabaseTuesdayKey;
    
    else if( [weekday isEqualToString:@"wednesday"] )
        key = CRClassDatabaseWednesdayKey;
    
    else if( [weekday isEqualToString:@"thursday"] )
        key = CRClassDatabaseThursdayKey;
    
    else if( [weekday isEqualToString:@"friday"] )
        key = CRClassDatabaseFridayKey;
    
    else if( [weekday isEqualToString:@"saturday"] )
        key = CRClassDatabaseSaturdayKey;
    
    return key;
}

@end
