//
//  CRTextView.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTextView.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"

@implementation CRTextView

- (instancetype)init{
    self = [super init];
    if( self ){
        self.icon = [UILabel new];
        self.textView = [UITextView new];
        [self addAutolayoutSubviews:@[ self.icon, self.textView ]];
        
        [self doLayout];
        
        self.icon.font = [UIFont MaterialDesignIconsWithSize:21];
        self.icon.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        self.icon.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)doLayout{
    NSMutableArray *cons = [NSMutableArray new];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.icon to:self type:EdgeTopLeftZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.icon type:SpactecledBearFixedEqual constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.textView to:self type:EdgeTopRightBottomZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.textView to:self type:EdgeLeftZero constant:56]];
    [self addConstraints:cons];
    [cons removeAllObjects];
}

@end
