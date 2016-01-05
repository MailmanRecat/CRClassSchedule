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
#import "CRTheme.h"

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
        self.className.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
        self.className.text = @"No have any class today.";
        self.className.textColor = [UIColor colorWithWhite:137 / 255.0 alpha:1];
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
        self.startTime.font = [CRSettings appFontOfSize:17 weight:UIFontWeightRegular];
        self.startTime.textColor = color;
        self.startTime.text = @"Now";
        self.startTime.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.startTime];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initFromDefault{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRClassCellDefaultID];
    if( self ){
        [self initClass];
        self.startTime.font = [CRSettings appFontOfSize:21 weight:UIFontWeightMedium];
        self.startTime.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        self.className.textColor = self.location.textColor = [UIColor whiteColor];
        self.wrapper.layer.cornerRadius = 3.0f;
        self.className.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
        self.location.font = [CRSettings appFontOfSize:14 weight:UIFontWeightRegular];
    }
    return self;
}

- (instancetype)initFromWhite{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRClassCellWhiteID];
    if( self ){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initFromColorTypeString:(NSString *)string{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    if( self ){
        [self initClass];
        
        UIColor *themeColor = [CRTheme themeColorFromString:string];
        self.startTime.textColor = self.wrapper.backgroundColor = themeColor;
        
        self.startTime.font = [CRSettings appFontOfSize:17 weight:UIFontWeightRegular];
        self.className.textColor = self.location.textColor = [UIColor whiteColor];
        self.wrapper.layer.cornerRadius = 3.0f;
        self.className.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
        self.location.font = [CRSettings appFontOfSize:14 weight:UIFontWeightRegular];
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

    [self.startTime.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = YES;
    [self.startTime.heightAnchor constraintEqualToConstant:32].active = YES;
    [self.startTime.rightAnchor constraintEqualToAnchor:self.wrapper.leftAnchor constant:-8].active = YES;
    [self.wrapper.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = YES;
    [self.wrapper.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.wrapper.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16].active = YES;
    
    [CRLayout view:@[ self.startTime, self.contentView ] type:CREdgeLeft constants:UIEdgeInsetsMake(0, 16, 0, 0)];
    [CRLayout view:@[ self.startTime ] type:CRFixedWidth constants:UIEdgeInsetsMake(56, 0, 0, 0)];
    [CRLayout view:@[ self.className, self.wrapper ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(8, 8, 0, -8)];
    [CRLayout view:@[ self.className ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, classNameHeight, 0, 0)];
    [CRLayout view:@[ self.location, self.wrapper ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(8 + classNameHeight, 8, 0, -8)];
    [CRLayout view:@[ self.location ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, classNameHeight, 0, 0)];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if( self.moment && self.momentDot ){
        
        CGSize size = self.frame.size;
        
        self.moment.frame = CGRectMake(72, (size.height - 2) / 2, size.width - 72 - 16, 2);
        self.momentDot.frame = CGRectMake(72, (size.height - 8) / 2, 8, 8);
        self.startTime.frame = CGRectMake(8, 0, 56, size.height);
    }
}

@end
