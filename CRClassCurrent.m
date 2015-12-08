//
//  CRClassCurrent.m
//  CRClassSchedule
//
//  Created by caine on 12/8/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassCurrent.h"
#import "CRClassDatabase.h"

@implementation CRClassCurrent

+ (CRClassAccount *)account{
    return [CRClassDatabase selectCRClassAccountFromCurrent];
}

@end
