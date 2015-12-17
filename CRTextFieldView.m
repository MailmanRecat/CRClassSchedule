//
//  CRTextFieldView.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTextFieldView.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"

@interface CRTextFieldView()

@property( nonatomic, strong ) CALayer *borderBottom;

@end

@implementation CRTextFieldView

- (instancetype)init{
    self = [super init];
    if( self ){
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [UIView new];
        self.icon = [UILabel new];
        leftView.translatesAutoresizingMaskIntoConstraints = NO;
        [leftView addAutolayoutSubviews:@[ self.icon ]];
        leftView.backgroundColor = [UIColor clearColor];
        [leftView addConstraints:[CRLayoutCons Layout:@[ leftView ] :CRLEqualHeightWidth :(CGFloat[]){ 72, 56, 1.0 }]];
        [leftView addConstraints:[CRLayoutCons Layout:@[ self.icon, leftView ] :CRETopLeftBottom]];
        [leftView addConstraints:[CRLayoutCons Layout:@[ self.icon ] :CRLEqualWidth :(CGFloat[]){ 56, 0, 1.0 }]];
        
        self.icon.textAlignment = NSTextAlignmentCenter;
        self.icon.font = [UIFont MaterialDesignIconsWithSize:24];
        self.icon.textColor = [UIColor colorWithWhite:102 / 255.0 alpha:1];
        self.leftView = leftView;
        
        self.borderBottom = [CALayer layer];
        [self.layer addSublayer:self.borderBottom];
        self.borderBottom.backgroundColor = [UIColor colorWithWhite:217 / 255.0 alpha:1].CGColor;
    }
    return self;
}

- (instancetype)initWithoutIcon{
    self = [super init];
    if( self ){
        self.leftViewMode = self.rightViewMode = UITextFieldViewModeAlways;
        UIView *left = [UIView new];
        UIView *right = [UIView new];
        left.translatesAutoresizingMaskIntoConstraints = right.translatesAutoresizingMaskIntoConstraints = NO;
        [left addConstraints:[CRLayoutCons Layout:@[ left ] :CRLEqualWidth :(CGFloat[]){ 16, 0, 1.0 }]];
        [right addConstraints:[CRLayoutCons Layout:@[ right ] :CRLEqualWidth :(CGFloat[]){ 16, 0, 1.0 }]];
        
        self.leftView = left;
        self.rightView = right;
        
        self.borderBottom = [CALayer layer];
        [self.layer addSublayer:self.borderBottom];
        self.borderBottom.backgroundColor = [UIColor colorWithWhite:217 / 255.0 alpha:1].CGColor;
    }
    return self;
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
