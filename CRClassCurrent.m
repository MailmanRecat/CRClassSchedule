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
    CRClassAccount *account = [CRClassDatabase selectCRClassAccountFromCurrent];
    if( !account ){
        account = [CRClassAccount accountFromDefault];
        [CRClassDatabase insertCRClassAccount:account];
    }
    
    return account;
}

+ (NSArray *)classSchedule{
    
    NSString *user = [CRClassCurrent account].ID;
    return [CRClassDatabase selectCRClassScheduleFromUser:user];
}

@end
