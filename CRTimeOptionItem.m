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
        
        self.timeLabel = ({
            UILabel *time = [UILabel new];
            time.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:time];
            time;
        });
        
        [CRLayout view:@[ self.timeLabel, self.contentView ] type:CREdgeTopBottom];
        [CRLayout view:@[ self.timeLabel, self.contentView ] type:CREdgeLeftRight constants:UIEdgeInsetsMake(0, 64, 0, -64)];
    }
    return self;
}

@end
