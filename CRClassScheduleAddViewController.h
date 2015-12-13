//
//  CRClassScheduleAddViewController.h
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRClassSchedule.h"

@protocol CRClassAddViewControllerPreviewActionHandler <NSObject>

- (void)CRClassAddPreviewAction:(NSString *)type fromController:(UIViewController *)controller;

@end

@interface CRClassScheduleAddViewController : UIViewController

@property( nonatomic, weak ) id<CRClassAddViewControllerPreviewActionHandler> previewActionHandler;
@property( nonatomic, strong ) CRClassSchedule *classSchedule;

@property( nonatomic, assign ) NSUInteger type;
@property( nonatomic, assign ) BOOL isPreview;

- (void)perferItem:(UIButton *)sender;
- (void)perferRightButtonColor:(UIColor *)color;

@end
