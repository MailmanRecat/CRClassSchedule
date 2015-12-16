//
//  CRActionWindow.h
//  CRClassSchedule
//
//  Created by caine on 12/14/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRActionWindowDelegate <NSObject>

- (BOOL)actionShouldCancel;

@end

@interface CRActionWindow : UIWindow

@property( nonatomic, weak ) id<CRActionWindowDelegate> delegate;

+ (void)openWindow;
+ (void)closeWindow;

@end
