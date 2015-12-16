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

- (void)actionRemove{
    [self makeMask];
}

- (void)makeMask{
    CGFloat height = 48 * 3 + 12 + 30;
    
    UIButton *mask = ({
        UIButton *mask = [UIButton new];
        mask.translatesAutoresizingMaskIntoConstraints = NO;
        mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.37];
        mask.alpha = 0;
        mask;
    });
    [self addSubview:mask];
    
    [CRLayout view:@[ mask, self ] type:CREdgeAround];
    
    UIView *actionView = [self makeActions:@[ @"Are you sure you want to delete this schedule?", @"Delete", @"Cancel" ]];
    actionView.translatesAutoresizingMaskIntoConstraints = NO;
    [mask addSubview:actionView];
    
    actionView.backgroundColor = [UIColor whiteColor];
    [CRLayout view:@[ actionView, mask ] type:CREdgeLeftRight constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ actionView ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, height, 0, 0)];
    
    NSLayoutConstraint *guide = [CRLayout view:@[ mask, actionView ]
                                     attribute:NSLayoutAttributeBottom
                                      relateBy:NSLayoutRelationEqual
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:-height];
//    self.guide = guide;
    [mask addConstraint:guide];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.57f
                          delay:0.0f
         usingSpringWithDamping:0.77
          initialSpringVelocity:0.77
                        options:( 7 << 16 )
                     animations:^{
                         guide.constant = -30;
                         mask.alpha = 1;
                         [mask layoutIfNeeded];
                     }completion:^(BOOL f){
                         
                     }];

}

- (void)close{
}

- (UIView *)makeActions:(NSArray<NSString *> *)items{
    CGFloat heightOfAction = 48;
    
    UIView *bear = [UIView new];
    bear.translatesAutoresizingMaskIntoConstraints = NO;
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *sS){
        if( index == 0 ){
            
            UILabel *title = ({
                UILabel *title = [UILabel new];
                title.translatesAutoresizingMaskIntoConstraints = NO;
                title.adjustsFontSizeToFitWidth = YES;
                title.text = (NSString *)obj;
                title.textColor = [UIColor colorWithWhite:133 / 255.0 alpha:1];
                title.font = [CRSettings appFontOfSize:13 weight:UIFontWeightRegular];
                title;
            });
            [bear addSubview:title];
            [CRLayout view:@[ title, bear ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(12, 56, 0, -16)];
            [CRLayout view:@[ title ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 48, 0, 0)];
            
        }else{
            
            UIButton *action;
            action = ({
                UIButton *action = [UIButton new];
                action.translatesAutoresizingMaskIntoConstraints = NO;
                action.tag = 1000 + index;
                action.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                action.titleLabel.font = [CRSettings appFontOfSize:15 weight:UIFontWeightRegular];
                [action setTitle:(NSString *)obj forState:UIControlStateNormal];
                [action setTitleColor:[UIColor colorWithWhite:57 / 255.0 alpha:1] forState:UIControlStateNormal];
                [action addTarget:self action:@selector(handerAction:) forControlEvents:UIControlEventTouchUpInside];
                action;
            });
            [bear addSubview:action];
            
            [CRLayout view:@[ action, bear ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(index * heightOfAction, 32, 0, -32)];
            [CRLayout view:@[ action ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, heightOfAction, 0, 0)];
        }
    }];
    
    return bear;
}

- (void)handerAction:(UIButton *)sender{
    NSLog(@"%ld", sender.tag - 1000);
}

@end
