//
//  CRClassAccount.h
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const CRClassAccountCurrentYESKEY = @"CRClassAccountCurrentYESKey";
static NSString *const CRClassAccountCurrentNOKEY = @"CRClassAccountCurrentNOKey";
static NSString *const CRClassAccountCurrentKEY = @"CRClassAccountCurrentKey";
static NSString *const CRClassAccountIDKEY = @"CRClassAccountIDKey";
static NSString *const CRClassAccountColorTypeKEY = @"CRClassAccountColorTypeKey";

@interface CRClassAccount : NSObject

@property( nonatomic, strong ) NSString *current;
@property( nonatomic, strong ) NSString *ID;
@property( nonatomic, strong ) NSString *colorType;

+ (instancetype)accountFromDefault;
+ (instancetype)accountFromDictionary:(NSDictionary *)dic;

@end
