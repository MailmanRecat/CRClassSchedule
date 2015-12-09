//
//  CRClassSchedule.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ClassScheduleInvalidID = @"ClassScheduleInvalidID";
static NSString *const ClassScheduleID = @"ClassScheduleID";
static NSString *const ClassScheduleUser = @"ClassScheduleUser";
static NSString *const ClassScheduleWeekday = @"ClassScheduleWeekday";
static NSString *const ClassScheduleTimeStart = @"ClassScheduleTimeStart";
static NSString *const ClassScheduleLocation = @"ClassScheduleLocation";
static NSString *const ClassScheduleClassname = @"ClassScheduleClassname";
static NSString *const ClassScheduleTeacher = @"ClassScheduleTeacher";
static NSString *const ClassScheduleTimeLong = @"ClassScheduleTimeLong";
static NSString *const ClassScheduleColorType = @"ClassScheduleColorType";
static NSString *const ClassScheduleUserInfo = @"ClassScheduleUserInfo";
static NSString *const ClassScheduleType = @"ClassScheduleType";

@interface CRClassSchedule : NSObject

@property( nonatomic, strong ) NSString *scheduleID;
@property( nonatomic, strong ) NSString *user;
@property( nonatomic, strong ) NSString *weekday;
@property( nonatomic, strong ) NSString *timeStart;
@property( nonatomic, strong ) NSString *location;
@property( nonatomic, strong ) NSString *classname;
@property( nonatomic, strong ) NSString *teacher;
@property( nonatomic, strong ) NSString *timeLong;
@property( nonatomic, strong ) NSString *colorType;
@property( nonatomic, strong ) NSString *userInfo;
@property( nonatomic, strong ) NSString *type;

- (instancetype)initFromDictionary:(NSDictionary *)dictionary;
+ (instancetype)ClassScheduleFromDictionary:(NSDictionary *)dictionary;
+ (instancetype)ClassCreateTempleSchedule;

@end
