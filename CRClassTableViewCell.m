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

@interface CRClassTableViewCell()

@property( nonatomic, strong ) UIView *wrapper;
@property( nonatomic, strong ) UIButton *husky;

@end

@implementation CRClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        
        self.startTime = [UILabel new];
        self.wrapper = [UIView new];
        self.husky = [UIButton new];
        self.className = [UILabel new];
        [self.contentView addAutolayoutSubviews:@[ self.startTime, self.wrapper ]];
        [self.wrapper addAutolayoutSubviews:@[ self.className, self.husky ]];
        [self layoutClass];
        
        self.wrapper.clipsToBounds = YES;
        self.wrapper.layer.cornerRadius = 3.0;
        self.wrapper.backgroundColor = [UIColor randomColor];
        
        self.husky.backgroundColor = [UIColor clearColor];
        [self.husky addTarget:self action:@selector(selectedHandler) forControlEvents:UIControlEventTouchUpInside];

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
                                                            constant:(56 - classNameHeight) / 2.0]];
    [cons addObject:[NSLayoutConstraint constraintWithItem:self.wrapper
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.startTime
                                                 attribute:NSLayoutAttributeRight
                                                multiplier:1.0
                                                  constant:0]];
    [self.contentView addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.husky to:self.wrapper type:EdgeAroundZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.className to:self.wrapper type:EdgeTopBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.className to:self.wrapper type:EdgeLeftRightZero constant:8]];
    [self.wrapper addConstraints:cons];
}

- (void)selectedHandler{
    if( self.handler && [self.handler respondsToSelector:@selector(CRClassTableViewCellSelectedHandler:)] )
        [self.handler CRClassTableViewCellSelectedHandler:self.indexPath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

@end
