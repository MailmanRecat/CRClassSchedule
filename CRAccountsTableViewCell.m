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

@end

@implementation CRAccountsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if( self ){
        
        NSMutableArray *cons = [NSMutableArray new];
        UILabel *icon = [UILabel new];
        UILabel *name = [UILabel new];
        UILabel *sele = [UILabel new];
        [self addAutolayoutSubviews:@[ icon, name, sele ]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:icon to:self type:EdgeCenterY]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:name to:self type:EdgeCenterY]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:sele to:self type:EdgeCenterY]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:name to:self type:EdgeLeftRightZero constant:56 + 16]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:name type:SpactecledBearFixedHeight constant:56]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:icon type:SpactecledBearFixedEqual constant:52]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:icon to:self type:EdgeLeftZero constant:8]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:sele type:SpactecledBearFixedEqual constant:56]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:sele to:self type:EdgeRightZero constant:16]];
        [self addConstraints:cons];
        [cons removeAllObjects];
        
        icon.layer.cornerRadius = 52 / 2.0f;
        icon.clipsToBounds = YES;
        icon.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
        icon.textAlignment = NSTextAlignmentCenter;
        icon.font = [CRSettings appFontOfSize:25];
        icon.textColor = [UIColor whiteColor];
        
        sele.textAlignment = NSTextAlignmentRight;
        sele.font = [UIFont MaterialDesignIcons];
        sele.textColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
        sele.text = [UIFont mdiCheck];
        sele.alpha = 0;
        
        self.icon = icon;
        self.accountName = name;
        self.sele = sele;
        self.borderTop = [CALayer layer];
        self.borderBottom = [CALayer layer];
        [self.layer addSublayer:self.borderTop];
        self.borderTop.backgroundColor = self.borderBottom.backgroundColor = [UIColor colorWithWhite:200 / 255.0 alpha:1].CGColor;
    }
    return self;
}

- (void)check{
    [UIView animateWithDuration:0.25f animations:^{ self.sele.alpha = 1; }];
}

- (void)unCheck{
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
