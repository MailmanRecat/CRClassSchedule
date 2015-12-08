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

static NSString *const CRClassDatabaseKey = @"CRCLASSDATABASEKEY";

static NSString *const CRClassScheduleDatabaseKey = @"CRClassScheduleDatabaseKey";

static NSString *const CRClassAccountDataBaseKEY = @"CRCLASSACCOUNTDATABASEKEY";

@interface CRClassDatabase()

@end

@implementation CRClassDatabase

+ (BOOL)insertCRClassSchedule:(CRClassSchedule *)schedule{
    NSArray *row = @[
                     schedule.user,
                     schedule.weekday,
                     schedule.timeStart,
                     schedule.location,
                     schedule.classname,
                     schedule.teacher,
                     schedule.timeLong,
                     schedule.colorType,
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

+ (NSArray *)selectClassFromUserName:(NSString *)name{
    return [NSArray new];
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

//CRClassSchedule datebase begin
+ (NSString *)CRClassScheduleDatabaseKeyFromUser:(NSString *)user{
    return [NSString stringWithFormat:@"%@%@", user, CRClassScheduleDatabaseKey];
}

+ (NSUInteger)integerFromTimeString:(NSString *)time{
    return [[NSString stringWithFormat:@"%@%@", [time substringWithRange:NSMakeRange(0, 2)], [time substringWithRange:NSMakeRange(3, 2)]] integerValue];
}

+ (NSArray *)sortCRClassScheduleByTime:(NSArray *)schedule{
    return [schedule sortedArrayUsingComparator:^(id obj1, id obj2){
        NSUInteger number1 = [CRClassDatabase integerFromTimeString:(NSString *)obj1[3]];
        NSUInteger number2 = [CRClassDatabase integerFromTimeString:(NSString *)obj2[3]];
        
        if( number1 < number2 )
            return (NSComparisonResult)NSOrderedAscending;
        
        if( number1 > number2 )
            return (NSComparisonResult)NSOrderedDescending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
}

+ (NSArray *)rowFromCRClassSchedule:(CRClassSchedule *)schedule{
    return @[
             schedule.scheduleID,
             schedule.user,
             schedule.weekday,
             schedule.timeStart,
             schedule.location,
             schedule.classname,
             schedule.teacher,
             schedule.timeLong,
             schedule.colorType,
             schedule.userInfo,
             schedule.type
             ];
}

+ (CRClassSchedule *)CRClassScheduleFromRow:(NSArray *)row{
    return [CRClassSchedule ClassScheduleFromDictionary:@{
                                                          ClassScheduleID: row.firstObject,
                                                          ClassScheduleUser: row[1],
                                                          ClassScheduleWeekday: row[2],
                                                          ClassScheduleTimeStart: row[3],
                                                          ClassScheduleLocation: row[4],
                                                          ClassScheduleClassname: row[5],
                                                          ClassScheduleTeacher: @"Edit teacher",
                                                          ClassScheduleTimeLong: @"40 mins",
                                                          ClassScheduleColorType: @"Default",
                                                          ClassScheduleUserInfo: @"Add note",
                                                          ClassScheduleType: @"nullable type"
                                                          }];
}

+ (NSMutableArray *)selectCRClassScheduleFromUser:(NSString *)user{
    NSString *KEY = [CRClassDatabase CRClassScheduleDatabaseKeyFromUser:user];
    NSMutableArray *schedules = [[NSUserDefaults standardUserDefaults] objectForKey:KEY];
    if( !schedules ){
        schedules = [NSMutableArray new];
        for( int i = 0; i < 7; i++ ){
            schedules[i] = [NSMutableArray new];
        }
    }
    
    return schedules;
}

+ (BOOL)insertCRClassSchedule:(CRClassSchedule *)schedule fromUser:(NSString *)user{
    NSMutableArray *schedules = [CRClassDatabase selectCRClassScheduleFromUser:user];
    return YES;
}
//CRClassSchedule datebase end

// CRClassAccount database begin
+ (NSArray *)rowFromCRClassAccount:(CRClassAccount *)account{
    return @[ account.current, account.ID, account.colorType ];
}

+ (CRClassAccount *)CRClassAccountFromRow:(NSArray *)array{
    return [CRClassAccount accountFromDictionary:@{
                                                   CRClassAccountCurrentKEY: array.firstObject,
                                                   CRClassAccountIDKEY: array[1],
                                                   CRClassAccountColorTypeKEY: array.lastObject
                                                   }];
}

+ (NSArray *)selectClassAccountFromAll{
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithArray:[CRClassDatabase selectAccountFromAll]];
    
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        accounts[index] = [CRClassDatabase CRClassAccountFromRow:accounts[index]];
    }];
    
    return accounts;
}

+ (NSArray *)selectAccountFromAll{
    NSArray *accounts;
    accounts = [[NSUserDefaults standardUserDefaults] objectForKey:CRClassAccountDataBaseKEY];
    if( accounts ) return accounts;
    
    return [NSArray new];
}

+ (BOOL)haveCRClassAccount:(NSString *)ID{
    NSArray *accounts = [CRClassDatabase selectAccountFromAll];
    __block BOOL have = NO;
    
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        NSArray *account = (NSArray *)obj;
        if( [account[1] isEqualToString:ID] )
            have = YES;
    }];
    
    return have;
}

+ (BOOL)changeCRClassAccountCurrent:(CRClassAccount *)account{
    NSArray *accounts = [CRClassDatabase selectAccountFromAll];
    
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        NSMutableArray *acc = [[NSMutableArray alloc] initWithArray:(NSArray *)obj];
        if( [acc[1] isEqualToString:account.ID] )
            acc[0] = @"YES";
        else
            acc[0] = @"NO";
    }];
    
    return YES;
}

+ (BOOL)deleteCRClassAccountFromID:(NSString *)ID{
    if( ![CRClassDatabase haveCRClassAccount:ID] ) return YES;
    
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithArray:[CRClassDatabase selectAccountFromAll]];
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        NSArray *account = (NSArray *)obj;
        if( [account[1] isEqualToString:ID] )
            [accounts removeObjectAtIndex:index];
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:accounts forKey:CRClassAccountDataBaseKEY];
    
    return YES;
}

+ (BOOL)dropCRClassAccount{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CRClassAccountDataBaseKEY];
    return YES;
}

+ (CRClassAccount *)selectCRClassAccountFromID:(NSString *)ID{
    NSArray *accounts = [CRClassDatabase selectAccountFromAll];
    __block CRClassAccount *classAccount;
    
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        NSArray *account = (NSArray *)obj;
        if( [account[1] isEqualToString:ID] ){
            
            classAccount = [CRClassDatabase CRClassAccountFromRow:account];
            *sS = YES;
        }
    }];
    
    return classAccount;
}

+ (CRClassAccount *)selectCRClassAccountFromCurrent{
    NSArray *accounts = [CRClassDatabase selectAccountFromAll];
    __block CRClassAccount *current;
    
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        NSArray *account = (NSArray *)obj;
        if( [account.firstObject isEqualToString:@"YES"] ){
            
            current = [CRClassDatabase CRClassAccountFromRow:account];
            *sS = YES;
        }
    }];
    
    return current;
}

+ (BOOL)insertCRClassAccount:(CRClassAccount *)account{
    
    if( [CRClassDatabase haveCRClassAccount:account.ID] ) return NO;
    
    NSArray *row = [CRClassDatabase rowFromCRClassAccount:account];
    
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithArray:[self selectAccountFromAll]];
    [accounts addObject:row];

    [[NSUserDefaults standardUserDefaults] setObject:accounts forKey:CRClassAccountDataBaseKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
// CRClassAccount database end

@end
