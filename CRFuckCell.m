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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [CRLayout view:@[ self.icon, self.contentView ] type:CREdgeTopLeftBottom constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ self.icon ] type:CRFixedWidth constants:UIEdgeInsetsMake(56, 0, 0, 0)];
    [CRLayout view:@[ self.nameLabel, self.contentView ] type:CREdgeAround constants:UIEdgeInsetsMake(0, 72, 0, -8)];
}

@end
