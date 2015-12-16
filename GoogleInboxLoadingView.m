//
//  GoogleInboxLoadingView.m
//  dome12715
//
//  Created by caine on 8/8/15.
//  Copyright (c) 2015 com.caine. All rights reserved.
//

#import "GoogleInboxLoadingView.h"

@interface GoogleInboxLoadingView ()

@property( nonatomic, strong ) UIView             *Bear;
@property( nonatomic, assign ) BOOL                nowFucking;
@property( nonatomic, assign ) BOOL                shouldDoFuck;
@property( nonatomic, assign ) BOOL                useWhite;
@property( nonatomic, strong ) NSLayoutConstraint *target;
@property( nonatomic, assign ) NSUInteger          index;

@property( nonatomic, strong ) UIColor            *defaultColor;

@property( nonatomic, strong ) NSLayoutConstraint *testZero;
@property( nonatomic, strong ) NSLayoutConstraint *testEdge;

@end

@implementation GoogleInboxLoadingView

- (instancetype)init{
    
    self = [super init];
    if( !self )
        return self;
    
    [self makeBear];
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if( !self )
        return self;

    [self makeBear];
    
    return self;
}

- (void)defaultColor:(UIColor *)color{
    
    self.backgroundColor = self.defaultColor = color;
    
}

- (void)makeBear{
    
    UIColor *blue    = [UIColor colorWithRed:56 / 255.0 green:135 / 251.0 blue:255 / 255.0 alpha:1];
    UIColor *red     = [UIColor colorWithRed:252 / 255.0 green:55 / 255.0 blue:48 / 255.0 alpha:1];
    UIColor *yollow  = [UIColor colorWithRed:253 / 255.0 green:186 / 255.0 blue:44 / 255.0 alpha:1];
    UIColor *green   = [UIColor colorWithRed:48 / 255.0 green:176 / 255.0 blue:81 / 255.0 alpha:1];
    
    self.colors = @[ blue, red, yollow, green ];
    self.backgroundColor = self.defaultColor = [UIColor whiteColor];
    
    self.duration = 1.0f;
    
    _Bear = [UIView new];
    [_Bear setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:_Bear];
    
    [self addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_Bear to:self type:EdgeCenterXY]];
    [self addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_Bear to:self type:EdgeTopBottomZero]];
    [_Bear addConstraints:[NSLayoutConstraint SpactecledBearFixed:_Bear type:SpactecledBearFixedWidth constant:0]];
    _Bear.backgroundColor = self.colors ? self.colors[0] : [UIColor whiteColor];
    
//    _testZero = [NSLayoutConstraint constraintWithItem:_Bear
//                                             attribute:NSLayoutAttributeWidth
//                                             relatedBy:NSLayoutRelationEqual
//                                                toItem:nil
//                                             attribute:NSLayoutAttributeNotAnAttribute
//                                            multiplier:1.0
//                                              constant:0];
//    
//    _testEdge = [NSLayoutConstraint constraintWithItem:_Bear
//                                             attribute:NSLayoutAttributeWidth
//                                             relatedBy:NSLayoutRelationEqual
//                                                toItem:self
//                                             attribute:NSLayoutAttributeWidth
//                                            multiplier:1.0
//                                              constant:0];
//    [_Bear addConstraint:_testZero];
    
}

- (void)doFuck{
    
    if( _nowFucking )
        return;
    
    if( _target == nil ){
        for( NSLayoutConstraint *con in [_Bear constraints] ){
            if( con.firstAttribute == NSLayoutAttributeWidth ){
                _target = con;
                break;
            }
        }
    }
    
//    [_Bear removeConstraint:_testZero];
//    [self addConstraint:_testEdge];
    [UIView animateWithDuration: self.duration animations:^{
        
        _nowFucking = YES;
        _target.constant = self.frame.size.width;
        [self layoutIfNeeded];
        
    }completion:^( BOOL isFinished ){
        
        _nowFucking = NO;
        
        _target.constant = 0;
//        [self removeConstraint:_testEdge];
//        [_Bear addConstraint:_testZero];
        
        [self layoutIfNeeded];
        
        self.backgroundColor = _colors[ _index ];
    
        if( _index == [_colors count] - 1 )
            _index = 0;
        else
            _index++;
        
        _Bear.backgroundColor = _colors[ _index ];
        
        if( _shouldDoFuck ){
            
            [self doFuck];
            
        }else{
            
            [self onceWithColor:_defaultColor];
            
        }
        
    }];

}

- (void)onceWithColor:(UIColor *)color{
    
    if( _nowFucking )
        return;
    
    if( _target == nil ){
        for( NSLayoutConstraint *con in [_Bear constraints] ){
            if( con.firstAttribute == NSLayoutAttributeWidth ){
                _target = con;
                break;
            }
        }
    }

    _Bear.backgroundColor = color;
    [UIView animateWithDuration: self.duration animations:^{
        
        _nowFucking = YES;
        _target.constant = self.frame.size.width;
        [self layoutIfNeeded];
        
    }completion:^( BOOL isFinished ){
        
        _nowFucking = NO;
        
        _target.constant = 0;
        [self layoutIfNeeded];
        
        self.backgroundColor = color;
        
        _Bear.backgroundColor = _colors[ _index ];
        
    }];
    
}

- (void)ON{
    
    if( _shouldDoFuck )
        return;
    
    [self doFuck];
    _shouldDoFuck = YES;
    
}

- (void)OFF{
    
    _shouldDoFuck = NO;
    
}

- (void)Toggle{
    
    if( _shouldDoFuck )
        
        _shouldDoFuck = NO;
    
    else{
        
        _shouldDoFuck = YES;
        [self doFuck];
        
    }
    
}

- (void)Once{
    
    _shouldDoFuck = NO;
    [self doFuck];
    
}

@end
