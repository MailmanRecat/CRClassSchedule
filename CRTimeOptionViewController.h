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

@protocol CRTimeOptionVCHandler <NSObject>

- (void)CRTimeOptionVCDidDismissWithType:(CRTimeOptionType)type option:(NSString *)option;

@end

@interface CRTimeOptionViewController : UIViewController

@property( nonatomic, weak ) id<CRTimeOptionVCHandler> handler;
@property( nonatomic, assign ) CRTimeOptionType type;
@property( nonatomic, assign ) NSUInteger weekday;
@property( nonatomic, assign ) NSUInteger mins;

@property( nonatomic, strong ) UIColor *themeColor;

@end
