//
//  CRClassDatabase.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassDatabase.h"

static NSString *const CRClassScheduleIDKey = @"CRClassScheduleIDKey";
static NSString *const CRClassScheduleDatabaseKey = @"CRClassScheduleDatabaseKey";

static NSString *const CRClassAccountDataBaseKEY = @"CRCLASSACCOUNTDATABASEKEY";

@interface CRClassDatabase()

@end

@implementation CRClassDatabase

//CRClassSchedule datebase begin
+ (NSString *)CRClassScheduleDatabaseKeyFromUser:(NSString *)user{
    return [NSString stringWithFormat:@"%@%@", user, CRClassScheduleDatabaseKey];
}

+ (NSString *)CRClassScheduleIDKeyFromUser:(NSString *)user{
    NSString *key = [NSString stringWithFormat:@"%@%@", user, CRClassScheduleIDKey];
    
    NSUInteger scheduleID = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    [[NSUserDefaults standardUserDefaults] setInteger:++scheduleID forKey:key];
    
    return [NSString stringWithFormat:@"%@%ld", user, scheduleID];
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
                                                          ClassScheduleTeacher: row[6],
                                                          ClassScheduleTimeLong: row[7],
                                                          ClassScheduleColorType: row[8],
                                                          ClassScheduleUserInfo: row[9],
                                                          ClassScheduleType: row[10]
                                                          }];
}

+ (NSArray *)selectCRClassScheduleFromUser:(NSString *)user{
    NSString *KEY = [CRClassDatabase CRClassScheduleDatabaseKeyFromUser:user];
    NSMutableArray *schedules = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KEY]];
    if( [schedules count] != 7 ){
        schedules = [NSMutableArray new];
        for( int i = 0; i < 7; i++ ){
            schedules[i] = [NSMutableArray new];
        }
    }

    return schedules;
}

+ (BOOL)insertCRClassSchedule:(CRClassSchedule *)schedule{
    NSMutableArray *schedules = [[NSMutableArray alloc] initWithArray:[CRClassDatabase selectCRClassScheduleFromUser:schedule.user]];
    schedule.scheduleID = [CRClassDatabase CRClassScheduleIDKeyFromUser:schedule.user];

    NSArray *class = [CRClassDatabase rowFromCRClassSchedule:schedule];
    NSString *weekday = [schedule.weekday lowercaseString];
    NSUInteger target;
    if( [weekday isEqualToString:@"sunday"]  ){
        target = 6;
    }else if( [weekday isEqualToString:@"monday"] ){
        target = 0;
    }else if( [weekday isEqualToString:@"tuesday"] ){
        target = 1;
    }else if( [weekday isEqualToString:@"wednesday"] ){
        target = 2;
    }else if( [weekday isEqualToString:@"thursday"] ){
        target = 3;
    }else if( [weekday isEqualToString:@"friday"] ){
        target = 4;
    }else if( [weekday isEqualToString:@"saturday"] ){
        target = 5;
    }else{
        return NO;
    }
    
    NSMutableArray *bridge = [[NSMutableArray alloc] initWithArray:schedules[target]];
    [bridge addObject:class];
    NSArray *sortedSchedule = [CRClassDatabase sortCRClassScheduleByTime:bridge];
    [schedules replaceObjectAtIndex:target withObject:sortedSchedule];
    
    [[NSUserDefaults standardUserDefaults] setObject:schedules forKey:[CRClassDatabase CRClassScheduleDatabaseKeyFromUser:schedule.user]];
    
    return YES;
}

+ (BOOL)deleteCRClassSchedule:(CRClassSchedule *)schedule{
    NSMutableArray *schedules = [[NSMutableArray alloc] initWithArray:[CRClassDatabase selectCRClassScheduleFromUser:schedule.user]];
    
    NSUInteger target = 0;
    NSString *weekday = [schedule.weekday lowercaseString];
    if( [weekday isEqualToString:@"sunday"]  ){
        target = 6;
    }else if( [weekday isEqualToString:@"monday"] ){
        target = 0;
    }else if( [weekday isEqualToString:@"tuesday"] ){
        target = 1;
    }else if( [weekday isEqualToString:@"wednesday"] ){
        target = 2;
    }else if( [weekday isEqualToString:@"thursday"] ){
        target = 3;
    }else if( [weekday isEqualToString:@"friday"] ){
        target = 4;
    }else if( [weekday isEqualToString:@"saturday"] ){
        target = 5;
    }else{
        return NO;
    }
    
    __block NSMutableArray *bridge = [[NSMutableArray alloc] initWithArray:schedules[target]];
    [bridge enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        NSArray *s = (NSArray *)obj;
        if( [(NSString *)s[0] isEqualToString:schedule.scheduleID] ){
            [bridge removeObjectAtIndex:index];
        }
    }];
    [schedules replaceObjectAtIndex:target withObject:bridge];
    
    [[NSUserDefaults standardUserDefaults] setObject:schedules forKey:[CRClassDatabase CRClassScheduleDatabaseKeyFromUser:schedule.user]];
    
    return YES;
}

+ (BOOL)dropCRClassScheduleFromUser:(NSString *)user{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[CRClassDatabase CRClassScheduleDatabaseKeyFromUser:user]];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", user, CRClassScheduleIDKey];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    
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
