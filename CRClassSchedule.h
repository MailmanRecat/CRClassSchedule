//
//  CRClassSchedule.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRClassSchedule : NSObject

@property( nonatomic, strong ) NSString *weekday;
@property( nonatomic, strong ) NSString *timeStart;
@property( nonatomic, strong ) NSString *location;
@property( nonatomic, strong ) NSString *classname;
@property( nonatomic, strong ) NSString *teacher;
@property( nonatomic, strong ) NSString *timeLong;
@property( nonatomic, strong ) NSString *colorStyle;
@property( nonatomic, strong ) NSString *userInfo;
@property( nonatomic, strong ) NSString *type;

@end
