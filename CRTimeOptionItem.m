//
//  CRTimeOptionItem.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTimeOptionItem.h"
#import "UIView+MOREStackLayoutView.h"

@implementation CRTimeOptionItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        self.timeLabel = [UILabel new];
        [self.contentView addAutolayoutSubviews:@[ self.timeLabel ]];
        [self.contentView addConstraints:[NSLayoutConstraint SpactecledBearEdeg:self.timeLabel to:self.contentView type:EdgeTopBottomZero]];
        [self.contentView addConstraints:[NSLayoutConstraint SpactecledBearEdeg:self.timeLabel to:self.contentView
                                                                           type:EdgeLeftRightZero constant:56 + 8]];
    }
    return self;
}

@end
