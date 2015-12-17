//
//  CRActionView.m
//  CRClassSchedule
//
//  Created by caine on 12/16/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRActionView.h"
#import "UIView+CRLayout.h"
#import "CRSettings.h"
#import "UIWindow+CRAction.h"

@interface CRActionView()

@end

@implementation CRActionView

- (instancetype)initWithDelete{
    return [self initClass:@[ @"Are you sure you want to delete this schedule?", @"Delete", @"Cancel" ]];
}

- (instancetype)initWithRemove{
    return [self initClass:@[ @"Are you sure you want to remove this account?", @"Remove", @"Cancel" ]];
}

- (instancetype)initClass:(NSArray *)items{
    self = [super init];
    if( self ){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.37];
        
        UIView *action = [self makeAction:items];
        action.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:action];
        
        CGFloat height = 48 * ( [items count] ) + 12 + 30;
        
        [CRLayout view:@[ action, self ] type:CREdgeLeftRight constants:UIEdgeInsetsMake(0, 0, 0, 0)];
        [CRLayout view:@[ action ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, height, 0, 0)];
        
        NSLayoutConstraint *guide = [CRLayout view:@[ action, self ]
                                         attribute:NSLayoutAttributeBottom
                                          relateBy:NSLayoutRelationEqual
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:height];
        [self addConstraint:guide];
        self.guide = guide;
    }
    return self;
}

- (void)handerAction:(UIButton *)sender{
    if( sender.tag == 1001 ){
        if( self.handler && [self.handler respondsToSelector:@selector(actionConfrim:)] )
            [self.handler actionConfrim:sender.titleLabel.text];
        [self.window endAction];
    }else
        [self.window endAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.window endAction];
}

- (UIView *)makeAction:(NSArray *)items{
    CGFloat heightOfAction = 48;
    
    UIView *bear = [UIView new];
    bear.translatesAutoresizingMaskIntoConstraints = NO;
    bear.backgroundColor = [UIColor whiteColor];
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
            
            UIColor *colo = [UIColor colorWithWhite:57 / 255.0 alpha:1];
            if( index == 1 )
                colo = [UIColor colorWithRed:210 / 255.0 green:9 / 255.0 blue:21 / 255.0 alpha:1];
            
            UIButton *action;
            action = ({
                UIButton *action = [UIButton new];
                action.translatesAutoresizingMaskIntoConstraints = NO;
                action.tag = 1000 + index;
                action.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                action.titleLabel.font = [CRSettings appFontOfSize:15 weight:UIFontWeightRegular];
                [action setTitle:(NSString *)obj forState:UIControlStateNormal];
                [action setTitleColor:colo forState:UIControlStateNormal];
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
