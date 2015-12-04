//
//  BCColorPickerCell.m
//  CRClassSchedule
//
//  Created by caine on 12/3/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "BCColorPickerCell.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIView+MOREStackLayoutView.h"

@implementation BCColorPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        self.dotname = [UILabel new];
        self.dot = [UILabel new];
        [self addAutolayoutSubviews:@[ self.dotname, self.dot ]];
        [self doLayout];
        
        self.dot.font = [UIFont MaterialDesignIconsWithSize:20];
        self.dot.backgroundColor = [UIColor clearColor];
        self.dot.textAlignment = NSTextAlignmentCenter;
        self.dot.text = [UIFont mdiCheckboxBlankCircleOutline];
    }
    return self;
}

- (void)doLayout{
    NSMutableArray *cons = [NSMutableArray new];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.dot to:self type:EdgeTopLeftBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.dot type:SpactecledBearFixedWidth constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.dotname to:self type:EdgeTopRightBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.dotname to:self type:EdgeLeftZero constant:56]];
    [self addConstraints:cons];
    [cons removeAllObjects];
}

- (void)statusON{
    self.dot.text = [UIFont mdiCheckboxBlankCircle];
}

- (void)statusOFF{
    self.dot.text = [UIFont mdiCheckboxBlankCircleOutline];
}

@end
