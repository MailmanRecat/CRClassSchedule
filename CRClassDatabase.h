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

+ (BOOL)insertCRClassSchedule:(CRClassSchedule *)schedule;

+ (NSArray *)selectClassFromUserName:(NSString *)name;


+ (BOOL)haveCRClassAccount:(NSString *)ID;
+ (BOOL)changeCRClassAccountCurrent:(CRClassAccount *)account;
+ (BOOL)insertCRClassAccount:(CRClassAccount *)account;
+ (BOOL)deleteCRClassAccountFromID:(NSString *)ID;
+ (BOOL)dropCRClassAccount;
+ (NSArray *)selectClassAccountFromAll;
+ (CRClassAccount *)selectCRClassAccountFromID:(NSString *)ID;
+ (CRClassAccount *)selectCRClassAccountFromCurrent;


@end
