//
//  UIWindow+CRAction.h
//  CRClassSchedule
//
//  Created by caine on 12/15/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRActionView.h"

@interface UIWindow (CRAction)

//@property( nonatomic, strong ) NSLayoutConstraint *guide;

- (void)actionRemoveWithHandler:(id<CRActionHandler>)handler;
- (void)actionDeleteWithHandler:(id<CRActionHandler>)handler;

- (void)endAction;

@end
