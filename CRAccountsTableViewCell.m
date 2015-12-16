//
//  CRAccountsTableViewCell.m
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRAccountsTableViewCell.h"
#import "UIColor+CRColor.h"
#import "CRSettings.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"

@interface CRAccountsTableViewCell()

@property( nonatomic, strong ) UILabel *sele;

@property( nonatomic, strong ) CALayer *borderTop;
@property( nonatomic, strong ) CALayer *borderBottom;

@property( nonatomic, strong ) UILabel *removeLabel;

@end

@implementation CRAccountsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if( self ){
        
        UILabel *label;
        self.icon = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.layer.cornerRadius = 52 / 2.0f;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [CRSettings appFontOfSize:21 weight:UIFontWeightRegular];
            label.textColor = [UIColor whiteColor];
            label.userInteractionEnabled = NO;
            label;
        });
        
        self.accountName = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.userInteractionEnabled = NO;
            label;
        });
        
        self.sele = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont MaterialDesignIcons];
            label.textColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
            label.text = [UIFont mdiCheck];
            label.alpha = 0;
            label.userInteractionEnabled = NO;
            label;
        });
        
        self.removeLabel = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.backgroundColor = [UIColor whiteColor];
            label.hidden = YES;
            label.text = @"REMOVE";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
            label.font = [CRSettings appFontOfSize:11 weight:UIFontWeightRegular];
            label.userInteractionEnabled = NO;
            label;
        });
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.accountName];
        [self.contentView addSubview:self.sele];
        [self.contentView addSubview:self.removeLabel];
        
        [CRLayout view:@[ self.icon, self.contentView ] type:CRCenterY];
        [CRLayout view:@[ self.icon, self.contentView ] type:CREdgeLeft constants:UIEdgeInsetsMake(0, 8, 0, 0)];
        [CRLayout view:@[ self.icon ] type:CRFixedEqual constants:UIEdgeInsetsMake(52, 52, 0, 0)];
        
        [CRLayout view:@[ self.accountName, self.contentView ] type:CREdgeAround constants:UIEdgeInsetsMake(0, 72, 0, -72)];
        
        [CRLayout view:@[ self.sele, self.contentView ] type:CREdgeTopRightBottom constants:UIEdgeInsetsMake(0, 0, 0, -16)];
        [CRLayout view:@[ self.sele ] type:CRFixedWidth constants:UIEdgeInsetsMake(56, 0, 0, 0)];
        
        [CRLayout view:@[ self.removeLabel, self.contentView ] type:CREdgeTopRightBottom constants:UIEdgeInsetsMake(0, 0, 0, 0)];
        [CRLayout view:@[ self.removeLabel ] type:CRFixedWidth constants:UIEdgeInsetsMake(72, 0, 0, 0)];
        
        self.borderTop = [CALayer layer];
        self.borderBottom = [CALayer layer];
        [self.layer addSublayer:self.borderTop];
        self.borderTop.backgroundColor = self.borderBottom.backgroundColor = [UIColor colorWithWhite:200 / 255.0 alpha:1].CGColor;
    }
    return self;
}

- (void)editStyle:(BOOL)isEdit{
    if( isEdit )
        self.removeLabel.hidden = NO;
    else
        self.removeLabel.hidden = YES;
}

- (void)makeCheck{
    [UIView animateWithDuration:0.25f animations:^{ self.sele.alpha = 1; }];
}

- (void)makeUnCheck{
    [UIView animateWithDuration:0.25f animations:^{ self.sele.alpha = 0; }];
}

- (void)makeBorderTop{
    [self.layer addSublayer:self.borderTop];
}

- (void)makeBorderBottom{
    [self.layer addSublayer:self.borderBottom];
}

- (void)layoutSubviews{
    self.borderTop.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    self.borderBottom.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

@end
