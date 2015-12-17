//
//  CRFuckCell.h
//  CRClassSchedule
//
//  Created by caine on 12/7/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CRFuckCellID = @"CRFuckCellID";
static NSString *const CRFuckCellNoteID = @"CRFuckCellNoteID";

@interface CRFuckCell : UITableViewCell

@property( nonatomic, strong ) UILabel *icon;
@property( nonatomic, strong ) UILabel *subLabel;
@property( nonatomic, strong ) UILabel *nameLabel;

- (instancetype)initNoteType;

@end
