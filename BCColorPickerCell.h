//
//  BCColorPickerCell.h
//  CRClassSchedule
//
//  Created by caine on 12/3/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCColorPickerCell : UITableViewCell

@property( nonatomic, strong ) UILabel *dotname;
@property( nonatomic, strong ) UILabel *dot;

- (void)statusON;
- (void)statusOFF;

@end
