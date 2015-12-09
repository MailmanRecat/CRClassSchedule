//
//  CRClassDatabase.h
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRClassSchedule.h"
#import "CRClassAccount.h"

@interface CRClassDatabase : NSObject

//test
+ (NSArray *)sortCRClassScheduleByTime:(NSArray *)schedules;

//CRClassSchedule Database func start
+ (BOOL)dropCRClassScheduleFromUser:(NSString *)user;
+ (BOOL)insertCRClassSchedule:(CRClassSchedule *)schedule;
+ (BOOL)deleteCRClassSchedule:(CRClassSchedule *)schedule;
+ (NSArray *)selectCRClassScheduleFromUser:(NSString *)user;
//CRClassSchedule Databse func end

//CRClassAccount Database func start
+ (BOOL)haveCRClassAccount:(NSString *)ID;
+ (BOOL)changeCRClassAccountCurrent:(CRClassAccount *)account;
+ (BOOL)insertCRClassAccount:(CRClassAccount *)account;
+ (BOOL)deleteCRClassAccountFromID:(NSString *)ID;
+ (BOOL)dropCRClassAccount;
+ (NSArray *)selectClassAccountFromAll;
+ (CRClassAccount *)selectCRClassAccountFromID:(NSString *)ID;
+ (CRClassAccount *)selectCRClassAccountFromCurrent;
//CRClassAccount Databse func end


@end
