//
//  CRFpsLabel.m
//  CRClassSchedule
//
//  Created by caine on 12/18/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRFpsLabel.h"
#import "CRSettings.h"
#import "UnkowProxy.h"

@interface CRFpsLabel(){
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    
    NSTimeInterval _unknow;
}

@end

@implementation CRFpsLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.layer.cornerRadius = 3.0f;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.77];
        self.textColor = [UIColor whiteColor];
        self.font = [CRSettings appFontOfSize:15 weight:UIFontWeightRegular];
        
        _link = [CADisplayLink displayLinkWithTarget:[UnkowProxy proxyWithTarget:self] selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc{
    [_link invalidate];
}

- (void)tick:(CADisplayLink *)lin{
    if( _lastTime == 0 ){
        _lastTime = lin.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = lin.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = lin.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    self.textColor = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    self.text = [NSString stringWithFormat:@"%d FPS", (int)round(fps)];
}

@end
