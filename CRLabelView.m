//
//  CRLabelView.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRLabelView.h"
#import "UIView+MOREStackLayoutView.h"
#import "CRSettings.h"

@implementation CRLabelView

- (instancetype)init{
    self = [super init];
    if( self ){
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.layer.cornerRadius = 3.0f;
        
        self.light = [UILabel new];
        self.strong = [UILabel new];
        self.button = [UIButton new];
        [self addAutolayoutSubviews:@[ self.button, self.light, self.strong ]];
        [self doLayout];
        
        self.button.backgroundColor = [UIColor clearColor];
        self.light.backgroundColor = self.strong.backgroundColor = [UIColor clearColor];
        self.light.textAlignment = NSTextAlignmentRight;
        self.light.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        self.strong.textColor = [UIColor whiteColor];
        self.light.font = [CRSettings appFontOfSize:15];
        self.strong.font = [CRSettings appFontOfSize:19];
    }
    return self;
}

- (void)doLayout{
    NSMutableArray *cons = [NSMutableArray new];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.button to:self type:EdgeAroundZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.light type:SpactecledBearFixedWidth constant:72]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.light to:self type:EdgeLeftZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.light to:self type:EdgeTopBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.strong to:self type:EdgeRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.strong to:self type:EdgeTopBottomZero]];
    [cons addObject:[NSLayoutConstraint constraintWithItem:self.strong
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.light
                                                 attribute:NSLayoutAttributeRight
                                                multiplier:1.0
                                                  constant:8]];
    [self addConstraints:cons];
}

@end
