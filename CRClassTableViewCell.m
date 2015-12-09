//
//  CRClassTableViewCell.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassTableViewCell.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIColor+Theme.h"
#import "CRSettings.h"

@interface CRClassTableViewCell()

@property( nonatomic, strong ) NSArray *bottomLayoutGuide;
@property( nonatomic, strong ) NSArray *topLayoutGuide;

@property( nonatomic, strong ) CALayer *moment;
@property( nonatomic, strong ) CALayer *momentDot;

@end

@implementation CRClassTableViewCell

- (instancetype)initFromNoClass{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRClassCellNoClassID];
    if( self ){
        [self initClass];
        
        self.wrapper.backgroundColor = [UIColor clearColor];
        self.className.text = @"Don't have any class today.";
        self.className.textColor = [UIColor colorWithWhite:157 / 255.0 alpha:1];
        self.startTime.hidden = YES;
    }
    return self;
}

- (instancetype)initFromMomentWithColor:(UIColor *)color{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRClassCellMomentID];
    if( self ){
        self.moment = [CALayer layer];
        self.momentDot = [CALayer layer];
        self.momentDot.cornerRadius = 4.0f;
        self.moment.backgroundColor = self.momentDot.backgroundColor = color.CGColor;
        [self.layer addSublayer:self.moment];
        [self.layer addSublayer:self.momentDot];
        
        self.startTime = [UILabel new];
        self.startTime.font = [CRSettings appFontOfSize:15];
        self.startTime.textColor = color;
        self.startTime.text = @"Now";
        self.startTime.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.startTime];
    }
    return self;
}

- (instancetype)initFromDefault{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRClassCellDefaultID];
    if( self ){
        [self initClass];
        self.startTime.font = [CRSettings appFontOfSize:21 weight:UIFontWeightMedium];
        self.className.textColor = self.location.textColor = [UIColor whiteColor];
        self.wrapper.layer.cornerRadius = 3.0f;
        self.className.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
        self.location.font = [CRSettings appFontOfSize:14 weight:UIFontWeightThin];
    }
    return self;
}

- (void)setMomentColor:(UIColor *)color{
    self.moment.backgroundColor = self.momentDot.backgroundColor = color.CGColor;
    self.startTime.textColor = color;
}

- (void)initClass{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.startTime = [UILabel new];
    self.wrapper = [UIView new];
    self.className = [UILabel new];
    self.location = [UILabel new];
    [self.contentView addAutolayoutSubviews:@[ self.startTime, self.wrapper ]];
    [self.wrapper addAutolayoutSubviews:@[ self.className, self.location ]];
    [self layoutClass];
    
    self.wrapper.layer.shouldRasterize = YES;
    self.wrapper.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)layoutClass{
    CGFloat classNameHeight = 20;
    NSLayoutConstraint *layoutGuide;
    NSMutableArray *cons = [NSMutableArray new];

    layoutGuide = [NSLayoutConstraint constraintWithItem:self.startTime
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.contentView
                                               attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                                constant:10];
    [cons addObject:layoutGuide];
    layoutGuide = [NSLayoutConstraint constraintWithItem:self.wrapper
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.contentView
                                               attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                                constant:10];
    [cons addObject:layoutGuide];
    self.topLayoutGuide = [[NSArray alloc] initWithArray:cons];
    [self.contentView addConstraints:cons];
    [cons removeAllObjects];
    layoutGuide = [NSLayoutConstraint constraintWithItem:self.startTime
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                                constant:32];
    [cons addObject:layoutGuide];
    layoutGuide = [NSLayoutConstraint constraintWithItem:self.contentView
                                               attribute:NSLayoutAttributeBottom
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.wrapper
                                               attribute:NSLayoutAttributeBottom
                                              multiplier:1.0
                                                constant:10];
    [cons addObject:layoutGuide];
    self.bottomLayoutGuide = [[NSArray alloc] initWithArray:cons];
    
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.startTime to:self.contentView type:EdgeLeftZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.startTime type:SpactecledBearFixedWidth constant:72]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.wrapper to:self.contentView type:EdgeRightZero constant:16]];
    [cons addObject:[NSLayoutConstraint constraintWithItem:self.wrapper
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.startTime
                                                 attribute:NSLayoutAttributeRight
                                                multiplier:1.0
                                                  constant:0]];
    [self.contentView addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.className to:self.wrapper type:EdgeTopZero constant:4]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.className type:SpactecledBearFixedHeight constant:classNameHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.className to:self.wrapper type:EdgeLeftRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.location to:self.wrapper type:EdgeTopZero constant:4 + classNameHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.location to:self.wrapper type:EdgeLeftRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.location type:SpactecledBearFixedHeight constant:classNameHeight]];
    [self.wrapper addConstraints:cons];
    [cons removeAllObjects];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if( self.moment && self.momentDot ){
        self.moment.frame = CGRectMake(72, 20, self.frame.size.width - 72 - 16, 2);
        self.momentDot.frame = CGRectMake(72, 17, 8, 8);
        self.startTime.frame = CGRectMake(16, 0, 56, 40);
    }
}

- (void)makeTopWhiteSpace{
    NSLayoutConstraint *con = self.topLayoutGuide[0];
    con.constant = 20;
    con = self.topLayoutGuide[1];
    con.constant = 20;
    [self.contentView layoutIfNeeded];
}

- (void)makeBottomWhiteSpace{
    NSLayoutConstraint *con = self.bottomLayoutGuide[1];
    con.constant = 20;
    [self.contentView layoutIfNeeded];
}

- (void)makeTopWhiteStroke{
    NSLayoutConstraint *con = self.topLayoutGuide[0];
    con.constant = 10;
    con = self.topLayoutGuide[1];
    con.constant = 10;
    [self.contentView layoutIfNeeded];
}

- (void)makeBottomWhiteStroke{
    NSLayoutConstraint *con = self.bottomLayoutGuide[1];
    con.constant = 10;
    [self.contentView layoutIfNeeded];
}

@end
