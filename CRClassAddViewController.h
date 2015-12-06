//
//  CRClassAddViewController.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import <UIKit/UIKit.h>
#import "CRClassSchedule.h"

@interface CRClassAddViewController : UIViewController

@property( nonatomic, strong ) CRClassSchedule *classSchedule;

@property( nonatomic, assign ) BOOL isPreview;

+ (instancetype)shareFromClassSchedule:(CRClassSchedule *)classSchedule;
- (instancetype)initFromClassSchedule:(CRClassSchedule *)classSchedule;

- (void)editModel:(BOOL)edit;

- (void)showDismissButton;
- (void)makeBorder;
- (void)makeClearBorder;

@end
