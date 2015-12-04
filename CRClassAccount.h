//
//  CRClassAccount.h
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const CRClassAccountIDKEY = @"CRClassAccountIDKey";
static NSString *const CRClassAccountColorTypeKEY = @"CRClassAccountColorTypeKey";

@interface CRClassAccount : NSObject

@property( nonatomic, strong ) NSString *ID;
@property( nonatomic, strong ) NSString *colorType;

- (instancetype)initFromDictionary:(NSDictionary *)dic;

@end
