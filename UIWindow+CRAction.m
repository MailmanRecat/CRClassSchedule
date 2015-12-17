//
//  UIWindow+CRAction.m
//  CRClassSchedule
//
//  Created by caine on 12/15/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "UIWindow+CRAction.h"
#import "UIView+CRLayout.h"
#import "CRSettings.h"

@implementation UIWindow (CRAction)

- (void)actionRemoveWithHandler:(id<CRActionHandler>)handler{
    [self action:({
        
        CRActionView *mask = [[CRActionView alloc] initWithRemove];
        mask.translatesAutoresizingMaskIntoConstraints = NO;
        mask.handler = handler;
        mask.tag = 7777;
        [self addSubview:mask];
        [CRLayout view:@[ mask, self ] type:CREdgeAround];
        [self layoutIfNeeded];
        mask;
        
    })];

}

- (void)actionDeleteWithHandler:(id<CRActionHandler>)handler{
    [self action:({
        
        CRActionView *mask = [[CRActionView alloc] initWithDelete];
        mask.translatesAutoresizingMaskIntoConstraints = NO;
        mask.handler = handler;
        mask.tag = 7777;
        [self addSubview:mask];
        [CRLayout view:@[ mask, self ] type:CREdgeAround];
        [self layoutIfNeeded];
        mask;
        
    })];
}

- (void)action:(CRActionView *)view{
    view.alpha = 0;
    view.guide.constant = 30;
    
    [UIView animateWithDuration:0.37f
                          delay:0.0f
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.9
                        options:( 7 << 16 )
                     animations:^{
                         
                         view.alpha = 1;
                         [view layoutIfNeeded];
                         
                     }completion:nil];
    
}

- (void)endAction{
    CRActionView *mask = [self viewWithTag:7777];
    mask.guide.constant = 186;
    
    [UIView animateWithDuration:0.37f
                          delay:0.0f
         usingSpringWithDamping:0.77
          initialSpringVelocity:0.77
                        options:( 7 << 16 )
                     animations:^{
                         
                         mask.alpha = 0;
                         [mask layoutIfNeeded];
                         
                     }completion:^(BOOL f){
                         
                         if( f )
                             [mask removeFromSuperview];
                     }];
}

@end
