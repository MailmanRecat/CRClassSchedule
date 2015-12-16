//
//  CRActionWindow.m
//  CRClassSchedule
//
//  Created by caine on 12/14/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRActionWindow.h"

#import "CRSettings.h"
#import "UIView+CRLayout.h"

@interface CRActionWindow()

@property( nonatomic, strong ) UIView *rootView;
@property( nonatomic, strong ) NSLayoutConstraint *guide;
@property( nonatomic, strong ) NSString *title;
@property( nonatomic, strong ) NSArray<NSString *> *items;

@end

static CRActionWindow *actionWindow;

@implementation CRActionWindow

- (instancetype)initWithFrame:(CGRect)frame{
    return [super initWithFrame:frame];
}

+ (void)openWindow{
    if( actionWindow == nil ){
        actionWindow = [[CRActionWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        actionWindow.hidden = YES;
        actionWindow.windowLevel = UIWindowLevelStatusBar + 10;
        actionWindow.backgroundColor = [UIColor colorWithWhite:33 / 255.0 alpha:0.7];
    }
    
    UIView *actionView = [actionWindow makeActions:@[ @"Are you sure you want to delete this schedule?", @"Delete", @"Cancel" ]];
    
    [actionWindow addSubview:actionView];
    
    CGFloat height = 48 * 3 + 12 + 30;
    
    actionWindow.rootView = actionView;
    
    actionView.backgroundColor = [UIColor whiteColor];
    [CRLayout view:@[ actionView, actionWindow ] type:CREdgeLeftRight constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ actionView ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, height, 0, 0)];
    
    NSLayoutConstraint *guide = [CRLayout view:@[ actionWindow, actionView ]
                                     attribute:NSLayoutAttributeBottom
                                      relateBy:NSLayoutRelationEqual
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:-height];
    [actionWindow addConstraint:guide];
    [actionWindow layoutIfNeeded];
    
    [actionWindow makeKeyAndVisible];
    actionWindow.hidden = NO;
    actionWindow.alpha = 0;
    actionWindow.guide = guide;
    [UIView animateWithDuration:0.57f
                          delay:0.0f
         usingSpringWithDamping:0.77
          initialSpringVelocity:0.77
                        options:( 7 << 16 )
                     animations:^{
                         guide.constant = -30;
                         actionWindow.alpha = 1;
                         
                         [actionWindow layoutIfNeeded];
                     }completion:^(BOOL f){
                         
                     }];
}

+ (void)closeWindow{
//    if( actionWindow ){
//        [UIView animateWithDuration:0.17f animations:^{
//            actionWindow.alpha = 0.0f;
//        }completion:^(BOOL f){
//            
//            [actionWindow resignKeyWindow];
//            actionWindow.hidden = YES;
//            actionWindow = nil;
//        }];
//    }
    
    [UIView animateWithDuration:0.57f
                          delay:0.0f
         usingSpringWithDamping:0.77
          initialSpringVelocity:0.77
                        options:( 7 << 16 )
                     animations:^{
                         actionWindow.guide.constant = -(48 * 3 + 12 + 30);
                         
                         actionWindow.alpha = 0.0f;
                         
                         [actionWindow layoutIfNeeded];
                     }completion:^(BOOL f){
                         [actionWindow resignKeyWindow];
                         actionWindow.hidden = YES;
                         actionWindow = nil;
                     }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BOOL shouldCancel;
    if( self.delegate && [self.delegate respondsToSelector:@selector(actionShouldCancel)] )
        shouldCancel = [self.delegate actionShouldCancel];
    else
        shouldCancel = YES;
    
    [CRActionWindow closeWindow];
}

- (void)handerAction:(UIButton *)sender{
    NSLog(@"%ld", sender.tag - 1000);
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

@end
