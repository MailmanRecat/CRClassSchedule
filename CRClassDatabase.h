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
+ (BOOL)insertCRClassAccount:(CRClassAccount *)account;

+ (NSArray *)selectClassFromUserName:(NSString *)name;

+ (CRClassAccount *)selectCRClassAccountFromID:(NSString *)ID;


@end
