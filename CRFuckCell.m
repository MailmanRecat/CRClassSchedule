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
        [self initClass];
        [self makeLayout];
    }
    return self;
}

- (instancetype)initNoteType{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRFuckCellNoteID];
    if( self ){
        [self initNoteClass];
        [self makeLayoutNote];
    }
    return self;
}

- (void)initClass{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label;
    self.icon = ({
        label = [UILabel new];
        label.font = [UIFont MaterialDesignIconsWithSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:102 / 255.0 alpha:1];
        label;
    });
    
    self.nameLabel = ({
        label = [UILabel new];
        label.textColor = [UIColor colorWithWhite:59 / 255.0 alpha:1];
        label.adjustsFontSizeToFitWidth = YES;
        label;
    });
    
    self.subLabel = ({
        label = [UILabel new];
        label.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        label;
    });
    [self.contentView addAutolayoutSubviews:@[ self.icon, self.nameLabel, self.subLabel ]];
}

- (void)initNoteClass{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label;
    self.icon = ({
        label = [UILabel new];
        label.font = [UIFont MaterialDesignIconsWithSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:102 / 255.0 alpha:1];
        label;
    });
    
    self.nameText = ({
        UITextView *v = [UITextView new];
        v.textColor = [UIColor colorWithWhite:59 / 255.0 alpha:1];
        v.textContainerInset = UIEdgeInsetsZero;
        v.textContainer.lineFragmentPadding = 0;
        v.editable = NO;
        v;
    });
    
    self.subLabel = ({
        label = [UILabel new];
        label.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        label;
    });
    
    [self.contentView addAutolayoutSubviews:@[ self.icon, self.nameText, self.subLabel ]];
}

- (void)makeLayout{
    [CRLayout view:@[ self.icon, self.contentView ] type:CREdgeTopLeftBottom constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ self.icon ] type:CRFixedWidth constants:UIEdgeInsetsMake(56, 0, 0, 0)];
    [CRLayout view:@[ self.subLabel, self.contentView ] type:CREdgeAround constants:UIEdgeInsetsMake(8, 72, -30, -8)];
    [CRLayout view:@[ self.nameLabel, self.contentView ] type:CREdgeAround constants:UIEdgeInsetsMake(30, 72, -8, -8)];
}

- (void)makeLayoutNote{
    [CRLayout view:@[ self.icon, self.contentView ] type:CREdgeTopLeft constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ self.icon ] type:CRFixedEqual constants:UIEdgeInsetsMake(56, 56, 0, 0)];
    [CRLayout view:@[ self.subLabel, self.contentView ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(8, 72, 0, -8)];
    [CRLayout view:@[ self.subLabel ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 22, 0, 0)];
    
    [CRLayout view:@[ self.nameText, self.contentView ] type:CREdgeAround constants:UIEdgeInsetsMake(30, 72, -8, -8)];
}

@end
