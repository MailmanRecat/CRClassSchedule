//
//  CRClassScheduleEditModel.h
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRClassSchedule.h"

@interface CRClassScheduleEditModel : UIViewController

@property( nonatomic, strong ) CRClassSchedule *classSchedule;

- (void)bearBottomLayout:(CGFloat)constant;

@end
