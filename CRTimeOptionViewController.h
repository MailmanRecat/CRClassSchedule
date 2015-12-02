//
//  CRTimeOptionViewController.h
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CRTimeOptionType){
    CRTimeOptionTypeClassmins = 0,
    CRTimeOptionTypeWeekday
};

static NSString *const CRTimeOptionDidSelectedNotificationKey = @"CRTimeOptionDidSelectedNotificationKey";
static NSString *const CRTimeOptionStringKey = @"CRTimeStringKey";
static NSString *const CRTimeOptionTypeKey = @"CRTimeOptionTypekey";

@interface CRTimeOptionViewController : UIViewController

@property( nonatomic, assign ) CRTimeOptionType type;

@end
