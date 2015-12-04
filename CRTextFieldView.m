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
        self.icon = [UILabel new];
        self.icon.translatesAutoresizingMaskIntoConstraints = NO;
        [self.icon addConstraints:[NSLayoutConstraint SpactecledBearFixed:self.icon type:SpactecledBearFixedEqual constant:56]];
        
        self.icon.textAlignment = NSTextAlignmentCenter;
        self.icon.font = [UIFont MaterialDesignIconsWithSize:21];
        self.icon.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        self.leftView = self.icon;
        
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

@end
