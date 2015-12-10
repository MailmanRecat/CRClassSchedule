//
//  CRAccountsTableViewCell.h
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRClassAccount.h"

@interface CRAccountsTableViewCell : UITableViewCell

@property( nonatomic, strong ) UILabel *icon;
@property( nonatomic, strong ) UILabel *accountName;

- (void)makeCheck;
- (void)makeUnCheck;

- (void)makeBorderTop;
- (void)makeBorderBottom;

@end
