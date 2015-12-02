//
//  CRClassDatabase.h
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRClassSchedule.h"

@interface CRClassDatabase : NSObject

+ (BOOL)insert:(CRClassSchedule *)schedule;
+ (NSArray *)selectClassFromWeekday:(NSString *)day;

@end
