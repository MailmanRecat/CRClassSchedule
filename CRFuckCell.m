//
//  CRFuckCell.m
//  CRClassSchedule
//
//  Created by caine on 12/7/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRFuckCell.h"

#import "UIFont+MaterialDesignIcons.h"
#import "UIView+CRLayout.h"
#import "UIView+MOREStackLayoutView.h"

@implementation CRFuckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:CRFuckCellID];
    if( self ){
        self.icon = [UILabel new];
        self.nameLabel = [UILabel new];
        [self.contentView addAutolayoutSubviews:@[ self.icon, self.nameLabel ]];
        
        self.icon.font = [UIFont MaterialDesignIconsWithSize:21];
        self.icon.textAlignment = NSTextAlignmentCenter;
        self.icon.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        [self makeLayout];
    }
    return self;
}

- (void)makeLayout{
    [self.contentView CRLayoutCache:[CRLayoutCons Layout:@[ self.icon, self.contentView ] :CRETopLeftBottom
                                                        :(CGFloat[]){ 0, 0, 0, 0, 1.0 }]];
    [self.contentView CRLayoutCache:[CRLayoutCons Layout:@[ self.icon ] :CRLEqualWidth :(CGFloat[]){ 56, 0, 1.0 }]];
    [self.contentView CRLayoutCache:[CRLayoutCons Layout:@[ self.nameLabel, self.contentView ] :CREAround
                                                        :(CGFloat[]){ 0, -8, 0, 72, 1.0 }]];
    [self.contentView CRLayoutMake];
}

@end
