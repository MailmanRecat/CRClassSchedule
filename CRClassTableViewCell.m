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

@end

@implementation CRClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        
        self.startTime = [UILabel new];
        self.wrapper = [UIView new];
        self.className = [UILabel new];
        [self.contentView addAutolayoutSubviews:@[ self.startTime, self.wrapper ]];
        [self.wrapper addAutolayoutSubviews:@[ self.className ]];
        [self layoutClass];
        
        self.wrapper.clipsToBounds = YES;
        self.wrapper.layer.cornerRadius = 3.0;
//        self.wrapper.backgroundColor = [UIColor randomColor];
        
        self.startTime.font = [CRSettings appFontOfSize:21];
    }
    return self;
}

- (void)layoutClass{
    CGFloat classNameHeight = 36;
    NSMutableArray *cons = [NSMutableArray new];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.startTime to:self.contentView type:EdgeLeftZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.startTime to:self.contentView type:EdgeTopBottomZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.startTime type:SpactecledBearFixedWidth constant:72]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.wrapper to:self.contentView type:EdgeRightZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.wrapper to:self.contentView type:EdgeTopBottomZero
                                                            constant:10]];
    [cons addObject:[NSLayoutConstraint constraintWithItem:self.wrapper
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.startTime
                                                 attribute:NSLayoutAttributeRight
                                                multiplier:1.0
                                                  constant:0]];
    [self.contentView addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.className to:self.wrapper type:EdgeTopZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.className type:SpactecledBearFixedHeight constant:classNameHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.className to:self.wrapper type:EdgeLeftRightZero constant:8]];
    [self.wrapper addConstraints:cons];
}

@end
