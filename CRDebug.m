//
//  CRDebug.m
//  CRClassSchedule
//
//  Created by caine on 12/18/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRDebug.h"

@interface CRDebug()

@property( nonatomic, assign ) BOOL debug;

@end

@implementation CRDebug

+ (instancetype)app{
    static CRDebug *instance = nil;
    
    static dispatch_once_t onceTakon;
    dispatch_once(&onceTakon, ^{
        instance = [CRDebug new];
        instance.debug = CRAppDebug;
    });
    return instance;
}

+ (void)debug:(BOOL)db{
    [CRDebug app].debug = db;
}

+ (BOOL)isDebug{
    return [CRDebug app].debug;
}

@end
