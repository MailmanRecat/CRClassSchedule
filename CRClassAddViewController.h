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

typedef NS_ENUM(NSUInteger, CRViewModel){
    CRViewModelDefault = 0,
    CRViewModelEdit
};

@protocol CRClassAddViewControllerPreviewActionHandler <NSObject>

- (void)CRClassAddPreviewAction:(NSString *)type fromController:(UIViewController *)controller;

@end

@interface CRClassAddViewController : UIViewController

@property( nonatomic, weak ) id<CRClassAddViewControllerPreviewActionHandler> previewActionHandler;

@property( nonatomic, strong ) CRClassSchedule *classSchedule;
@property( nonatomic, assign ) CRViewModel model;

@property( nonatomic, assign ) BOOL isPreview;

+ (instancetype)shareFromClassSchedule:(CRClassSchedule *)classSchedule ViewModel:(CRViewModel)model;
+ (instancetype)shareFromClassSchedule:(CRClassSchedule *)classSchedule;

- (void)showDismissButton;

@end
