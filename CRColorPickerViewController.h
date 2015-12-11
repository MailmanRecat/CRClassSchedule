//
//  CRColorPickerViewController.h
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRColorPickerViewControllerHandler <NSObject>

@optional
- (void)colorPickerDismissCompleted:(UIColor *)color name:(NSString *)name;

@end

@interface CRColorPickerViewController : UIViewController

@property( nonatomic, weak ) id<CRColorPickerViewControllerHandler> handler;

@end
