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

@interface CRTextView()

@property( nonatomic, strong ) CALayer *borderBottom;

@end

@implementation CRTextView

- (instancetype)init{
    self = [super init];
    if( self ){
        self.icon = [UILabel new];
        
        self.textView = ({
            UITextView *v = [UITextView new];
            v.textContainerInset = UIEdgeInsetsZero;
            v.textContainer.lineFragmentPadding = 0;
            v;
        });
        
        [self addAutolayoutSubviews:@[ self.icon, self.textView ]];
        self.borderBottom = [CALayer layer];
        [self.layer addSublayer:self.borderBottom];
        self.borderBottom.backgroundColor = [UIColor clearColor].CGColor;
        
        [self doLayout];
        
        self.icon.font = [UIFont MaterialDesignIconsWithSize:24];
        self.icon.textColor = [UIColor colorWithWhite:102 / 255.0 alpha:1];
        self.icon.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)doLayout{
    NSMutableArray *cons = [NSMutableArray new];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.icon to:self type:EdgeTopLeftZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.icon type:SpactecledBearFixedEqual constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.textView to:self type:EdgeTopRightBottomZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.textView to:self type:EdgeLeftZero constant:56 + 16]];
    [self addConstraints:cons];
    [cons removeAllObjects];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.borderBottom.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)makeBorder:(BOOL)que{
    UIColor *color;
    if( que )
        color = [UIColor colorWithWhite:217 / 255.0 alpha:1];
    else
        color = [UIColor clearColor];
    
    self.borderBottom.backgroundColor = color.CGColor;
}

@end
