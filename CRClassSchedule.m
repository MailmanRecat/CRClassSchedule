//
//  CRClassSchedule.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassSchedule.h"
#import "CRClassCurrent.h"
#import "CRSettings.h"

@implementation CRClassSchedule

- (instancetype)initFromDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if( self ){
        self.scheduleID = dictionary[ClassScheduleID];
        self.user = dictionary[ClassScheduleUser];
        self.weekday = dictionary[ClassScheduleWeekday];
        self.timeStart = dictionary[ClassScheduleTimeStart];
        self.location = dictionary[ClassScheduleLocation];
        self.classname = dictionary[ClassScheduleClassname];
        self.teacher = dictionary[ClassScheduleTeacher];
        self.timeLong = dictionary[ClassScheduleTimeLong];
        self.colorType = dictionary[ClassScheduleColorType];
        self.userInfo = dictionary[ClassScheduleUserInfo];
        self.type = dictionary[ClassScheduleType];
    }
    return self;
}

+ (instancetype)ClassScheduleFromDictionary:(NSDictionary *)dictionary{
    return [[CRClassSchedule alloc] initFromDictionary:dictionary];
}

+ (instancetype)ClassCreateTempleSchedule{
    return [[CRClassSchedule alloc] initFromDictionary:@{
                                                         ClassScheduleID: ClassScheduleInvalidID,
                                                         ClassScheduleUser: [CRClassCurrent account].ID,
                                                         ClassScheduleWeekday: [CRSettings weekday],
                                                         ClassScheduleTimeStart: @"07:00",
                                                         ClassScheduleLocation: @"Location",
                                                         ClassScheduleClassname: @"Class name",
                                                         ClassScheduleTeacher: @"Teacher",
                                                         ClassScheduleTimeLong: @"40 mins",
                                                         ClassScheduleColorType: @"Default",
                                                         ClassScheduleUserInfo: @"Add note",
                                                         ClassScheduleType: @"type for feathure"
                                                         }];
}

@end
