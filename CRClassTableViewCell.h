//
//  CRClassTableViewCell.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRClassTableViewCell : UITableViewCell

@property( nonatomic, strong ) UIView *wrapper;
@property( nonatomic, strong ) UILabel *startTime;
@property( nonatomic, strong ) UILabel *className;

@end
