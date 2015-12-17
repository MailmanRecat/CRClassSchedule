//
//  CRActionView.h
//  CRClassSchedule
//
//  Created by caine on 12/16/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRActionHandler <NSObject>

- (void)actionConfrim:(NSString *)type;

@end

@interface CRActionView : UIView

@property( nonatomic, strong ) NSLayoutConstraint *guide;

@property( nonatomic, weak ) id<CRActionHandler> handler;

- (instancetype)initWithRemove;
- (instancetype)initWithDelete;

@end
