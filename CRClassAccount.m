//
//  CRClassAccount.m
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassAccount.h"

@implementation CRClassAccount

+ (instancetype)accountFromDefault{
    return [[CRClassAccount alloc] initFromDictionary:@{
                                                        CRClassAccountCurrentKEY: CRClassAccountCurrentYESKEY,
                                                        CRClassAccountIDKEY: @"Default",
                                                        CRClassAccountColorTypeKEY: @"default"
                                                        }];
}

+ (instancetype)accountFromDictionary:(NSDictionary *)dic{
    return [[CRClassAccount alloc] initFromDictionary:dic];
}

- (instancetype)initFromDictionary:(NSDictionary *)dic{
    self = [super init];
    if( self ){
        self.current = dic[CRClassAccountCurrentKEY];
        self.ID = dic[CRClassAccountIDKEY];
        self.colorType = dic[CRClassAccountColorTypeKEY];
    }
    return self;
}

@end
