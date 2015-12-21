//
//  CRDebug.h
//  CRClassSchedule
//
//  Created by caine on 12/18/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CRAppDebug NO

#import <Foundation/Foundation.h>

@interface CRDebug : NSObject

+ (void)debug:(BOOL)db;
+ (BOOL)isDebug;

@end
