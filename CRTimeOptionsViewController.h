//
//  CRTimeOptionsViewController.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRTimeOptionsVCHandler <NSObject>

- (void)CRTimeOptionsVCDidDismissWithOption:(NSString *)option;

@end

@interface CRTimeOptionsViewController : UIViewController

@property( nonatomic, weak ) id<CRTimeOptionsVCHandler> handler;

@property( nonatomic, assign ) NSUInteger selectedHour;
@property( nonatomic, assign ) NSUInteger selectedMins;

@end
