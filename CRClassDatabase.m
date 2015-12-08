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
