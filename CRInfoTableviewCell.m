//
//  CRInfoTableviewCell.m
//  CRClassSchedule
//
//  Created by caine on 12/17/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRInfoTableviewCell.h"
#import "UIView+CRLayout.h"
#import "CRSettings.h"

@interface CRInfoTableviewCell()

@property( nonatomic, strong ) UIView *border;

@end

@implementation CRInfoTableviewCell

- (instancetype)init{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRInfoTableViewCellID];
    if( self ){
        
        UILabel *label;
        self.subLabel = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
            label.font = [CRSettings appFontOfSize:15 weight:UIFontWeightRegular];
            label;
        });
        
        self.maiLabel = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor colorWithWhite:59 / 255.0 alpha:1];
            label.font = [CRSettings appFontOfSize:19 weight:UIFontWeightRegular];
            label;
        });
        
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.maiLabel];
        [self layoutClass];
        
        UIView *borderBottom = [UIView new];
        borderBottom.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:borderBottom];
        borderBottom.hidden = YES;
        borderBottom.backgroundColor = [UIColor colorWithWhite:200 / 255.0 alpha:1];
        
        [borderBottom.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
        [borderBottom.heightAnchor constraintEqualToConstant:1].active = YES;
        [borderBottom.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [borderBottom.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        
        self.border = borderBottom;
    }
    return self;
}

- (void)layoutClass{
    [CRLayout view:@[ self.subLabel, self.contentView ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(8, 32, 0, -16)];
    [CRLayout view:@[ self.subLabel ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 20, 0, 0)];
    [CRLayout view:@[ self.maiLabel, self.contentView ] type:CREdgeAround constants:UIEdgeInsetsMake(28, 32, -8, -16)];
}

- (void)makeBorder:(BOOL)hidden{
    self.border.hidden = !hidden;
}

@end
